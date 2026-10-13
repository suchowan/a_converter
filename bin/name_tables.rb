# encoding: utf-8
# name_tables.rb -- the maintained name tables (tables/*.csv): reading, checking, attaching to units.json
#
#   tables/names_<system>.csv  name | [variants] | texts | description | note
#        name : the URI names of one unit, "a | b" (the first is the one used in expressions)
#        texts: the conv.rb texts this unit stands for, "a | b"
#   tables/entries.csv         dimension | key | expression | note
#        one row per conv.rb row (key = the conv.rb text); expression = product of names,
#        "SYS/name^p" (no SYS: UUS, "gravitic/" the gravitic variant), "a = b" for the same value
#        written two ways, "°X" for the point on a scale whose reference is X
#   tables/implicit.csv        dimension | implicit | note
#        the constant the SI unit of that dimension silently sets to 1 (Hz counts cycles, ...)
#   tables/variant_names.csv   name | variant | unit | description | note
#        names a UUS unit has in one variant only (harmon = the harmonic meter); they stand for
#        that variant of the unit and are not used in expressions
#
# NameTables.check(units, dir) checks the tables against units (the units.json structure):
# every conv.rb row has one entry and every entry a conv.rb row; names are unique within a system;
# every name in an expression exists; "°" appears exactly on the scale dimensions; and the value of
# every expression equals the conv.rb value of its row, in every variant.
# NameTables.attach(units, dir) does the same and, if nothing is wrong, adds the names to units.
require 'csv'

