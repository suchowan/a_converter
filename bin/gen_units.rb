#!/usr/bin/env ruby
# gen_units.rb -- generate units.json from conv.rb and the name tables
#
# conv.rb stays the single source of the definitions (constants and the
# Units table). This script evaluates conv.rb once per UUS variant and
# writes the results; it contains no unit values of its own.
# The name tables (tables/*.csv, see name_tables.rb) give every row its
# expression and every unit its URI names; they are checked against the
# values from conv.rb, and units.json is written only if they agree.
#
#   ruby gen_units.rb -o units.json [path/to/conv.rb]   # writes the file only if all checks pass (LF)
#   ruby gen_units.rb [path/to/conv.rb] > units.json     # the same to stdout (a failed run leaves it empty)
#   ruby gen_units.rb --check [path/to/conv.rb]   # exit 1 if units.json is stale
#   options: --tables DIR   the name tables (default: tables next to this script)
#            --no-tables    conv.rb values only, as before 2026-10
#            --verbose      list the names that occur only inside compound units
#
# conv.rb fixes its mode (variant) at load time from QUERY_STRING, so each
# variant is evaluated in a separate Ruby process.

require 'json'
require 'rbconfig'
require_relative 'name_tables'

# mode codes passed to conv.rb as m=... ; bits 8-9 select the UUS variant, bits 10-11 the TGM one
RUNS = {
  'harmonic'  => '100f0',   # UUS ""          , TGM "" (Lightvlos not exactly)
  'universal' => '102f0',   # UUS "universal"
  'GCD'       => '103f0',   # UUS "GCD"
  'exact'     => '108f0',   # TGM "exact"     (Lightvlos exactly)
}
VARIANTS = RUNS                      # kept for the --check path
DEFAULT_VARIANT = 'harmonic'
# how a value that differs between runs is keyed in units.json ("" = the default variant)
UUS_KEYS = { 'harmonic' => '', 'universal' => 'universal', 'GCD' => 'GCD' }
TGM_KEYS = { 'harmonic' => '', 'exact' => 'exact' }

def dump_one(conv)
  ENV['QUERY_STRING'] = "m=#{ARGV_MODE}"
  $stdout = File.open(File::NULL, 'w')       # conv.rb prints nothing at load, but be safe
  load conv
  $stdout = STDOUT
  prefixes = Unit::Prefixes.map { |k, v|
    [k.to_s, { 'radix' => v[0], 'steps' => v[1..-1].map { |n, e| [n, e] } }]
  }.to_h
  dims = Unit::Units.each_with_index.map do |d, i|
    head = d[0]
    units = d[1..-1]
    calendar = units.any? { |u| u.kind_of?(Unit::CalendarContainer) }
    {
      'index'    => i,
      'title'    => head[1],
      'category' => head[0],
      'defaults' => head[2] && head[2].reject { |_, v| v.kind_of?(Time) },
      'calendar' => calendar,
      'units'    => calendar ? [] : units.map { |u|
        {
          'name'    => u.name,
          'factor'  => u.quantity,                    # SI value of one unit
          'prefix'  => u.prefix && u.prefix.to_s,
          'power'   => u.power,
          'subunit' => u.subunit,
          'offset'  => u.instance_variable_get(:@offset),
          'sign'    => u.instance_variable_get(:@sign),
        }
      }
    }
  end
  { 'prefixes' => prefixes, 'dimensions' => dims }
end

def merge(results)
  base = results[DEFAULT_VARIANT]
  out = {
    'generator' => 'gen_units.rb',
    'source'    => File.basename(CONV),
    'variants'  => { 'UUS' => UUS_KEYS.values, 'TGM' => TGM_KEYS.values },
    'prefixes'  => base['prefixes'],
    'dimensions'=> []
  }
  base['dimensions'].each_with_index do |d, i|
    RUNS.keys.each do |r|
      n = results[r]['dimensions'][i]['units'].size
      raise "unit count differs in #{d['title']} (#{r}): #{n} vs #{d['units'].size}" unless n == d['units'].size
    end
    dd = d.dup
    dd['units'] = d['units'].each_with_index.map do |u, j|
      uu = u.dup
      val = ->(r, key) { results[r]['dimensions'][i]['units'][j][key] }
      %w[name factor offset].each do |key|
        uus = UUS_KEYS.map { |r, k| [k, val[r, key]] }.to_h
        tgm = TGM_KEYS.map { |r, k| [k, val[r, key]] }.to_h
        uu[key] = if uus.values.uniq.size > 1 then uus
                  elsif tgm.values.uniq.size > 1 then tgm
                  else val['harmonic', key] end
      end
      %w[prefix power subunit sign].each do |key|
        raise "#{key} differs across runs: #{d['title']} / #{u['name']}" unless RUNS.keys.map { |r| val[r, key] }.uniq.size == 1
      end
      uu
    end
    out['dimensions'] << dd
  end
  out
end

if ARGV[0] == '--one'
  ARGV_MODE = ARGV[1]
  CONV = File.expand_path(ARGV[2])
  puts JSON.generate(dump_one(CONV))
  exit
end

check   = ARGV.delete('--check')
verbose = ARGV.delete('--verbose')
tables  = ARGV.delete('--no-tables') ? nil : File.join(__dir__, 'tables')
if (i = ARGV.index('--tables')) then tables = ARGV[i + 1]; ARGV.slice!(i, 2) end
output = nil
if (i = ARGV.index('-o')) then output = ARGV[i + 1]; ARGV.slice!(i, 2) end
CONV = File.expand_path(ARGV[0] || 'conv.rb')
results = RUNS.map { |name, m|
  json = IO.popen([RbConfig.ruby, __FILE__, '--one', m, CONV], &:read)
  raise "conv.rb failed for #{name} (m=#{m})" unless $?.success?
  [name, JSON.parse(json)]
}.to_h
units = merge(results)
if tables
  begin
    r = NameTables.attach(units, tables)
  rescue => e
    abort "gen_units.rb: #{e.message}"
  end
  warn r.notes.map { |n| "note: #{n}" } if verbose
  abort(["gen_units.rb: the name tables in #{tables} do not agree with conv.rb (units.json not written):",
         *r.errors].join("\n")) unless r.errors.empty?
  warn "gen_units.rb: #{r.entries.size} entries, #{units['names'].size} names, checked"
end
text = JSON.pretty_generate(units) + "\n"
if check
  path = File.join(File.dirname(CONV), 'units.json')
  if File.exist?(path) && File.binread(path).force_encoding('UTF-8').gsub("\r\n", "\n") == text
    puts 'units.json is up to date'
  else
    warn 'units.json is stale: regenerate with  ruby gen_units.rb -o units.json'
    exit 1
  end
elsif output
  File.binwrite(output, text)
else
  print text
end