module NameTables
  SYSTEMS = %w[UUS SI TGM IDUS TONAL TRAD CGS CONST]
  VARS    = ['', 'universal', 'GCD', 'exact']     # '' = harmonic UUS and plain TGM
  UUS_VARS = ['', 'universal', 'GCD']; TGM_VARS = ['', 'exact']
  UUS_VARIANT_NAMES = %w[harmonic universal GCD]
  # which dimensions hold the units of the kind an implicit constant belongs to
  KIND = { 'cycle' => ['Plane angle', 'Angular velocity'], 'turn' => ['Solid angle', 'Plane angle'],
           'naturalMol' => ['Amount of substance'] }

  Result = Struct.new(:names, :entries, :implicit, :scale, :value, :home, :errors, :notes, :variant_names)

  module_function

  # read as bytes and parse as a string: CSV.read on Windows (text mode) can misparse CRLF files
  def read(dir, f)
    text = File.binread(File.join(dir, f)).force_encoding('UTF-8').delete_prefix("﻿")
    CSV.parse(text, headers: true, row_sep: text.include?("\r\n") ? "\r\n" : "\n").map(&:to_h)
  rescue CSV::MalformedCSVError => e
    raise "#{f}: #{e.message}"
  end

  def num(f, v) = f.is_a?(Hash) ? (f[v] || f['']) : f

  # {variant => x} -> the form units.json uses for factors: a number, or a hash keyed by the variants that differ
  def pack(h)
    if UUS_VARS.map { |v| h[v] }.uniq.size > 1 then UUS_VARS.to_h { |v| [v, h[v]] }
    elsif TGM_VARS.map { |v| h[v] }.uniq.size > 1 then TGM_VARS.to_h { |v| [v, h[v]] }
    else h[''] end
  end

  def check(units, dir)
    errors = []; notes = []
    # ---- names
    names = {}                                # "SYS/name" -> row of names_<sys>.csv
    SYSTEMS.each do |sys|
      f = "names_#{sys.downcase}.csv"
      next errors << "missing #{f}" unless File.exist?(File.join(dir, f))
      read(dir, f).each do |r|
        r['sys'] = sys; r['names'] = r['name'].to_s.split(' | ')
        r['names'].each do |n|
          errors << "#{sys}: bad name #{n.inspect}" unless n =~ /\A[A-Za-z][A-Za-z0-9]*\z/ || (sys == 'CONST' && n =~ /\A\d+\z/)
          errors << "#{sys}: name #{n} used twice" if names["#{sys}/#{n}"]
          names["#{sys}/#{n}"] = r
        end
        errors << "#{sys}: #{r['name']} has no texts" if r['texts'].to_s.empty?
      end
    end
    # ---- names of one variant
    vnames = File.exist?(File.join(dir, 'variant_names.csv')) ? read(dir, 'variant_names.csv') : []
    vnames.each do |r|
      n = r['name'].to_s
      errors << "variant_names: bad name #{n.inspect}" unless n =~ /\A[A-Za-z][A-Za-z0-9]*\z/
      errors << "variant_names: #{n} is also a UUS name" if names["UUS/#{n}"]
      errors << "variant_names: #{n}: unknown variant #{r['variant']}" unless UUS_VARIANT_NAMES.include?(r['variant'])
      u = names["UUS/#{r['unit']}"]
      if !u then errors << "variant_names: #{n}: no UUS unit #{r['unit']}"
      elsif !u['variants'].to_s.split.include?(r['variant']) then errors << "variant_names: #{n}: #{r['unit']} has no #{r['variant']} variant"
      end
    end
    errors << 'variant_names: a name given twice' if vnames.map { |r| r['name'] }.uniq.size != vnames.size
    # ---- entries vs conv.rb rows
    dims = units['dimensions'].reject { |d| d['calendar'] }.to_h { |d| [d['title'], d] }
    key_of = ->(u) { n = u['name']; n.is_a?(Hash) ? (n['GCD'] || n['']) : n }
    entries = read(dir, 'entries.csv')
    by_key = entries.group_by { |e| [e['dimension'], e['key']] }
    by_key.each { |k, es| errors << "entry #{k.join(' / ')} given #{es.size} times" if es.size > 1 }
    dims.each { |t, d| d['units'].each_with_index { |u, i|
      e = by_key[[t, key_of[u]]]&.first or next errors << "conv.rb row without entry: #{t} / #{key_of[u]}"
      e['u'] = u; e['dim'] = d; e['row'] = i } }
    entries.each { |e| errors << "entry without conv.rb row: #{e['dimension']} / #{e['key']}" unless e['u'] }
    # ---- names in expressions
    scale = ['Thermodynamic temperature'] +
      dims.values.select { |d| (d['defaults'] || {}).values_at('fl', 'tl').any? { |v| v.to_i != 0 } }.map { |d| d['title'] }
    ref = lambda do |t|                       # token as written -> its key in the names index, or nil
      n = t.sub(/\A°/, '').sub(/\^-?\d+\z/, '')
      if n.start_with?('gravitic/')            # the gravitic variant is a unit of its own
        r = names["UUS/#{n.delete_prefix('gravitic/')}"]; r && r['variants'].to_s.include?('gravitic') ? n : nil
      elsif n.include?('/') then names[n] && n
      else names["UUS/#{n}"] && n end
    end
    entries.each do |e|
      x = e['expression'].to_s
      next errors << "#{e['dimension']} / #{e['key']}: no expression" if x.empty?
      x.split(/\s*=\s*/).each do |part|
        sc = part.start_with?('°')
        errors << "#{e['dimension']} / #{e['key']}: #{sc ? 'unexpected' : 'missing'} °" if sc != scale.include?(e['dimension'])
        part.split(/\s+/).each { |t| errors << "#{e['dimension']} / #{e['key']}: unknown name #{t}" unless ref[t] }
      end
    end
    res = Result.new(names, entries, {}, scale, {}, {}, errors, notes, vnames)
    return res unless errors.empty?

    # ---- values
    implicit = read(dir, 'implicit.csv').to_h { |r| [r['dimension'], r['implicit']] }
    res.implicit = implicit
    parts = ->(e) { e['expression'].split(/\s*=\s*/).map { |p| p.sub(/\A°/, '').split(/\s+/).map { |t| n, q = t.split('^'); [ref[n], (q || 1).to_i] } } }
    alone = {}                                # name key -> entries consisting of that name only
    entries.each { |e| e['parts'] = parts[e]; e['parts'].each { |p| (alone[p[0][0]] ||= []) << e if p.size == 1 && p[0][1] == 1 } }
    home = {}                                 # name key -> its own row, outside the implicit dimensions
    alone.each { |k, es| e = es.find { |x| !implicit[x['dimension']] }; home[k] = e if e }
    entries.each do |e|
      h = implicit[e['dimension']]; mult = VARS.to_h { |v| [v, 1.0] }
      if h
        n, q = h.split('^'); kind = KIND[n] or raise "implicit.csv: unknown constant #{n}"
        if e['parts'].flatten(1).any? { |k, _| home[k] && kind.include?(home[k]['dimension']) }
          base = home[n] or raise "implicit.csv: #{n} has no row of its own"
          mult = VARS.to_h { |v| [v, num(base['u']['factor'], v)**(q || 1).to_i] }
        end
      end
      e['val'] = VARS.to_h { |v| [v, num(e['u']['factor'], v) * mult[v]] }
    end
    value = {}
    alone.each { |k, es| value[k] = es.first['val'] }
    alone.each { |k, es| es.each { |e| d = VARS.map { |v| ((e['val'][v] - value[k][v]) / value[k][v]).abs }.max
      errors << "#{k} has two values: #{es.first['dimension']} / #{es.first['key']} and #{e['dimension']} / #{e['key']}" if d > 1e-9 } }
    loop do                                   # names that never stand alone: from a row where they are the only unknown
      added = false
      entries.each { |e| e['parts'].each { |p|
        unk = p.reject { |k, _| value[k] }.map(&:first).uniq
        next unless unk.size == 1
        k = unk[0]; q = p.select { |m, _| m == k }.sum { |_, x| x }
        value[k] = VARS.to_h { |v| [v, (e['val'][v] / p.reject { |m, _| m == k }.reduce(1.0) { |a, (m, x)| a * value[m][v]**x })**(1.0 / q)] }
        notes << "#{k} = #{'%.9g' % value[k]['']} (only inside compounds; from #{e['dimension']} / #{e['key']})"
        added = true } }
      break unless added
    end
    entries.each do |e|
      e['parts'].each do |p|
        next if p.size == 1 && p[0][1] == 1
        d = VARS.map { |v| x = p.reduce(1.0) { |a, (k, q)| a * value[k][v]**q }; ((x - e['val'][v]) / e['val'][v]).abs }.max
        e['checked'] = true
        errors << format('%s / %s: %s is off by %.3g', e['dimension'], e['key'], e['expression'], d) if d > 1e-9
      end
    end
    res.value = value; res.home = home
    res
  end

  # adds to units (the units.json structure):
  #   dimensions[i]['scale']        true on the scale dimensions (expressions there are written °X)
  #   dimensions[i]['implicit']     the constant the dimension's SI unit sets to 1, if any
  #   dimensions[i]['units'][j]['expression']   the row as an expression of names
  #   'names' : name as written in expressions ("meter", "SI/meter", "gravitic/meter") ->
  #       system, label (the name expressions use), description, variants (UUS), value (SI value,
  #       a number or a hash by variant, like 'factor'), and 'row' [dimension index, unit index] of the
  #       row that is this unit alone, if there is one
  def attach(units, dir)
    r = check(units, dir)
    return r unless r.errors.empty?
    units['dimensions'].each do |d|
      next if d['calendar']
      d['scale'] = true if r.scale.include?(d['title'])
      d['implicit'] = r.implicit[d['title']] if r.implicit[d['title']]
    end
    r.entries.each { |e| e['u']['expression'] = e['expression'] }
    index = {}
    r.names.values.uniq.each do |row|
      label = row['names'].first
      keys = row['names'].map { |n| row['sys'] == 'UUS' ? n : "#{row['sys']}/#{n}" }
      keys += row['names'].map { |n| "gravitic/#{n}" } if row['sys'] == 'UUS' && row['variants'].to_s.include?('gravitic')
      keys.each do |k|
        grav = k.start_with?('gravitic/')
        lk = grav ? "gravitic/#{label}" : (row['sys'] == 'UUS' ? label : "#{row['sys']}/#{label}")
        desc = row['description'].to_s
        desc = "gravitic #{desc.sub(/\(12\.\)\z/, '')}" if grav
        rec = { 'system' => row['sys'], 'label' => lk, 'description' => desc }
        rec['variants'] = (grav ? ['gravitic'] : row['variants'].to_s.split - ['gravitic']) if row['sys'] == 'UUS'
        v = r.value[lk]
        rec['value'] = pack(v) if v
        h = r.home[lk]; rec['row'] = [h['dim']['index'], h['row']] if h
        index[k] = rec
      end
    end
    r.variant_names.each do |vn|
      base = index[vn['unit']]
      v = r.value[vn['unit']]; key = vn['variant'] == 'harmonic' ? '' : vn['variant']
      rec = { 'system' => 'UUS', 'label' => vn['unit'], 'variant' => vn['variant'],
              'description' => vn['description'].to_s.empty? ? "#{vn['variant']} #{vn['unit']}" : vn['description'],
              'variants' => [vn['variant']] }
      rec['value'] = v[key] if v
      rec['row'] = base['row'] if base['row']
      index[vn['name']] = rec
    end
    units['names'] = index.sort.to_h
    r
  end
end
