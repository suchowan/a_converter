#!C:\Ruby\bin\ruby.exe
#!C:\cygwin\bin\ruby.exe
#!/usr/bin/env ruby
=begin

 Copyright (c) 2011-2023 Takashi Suga

 This software is released under the MIT License.

 http://opensource.org/licenses/mit-license.php

=end

class Mode

  attr_reader :comma, :period, :digits, :rsv, :tgm, :idus, :lightvlos, :uus, :tonal, :looloh, :harmon, :prefix, :nic, :doremi, :category, :precision

  def xe?
    @mode[14] == 0
  end

  def m?
    @mode[12] == 1
  end

  def code(category=nil)
    category ? ('0000' + (@mode & 0xFFF8F | category << 4).to_s(16))[-5..-1] : @code
  end

  def initialize
    if (ENV['QUERY_STRING']||ARGV[0]) =~ /c=Set/
      q = Hash[*((ENV['QUERY_STRING']||ARGV[0]||'').split(/&/).map {|v| v.split(/=/,2)}).flatten]
      @mode      = q['p'].to_i                   #  0-3  : default precision
      @mode      = 0      if @mode  == 7
      @mode     |=(1<<16) if q['i'] == '1'       # 16    : IDUS System
      @mode     |= 0x8000 if q['r'] == '1'       # 15    : gruoping separater
      @mode     |= 0x4000 if q['d'] == '1'       # 14    : digit symbols
      @mode     |= 0x2000 if q['n'] == '0'       # 13    : Nystrom's Tonal System
      @mode     |= 0x1000 if q['f'] == '1'       # 12    : use unillion
      @mode     |= ((q['t'].to_i + 1) % 3) << 10 # 10-11 : TGM System
      @mode     |= ((q['s'].to_i + 1) % 4) <<  8 #  8-9  : The Universal Unit System
      @mode     |= 0x0080 if q['a'] == '1'       #  7    : unit name (rule or alias)
      @code      = code(0)
    else
      @code      = (ENV['QUERY_STRING']||ARGV[0]) =~ /m=([0-9A-F]+)/i ? ('00000' + $1)[-5..-1] : '00000'
      @mode      = @code.to_i(16)
    end
    @idus      = @mode[16] == 1
    @comma     = @mode[15] == 1 ? '.' : ','
    @period    = @mode[15] == 1 ? ',' : '.'
    @digits    = @mode[14] == 1 ? "0123456789AB" : "0123456789XE"
    @tonal     = @mode[13] == 0
    @unillion  = @mode[12] == 1
    t          = (@mode[11]*2+@mode[10] - 1) % 3
    u          = (@mode[ 9]*2+@mode[ 8] - 1) % 4
    a          = @mode[ 7] != 0
    @tgm       = t != 0
    @uus       = u != 0
    @lightvlos = ['eliminate', 'exactly', 'not exactly'][t]
    @prefix    = ['eliminate', 'universal', 'GCD', 'harmonic'][u]
    @harmon    = a && u == 3 ? 'harmon' : 'meter(12.)'
    @nic       = a && u == 3 ? 'nic'    : 'second(12.)'
    @looloh    = !a ? 'gram(12.)' : u <= 1 ? 'loolou' : 'looloh'
    @doremi    = false # @mode[ 7] == 1
    @category  = 7 - (@mode >> 4 & 7)
    @precision = @mode & 15
    @precision = 7 if @precision == 0
  end
end

module Calendar

  class Root

    DEDAULT_MONTH_LENGTHS = [31,30,31,30,31]*2+[31,29]

    def initialize(day_period, year_period, month_origin, day_origin, day_epoch, year_epoch=0, month_lengths=DEDAULT_MONTH_LENGTHS)
      @day_period    = day_period
      @year_period   = year_period
      @month_origin  = month_origin
      @day_origin    = day_origin
      @day_epoch     = day_epoch
      @year_epoch    = year_epoch
      @month_lengths = month_lengths
      @month_period  = month_lengths.length
      @new_month     = month_lengths.inject([0]) {|s,d| s << s[-1] + d}
    end

    def to_jd(y,m,d)
      m   ||= @month_origin
      d   ||= @day_origin
      cm    = 0
      cm, m = (m - @month_origin).divmod(@month_period) unless @month_origin == 0
      cy, y = (y + cm - @year_epoch).divmod(@year_period)
      return @day_epoch + cy * @day_period + new_year(y) + new_month(m,y) + d - @day_origin
    end

    def to_ymd(jd)
      cy, d = (jd - @day_epoch).divmod(@day_period)
      y = d * @year_period / @day_period + 2
      begin
        y -= 1
        y -= 1 if y==@year_period
        d0 = new_year(y)
      end while d0 > d
      d -= d0
      @month_period.times {|m|
        l  = month_length(m,y)
        d -= l
        next if d >= 0
        cm    = 0
        cm, m = (m + @month_origin - @day_origin).divmod(@month_period) unless @month_origin == @day_origin
        return [@year_epoch+cy*@year_period+y+cm, m+@day_origin, d+l+@day_origin]
      }
    end

    def max_month
      11 + @day_origin
    end

    def max_day
      30 + @day_origin
    end

    def new_year(y)
      y*1461/4
    end

    def month_length(m,y=0)
      @month_lengths[m]
    end

    def new_month(m,y=0)
      @new_month[m]
    end
  end

  class Gregorian < Root

    def initialize
      super(36525*4-3, 400, 3, 1, 1721120)
    end

    def new_year(y)
      c, y = y.divmod(100)
      c*36524 + y*1461/4
    end
  end

  class Julian < Root

    def initialize
      super(1461, 4, 3, 1, 1721118)
    end
  end

  class FromCE500 < Root

    def initialize(day_epoch=1903682+59+365*64+16, year_epoch=64)
      super(365*128+31, 128, 3, 1, day_epoch, year_epoch)
    end
  end

  class Holocene < Root

    def initialize(day_epoch=-1812963, year_epoch=0)
      super(365*128+31, 128, 0, 0, day_epoch, year_epoch)
    end
  end

  class Calendar1 < Root

    # def initialize(day_epoch=2456283, year_epoch=64*121)
    def initialize(day_epoch=-372153, year_epoch=0)
      super(365*128+31, 128, 0, 0, day_epoch, year_epoch, [30,31]*6)
    end
  end

  class Calendar2 < Root

    # def initialize(day_epoch=2456283, year_epoch=64*121)
    def initialize(day_epoch=-372155, year_epoch=0)
      @day_epoch_out  = day_epoch
      @year_epoch_out = year_epoch
      super(12**3*1461/4-13+30, 12**3, 0, 0, 0, 0, [])
      @month_period = 13
    end

    def to_jd(y,m,d)
      c, m = (12*(y-@year_epoch_out)+m).divmod(12**4+1)
      y, m = m==12**4 ? [12**3-1, 12] : m.divmod(12)
      return @day_epoch_out + super(c*12**3+y, m, d)
    end

    def to_ymd(jd)
      y, m, d = super(jd - @day_epoch_out)
      c, y    = y.divmod(12**3)
      y, m    = (c*(12**4+1) + y*12 + m).divmod(12)
      return [y+@year_epoch_out, m, d]
    end

    def new_year(y)
      c, y = y.divmod(64)
      c*1461*16 + 1461*y/4 - c/2
    end

    def month_length(m,y)
      s = leap?(y) ? 6 : 5
      m < s ? 31 : 30
    end

    def new_month(m,y)
      s = leap?(y) ? 6 : 5
      m <= s ? 31*m : 30*m + s
    end

    def leap?(y)
      new_year(y+1) - new_year(y) != 365
    end
  end
end

module Unit

  class Unit

    attr_reader :name, :quantity, :prefix, :power, :subunit

    def initialize(name, quantity, prefix=nil, power_or_subunit=1, offset=0, sign=1)
      @name     = name
      @quantity = quantity
      @prefix   = prefix
      @power    = power_or_subunit.kind_of?(Array) ? 1 : power_or_subunit
      @subunit  = power_or_subunit.kind_of?(Array) ? power_or_subunit : []
      @offset   = offset
      @sign     = sign
    end

    def prefixes
      Prefixes[@prefix]
    end

    def convert(prefix, log, radix, other)
      quantity = (other - @offset) * @sign / (@quantity * prefixes[0] ** (prefix * @power))
      return quantity if log == 0
      if Logs[log][2].kind_of?(Integer)
        base = radix
        exp  = radix ** Logs[log][2]
      else
        base = Logs[log][2]
        exp  = 1
      end
      Math.log(quantity) / Math.log(base) * (Logs[log][1] * exp)
    end

    def reverse(prefix, log, radix, other)
      unless log == 0
        if Logs[log][2].kind_of?(Integer)
          base = radix
          exp  = radix ** Logs[log][2]
        else
          base = Logs[log][2]
          exp  = 1
        end
        other = base ** (other.to_f / (Logs[log][1] * exp)) 
      end
      @offset + @sign * other * (@quantity *  prefixes[0] ** (prefix * @power))
    end

    def dump(hs)
      dim = ''
      dim = hs[quantity].map {|c| c.to_s}.join(',') if hs[quantity]
      puts "#{quantity},#{prefix},#{power},#{@name},#{dim}"
    end
  end

  class CalendarContainer < Unit

    attr_reader :name, :prefix, :radix, :calendar

    def initialize(name, calendar, prefix=:Clock10)
      @name     = name
      @calendar = Calendar.const_get(calendar).new if Calendar.const_defined?(calendar)
      @prefix   = prefix
      @radix    = prefixes[0]
    end

    def reverse(fr, format)
      format = format.gsub(/[#{Config.comma}\sp_]/, '')
      y, m, d = format.split(/(?!^)[-;]/).map {|s|
        s.upcase!
        s.tr!('XE', 'AB') if fr==12 && Config.xe?
        s =~ /^(.+)`(.*)/ ? $1.to_i(fr)*64 + $2.to_i(fr) : s.to_i(fr)
      }
      @calendar.to_jd(y,m,d)
    end

    def convert(tr, jd, tm)
      y, m, d    = @calendar.to_ymd(jd)
      i          = ''
      if tm
        c, y     = y.divmod(64)
        i        = '(' + 'abcdefghijklmnoprstvwxyzABCDEFGHIJKLMNOPRSTVWXYZ'[c-144,1] +')' if (144...192).include?(c)
      end
      c, y, m, d = [c,y,m,d].map {|e|
        if (e)
          s = e.to_s(tr)
          s.upcase!
          s.tr!('AB', 'XE') if tr==12 && Config.xe?
          s
        else
          ''
        end
      }
      y  = ('00000000' + y)[(-(Math.log(63)/Math.log(tr)).floor-1)..-1] unless c==''
      m  = ('00000000' + m)[(-(Math.log(@calendar.max_month)/Math.log(tr)).floor-1)..-1]
      d  = ('00000000' + d)[(-(Math.log(@calendar.max_day)/Math.log(tr)).floor-1)..-1]
      (c == '' ? '' : c + i +'`') + y + (tr==12 && m.length==1? ';' : '-') + m + '-' + d
    end

    def dump(hs)
      # puts ",,#{radix},#{@name}"
    end
  end

  class JulianDate < CalendarContainer
    def reverse(fr, format)
      format = format.gsub(/[#{Config.comma}\sp_]/, '')
      format.upcase!
      format.tr!('XE', 'AB') if fr==12 && Config.xe?
      format.to_i(fr)
    end

    def convert(tr, jd, tm)
      format = jd.to_s(tr)
      format.upcase!
      format.tr!('AB', 'XE') if tr==12 && Config.xe?
      Document.insert_comma(format, tr)
    end
  end

  class << self
    def dump
      hs = {}
      unit_hash(hs, 'UUS', Mh, Sh, Jh, Kh, Ch, Ohmn, Molh, Lmnh)
      unit_hash(hs, 'TGM', Grafut, Tim, Werg, Calg, Kur*Tim, Og, 1000*Maz, Lypov)
      Units.each do |d|
        puts ",,,,#{d[0][1]},L,T,E,H,C,I,A,P"
        (1...d.length).each do |u|
          d[u].dump(hs)
        end
      end
    end

    def unit_hash(hs, name, length, time, energy, temperature, charge, impedance, amount, illumination)
      (-3..+3).each do |l|
        (-2..+2).each do |t|
          (-1..+1).each do |m|
            (-1..+1).each do |h|
              (-1..+1).each do |c|
                (-1..+1).each do |i|
                  (-1..+1).each do |a|
                    (-1..+1).each do |p|
                      key = length**l * time**t * energy**m * temperature**h *
                            charge**c * impedance**i * amount**a * illumination**p
                      hs[key] = [name, l, t, m, h, c, i, a, p] unless key == 1.0
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  Config = Mode.new
  Comma  = Config.comma
  Period = Config.period
  Nic    = Config.nic
  Looloh = Config.looloh
  Harmon = Config.harmon
  Prefix = Config.prefix

  # Universal Physical Constants
  Alpha        = 7.2973525693E-3
  Rydberg      = 10973731.568160
  Light        = 299792458.0
  Quantum      = 6.62607015E-34 / (2 * Math::PI)
  Boltzmann    = 1.380649E-23
  Avogadro     = 6.02214076E+23
  Newtonian    = 6.67430E-11
  Electron     = 1.602176634E-19

  # Derived Physical Constants
  Bohr         = Alpha / (4 * Math::PI * Rydberg)
  Planck       = Math.sqrt(Quantum * Newtonian / Light ** 3)
  Ohmn         = Alpha * Quantum / Electron ** 2
# Electron     = Math.sqrt(Alpha * Quantum / Ohmn)
  ElectronMass = Quantum * Rydberg / Light * 4 * Math::PI * Alpha ** -2
  Uatm         = 1.66053906660E-27

  # Our environment on the Earth
  G            = 9.80665
  RE           = 3.986004418E14
  ME           = 4.0007860000E+07
  GE           = RE/(ME/2/Math::PI)**2
  RS           = 1.32712442099E20
  Atm          = 101325
  Density      = 999.972
  Calorie      = 4184.0
  DAY          = 86400.0
  YEAR         = (365+31.0/128)*DAY
  PoleRad      = 6356.75231414E3
  EqRad        = 6378.137E3
  AU           = 149597870700.0
  PSEC         = 360*60*60/(2*Math::PI)*AU
  LY           = 365.25*86400*Light
  LuSun        = 2.86458E+27

  # Harmonic Universal Unit System
  Mh           = 
    case Prefix
    when 'universal' ; 12** +6 / Rydberg
    when 'GCD'       ; 50.0/128*Light/12**8
    else             ; 12** +6 * (1+19.0/12**4) / Rydberg
    end
  Sh           = 12** +8 * Mh / Light
  Jh           = 12**+30 * Quantum / Sh
  Wh           = Jh / Sh
  Kh           = 12**(-24) * Jh / Boltzmann
  Gh           = Jh / (Mh/Sh)**2
  Ch           = Math.sqrt(Jh*Sh/Ohmn)
  Molh         = 12.0**24 / Avogadro
  Lmnh         = Quantum * 2 * Math::PI * 540E12 / (12**-16 * Jh) * 683 * Wh

  # Gravitic Universal Unit System
  MG           = Planck * Math.sqrt(35.0) # Planck / 2
  SG           = MG / Light
  JG           = Quantum / SG
  WG           = JG / SG
  NG           = JG / MG
  KG           = JG / Boltzmann
  GG           = JG / (MG/SG)**2
  CG           = Math.sqrt(JG*SG/Ohmn)

  # Thomas Pendlebury's TGM system
  Tim          = 86400.0 / (2 * 12**5)
  Calg         = 0.1 / 12**2
  Mu           = 2E-7 * 12**9
  if Config.lightvlos == 'exactly'
    Grafut       = Light * Tim / (176024043 + 0.0/18)
    Og           = Grafut/Tim*Mu          # 1757.55903297
    Flenz        = Math.sqrt(1/0.001000028 * Grafut / Tim * Og) # 999.9720007840308
  else
    Grafut       = Light * Tim / (176024043 + 1.0/18)
    Og           = Grafut/Tim*Mu          # 1757.55903297
    Flenz        = Math.sqrt(1/0.001000028 * Grafut / Tim * Og) # 999.97200078397805
  end
  Pel          = Grafut**2 * Flenz / Tim
=begin
  Pel          = 871.2607996978
  Grafut       = Math.sqrt(Pel/Flenz*Tim)
=end
  Werg         = Pel*Flenz * Grafut**2 / Og                  # 25.8503556494369
  Maz          = Werg/(Grafut/Tim)**2
  Kur          = Pel/Og  # 10.2792928167E3 / 12**4
  Gee          = Grafut/Tim**2
  Lypov        = 679.6 * Werg/Tim / 12**5 #1.1795967512

  # John William Nystrom's Tonal System
  Mt           = 4.0E7/16**7
  St           = 86400.0/16
  Gt           = Mt**3 * Density
  Wt           = Gt * G * Mt / St * 16**5
  Kt           = 6.25

  # Imperial System
  Foot         = 0.3048
  Inch         = Foot / 12
  Yard         = 3 * Foot
  Mile         = 1760 * Yard
  Pound        = 0.45359237
  Ounce        = Pound / 16
  Acre         = 4840 * Yard * Yard
  GallonUK     = 0.00454609
  GallonUS     = 0.003785411784

  # Bill Hall's International Dozenal Unit System
  Tk           = 3191886105/9192631770.0       # 3191886105= 7,50E5,8389; # Tick  : time
  Gk           = Tk / 12**8 * Light  # Geck      : length
  Kn           = Gk / Tk             # Kine      : velocity / speed
  Ca           = Gk**3               # Cask      : volume
  Yu           = Quantum * 23804808 * 12**25 / Tk # 23804808. = 7E7,EE20; # Young : energy
  Ad           = Yu / (Boltzmann/21984218*12**29) # 21984218. = 744,2422; # Ardor : temperature
  Md           = Yu / (Gk/Tk)**2     # Myd       : mass
  Bz           = Md * 1000           # Berzel    : amount of substance
  Sg           = Md / Gk**3          # Spig      : density
  Pv           = Yu / Tk             # Povi      : power
  Hy           = Yu / Gk             # Huygen    : force
  Bo           = Yu / (Gk**3)        # Boyle     : pressure
  Kv           = Bo * Tk             # Kleve     : dynamic viscosity
  Rh           = Gk**2 / Tk          # Rhine     : kinematic viscosity
  Hs           = Ohmn * 4 * Math::PI # Heaviside : impedance
  Zp           = Math.sqrt(Pv / Hs)  # Zapp      : electric current
  Sa           = Zp * Tk             # Sargo     : electric charge
  Dv           = Zp * Hs             # Devigi    : electric potential difference
  Kp           = Tk / Hs             # Kapa      : electric capacitance
  Nx           = Dv * Tk / Gk**2     # Nikola    : magnetic flux density
  Ed           = Tk * Hs             # Elduk     : inductance
  Sn           = 1 / Tk              # Sonif     : frequency
  Vi           = 1 / Tk              # Villiard  : radioactivity
  Sb           = Yu / Md             # Sorbi     : absorbed Dose
  Eg           = Sb                  # Egal      : Equivalent Dose

  # Shakkan-ho
  Shaku        = 10.0/33
  Kuan         = 3.75
  Shou         = 0.064827 * Shaku**3

  Bases  = {
     2 => [Period, 8, "01"              ],
     3 => [Period, 8, "012"             ],
     4 => [Period, 8, "0123"            ],
     6 => [Period, 4, "012345"          ],
     8 => ['<sub><small>@</small></sub>', 4, "01234567" ],
    10 => [Period, 3, "0123456789"      ],
    12 => [';',    4, Config.digits     ],
    15 => [Period, 4, "0123456789A..E"  ],
    16 => [Period, 4, "0123456789A..F"  ],
    21 => [Period, 4, "0123456789A..K"  ],
    24 => [Period, 4, "0123456789A..N"  ],
    30 => [Period, 4, "0123456789A..T"  ],
    32 => [Period, 4, "0123456789A..V"  ],
  }

  Logs = {
    -8 => [ '31.6 ^ (-quantity)',                 -1, 1000**0.5],
    -7 => [ '2.51 ^ (-quantity)',                 -1,  100**0.2],
    -6 => [ '(&#8730;2) ^ (-quantity)',           -2,  2.0     ],
    -5 => [ '2 ^ (-quantity)',                    -1,  2.0     ],
    -4 => [ '(&#8730;radix) ^ (-quantity/radix)', -2,  1       ],
    -3 => [ 'radix ^ (-quantity/radix)',          -1,  1       ],
    -2 => [ '(&#8730;radix) ^ (-quantity)',       -2,  0       ],
    -1 => [ 'radix ^ (-quantity)',                -1,  0       ],
     0 => [ 'Non',                                 0,  0       ],
    +1 => [ 'radix ^ quantity',                   +1,  0       ],
    +2 => [ '(&#8730;radix) ^ quantity',          +2,  0       ],
    +3 => [ 'radix ^ (quantity/radix)',           +1,  1       ],
    +4 => [ '(&#8730;radix) ^ (quantity/radix)',  +2,  1       ],
    +5 => [ '2 ^ quantity',                       +1,  2.0     ],
    +6 => [ '(&#8730;2) ^ quantity',              +2,  2.0     ],
    +7 => [ '2.51 ^ quantity',                    +1,  100**0.2],
    +8 => [ '31.6 ^ quantity',                    +1, 1000**0.5]
  }

  Powers = {-1=>'per', 2=>'square', 3=>'cubic'}

  Prefixes = {
      nil   => [10, ['&nbsp;&nbsp;&nbsp;&nbsp;',  0]],
      :NilU => [12, ['&nbsp;&nbsp;&nbsp;&nbsp;',  0]],
      :Nil  => [12, ['&nbsp;&nbsp;&nbsp;&nbsp;',  0]],

      :SI=> [
        10,
        ['quecto', -30], ['ronto', -27], ['yocto', -24],
        ['zepto',  -21], ['atto',  -18], ['femto', -15],
        ['pico',   -12], ['nano',   -9], ['micro',  -6],
        ['milli',   -3], ['centi',  -2], ['deci',   -1],
        ['[metric]', 0],
        ['deca',    +1], ['hecto',  +2], ['kilo',   +3],
        ['Mega',    +6], ['Giga',   +9], ['Tera',  +12],
        ['Peta',   +15], ['Exa',   +18], ['Zetta', +21],
        ['Yotta',  +24], ['Ronna', +27], ['Quetta',+30]
      ],

      :Info=> [
        1024,
        ['[info]', 0],
        ['Kilo',  +1], ['Mega',   +2], ['Giga',  +3], ['Tera',  +4],
        ['Peta',  +5], ['Exa',    +6], ['Zetta', +7], ['Yotta', +8],
        ['Ronna', +9], ['Quetta',+10]
      ],

      :Univ=> Config.doremi ? 
      [
        12,
        ['penta-atomic',        -40], ['penta-atomic ut',  -39], ['penta-atomic ti',  -38], ['penta-atomic la', -37],
        ['tetra-atomic fa',     -36], ['tetra-atomic mi',  -35], ['tetra-atomic re',  -34], ['tetra-atomic do', -33],
        ['tetra-atomic',        -32], ['tetra-atomic ut',  -31], ['tetra-atomic ti',  -30], ['tetra-atomic la', -29],
        ['ter-atomic fa',       -28], ['ter-atomic mi',    -27], ['ter-atomic re',    -26], ['ter-atomic do',   -25],
        ['ter-atomic',          -24], ['ter-atomic ut',    -23], ['ter-atomic ti',    -22], ['ter-atomic la',   -21],
        ['di-atomic fa',        -20], ['di-atomic mi',     -19], ['di-atomic re',     -18], ['di-atomic do',    -17],
        ['di-atomic',           -16], ['di-atomic ut',     -15], ['di-atomic ti',     -14], ['di-atomic la',    -13],
        ['atomic fa',           -12], ['atomic mi',        -11], ['atomic re',        -10], ['atomic do',        -9],
        ['atomic',               -8], ['atomic ut',         -7], ['atomic ti',         -6], ['atomic la',        -5],
        ['fa',                   -4], ['mi',                -3], ['re',                -2], ['do',               -1],
        ["[#{Prefix}]",           0],
        ['ut',                    1], ['ti',                 2], ['la',                 3], ['so',                4],
        ['cosmic mi',             5], ['cosmic re',          6], ['cosmic do',          7], ['cosmic',            8],
        ['cosmic ut',             9], ['cosmic ti',         10], ['cosmic la',         11], ['cosmic so',        12],
        ['di-cosmic mi',         13], ['di-cosmic re',      14], ['di-cosmic do',      15], ['di-cosmic',        16],
        ['di-cosmic ut',         17], ['di-cosmic ti',      18], ['di-cosmic la',      19], ['di-cosmic so',     20],
        ['ter-cosmic mi',        21], ['ter-cosmic re',     22], ['ter-cosmic do',     23], ['ter-cosmic',       24],
        ['ter-cosmic ut',        25], ['ter-cosmic ti',     26], ['ter-cosmic la',     27], ['ter-cosmic so',    28],
        ['tetra-cosmic mi',      29], ['tetra-cosmic re',   30], ['tetra-cosmic do',   31], ['tetra-cosmic',     32],
        ['tetra-cosmic ut',      33], ['tetra-cosmic ti',   34], ['tetra-cosmic la',   35], ['tetra-cosmic so',  36],
        ['penta-cosmic mi',      37], ['penta-cosmic re',   38], ['penta-cosmic do',   39], ['penta-cosmic',     40],
        ['penta-cosmic ut',      41]
      ] :
      [
        12,
        ['penta-atomic',        -40],
        ['tetra-atomic sub',    -36],
        ['tetra-atomic',        -32], 
        ['ter-atomic sub',      -28],
        ['ter-atomic',          -24],
        ['di-atomic sub',       -20],
        ['di-atomic',           -16],
        ['atomic sub',          -12],
        ['atomic',               -8],
        ["sub",                  -4],
        ["[#{Prefix}]",           0],
        ["Hyper",                 4],
        ['cosmic',                8],
        ['cosmic Hyper',         12],
        ['di-cosmic',            16],
        ['di-cosmic Hyper',      20],
        ['ter-cosmic',           24],
        ['ter-cosmic Hyper',     28],
        ['tetra-cosmic',         32],
        ['tetra-cosmic Hyper',   36],
        ['penta-cosmic',         40]
      ],

      :TGM=> [
        12,
        ['dunnili',     -24], ['zenlefi',     -23], ['zendexi',     -22], ['zenneeni',  -21],
        ['zenaki',      -20], ['zensevi',     -19], ['zenhesi',     -18], ['zenqueni',  -17],
        ['zenquedri',   -16], ['zentrini',    -15], ['zenduni',     -14], ['zenzeni',   -13],
        ['zennili',     -12], ['lefi',        -11], ['dexi',        -10], ['neeni',      -9],
        ['aki',          -8], ['sevi',         -7], ['hesi',         -6], ['queni',      -5],
        ['quedri',       -4], ['trini',        -3], ['duni',         -2], ['zeni',       -1],
        ['[TGM]',         0],
        ['zena',          1], ['duna',          2], ['trina',         3], ['quedra',      4],
        ['quena',         5], ['hesa',          6], ['seva',          7], ['aka',         8],
        ['neena',         9], ['dexa',         10], ['lefa',         11], ['zennila',    12],
        ['zenzena',      13], ['zenduna',      14], ['zentrina',     15], ['zenquedra',  16],
        ['zenquena',     17], ['zenhesa',      18], ['zenseva',      19], ['zenaka',     20],
        ['zenneena',     21], ['zendexa',      22], ['zenlefa',      23], ['dunnila',    24]
      ],

      :Tonal=> [
        16,
                              ['-tranmill',   -19], ['-transan',    -18], ['-tranton', -17],
        ['-tran',       -16], ['-songmill',   -15], ['-songsan',    -14], ['-songton', -13],
        ['-song',       -12], ['-tammill',    -11], ['-tamsan',     -10], ['-tamton',   -9],
        ['-tam',         -8], ['-bongmill',    -7], ['-bongsan',     -6], ['-bongton',  -5],
        ['-bong',        -4], ['-mill',        -3], ['-san',         -2], ['-ton',      -1],
        ['[Tonal]',       0],
        ['ton-',          1], ['san-',          2], ['mill-',         3], ['bong-',      4],
        ['tonbong-',      5], ['sanbong-',      6], ['millbong-',     7], ['tam-',       8],
        ['tontam-',       9], ['santam-',      10], ['milltam-',     11], ['song-',     12],
        ['tonsong-',     13], ['sansong-',     14], ['millsong-',    15], ['tran-',     16],
        ['tontran-',     17], ['santran-',     18], ['milltran-',    19],
      ],

      :SDN=> [
        12,

        ['quadnilcia',  -48], ['trilevcia',   -47], ['trideccia',   -46], ['trienncia',  -45],
        ['trioctcia',   -44], ['triseptcia',  -43], ['trihexcia',   -42], ['tripentcia', -41],
        ['triquadcia',  -40], ['tritricia',   -39], ['tribicia',    -38], ['triuncia',   -37],
        ['trinilcia',   -36], ['bilevcia',    -35], ['bideccia',    -34], ['bienncia',   -33],
        ['bioctcia',    -32], ['biseptcia',   -31], ['bihexcia',    -30], ['bipentcia',  -29],
        ['biquadcia',   -28], ['bitricia',    -27], ['bibicia',     -26], ['biuncia',    -25],
        ['binilcia',    -24], ['unlevcia',    -23], ['undeccia',    -22], ['unenncia',   -21],
        ['unoctcia',    -20], ['unseptcia',   -19], ['unhexcia',    -18], ['unpentcia',  -17],
        ['unquadcia',   -16], ['untricia',    -15], ['unbicia',     -14], ['ununcia',    -13],
        ['unnilcia',    -12], ['levcia',      -11], ['deccia',      -10], ['enncia',      -9],
        ['octcia',       -8], ['septcia',      -7], ['hexcia',       -6], ['pentcia',     -5],
        ['quadcia',      -4], ['tricia',       -3], ['bicia',        -2], ['uncia',       -1],
        ['[SDN]',         0],                                    
        ['unqua',         1], ['biqua',         2], ['triqua',        3], ['quadqua',      4],
        ['pentqua',       5], ['hexqua',        6], ['septqua',       7], ['octqua',       8],
        ['ennqua',        9], ['decqua',       10], ['levqua',       11], ['unnilqua',    12],
        ['ununqua',      13], ['unbiqua',      14], ['untriqua',     15], ['unquadqua',   16],
        ['unpentqua',    17], ['unhexqua',     18], ['unseptqua',    19], ['unoctqua',    20],
        ['unennqua',     21], ['undecqua',     22], ['unlevqua',     23], ['binilqua',    24],
        ['biunqua',      25], ['bibiqua',      26], ['bitriqua',     27], ['biquadqua',   28],
        ['bipentqua',    29], ['bihexqua',     30], ['biseptqua',    31], ['bioctqua',    32],
        ['biennqua',     33], ['bidecqua',     34], ['bilevqua',     35], ['trinilqua',   36],
        ['triunqua',     37], ['tribiqua',     38], ['tritriqua',    39], ['triquadqua',  40],
        ['tripentqua',   41], ['trihexqua',    42], ['triseptqua'  , 43], ['trioctqua',   44],
        ['triennqua',    45], ['tridecqua',    46], ['trilevqua',    47], ['quadnilqua',  48],
      ],

      :Clock10 => [10, ['&nbsp;&nbsp;&nbsp;&nbsp;',  0]],
      :Clock12 => [12, ['&nbsp;&nbsp;&nbsp;&nbsp;',  0]]
    }

  Units = [
    [['10000001', 'Length'],
      Unit.new(Harmon,                              Mh,                   :Univ),
      Unit.new('meter(10.)',                        1.0,                  :SI  ),
      Unit.new('Grafut',                            Grafut,               :TGM ),
      Unit.new('Geck',                              Gk,                   :SDN ),
      Unit.new('meter(16.)',                        Mt,                   :Tonal),
      Unit.new('gravitic meter',                    MG,                   :NilU),
      Unit.new('Planck length',                     Planck),
      Unit.new('Fermi',                             1E-15,                :SI  ),
      Unit.new('Bohr radius',                       Bohr),
      Unit.new('&#197;ngstr&#246;m',                1E-10,                :SI  ),
      Unit.new('polar radius of the Earth(GRS-80)',      PoleRad),
      Unit.new('equatorial radius of the Earth(GRS-80)', EqRad),
      Unit.new('equatorial length of the Earth(GRS-80)', EqRad*2*Math::PI),
      Unit.new('meridian length of the Earth(GRS-80)',   10001965.7293*4, :Univ),
      Unit.new('gravitational radius of the Earth', RE/Light**2),
      Unit.new('gravitational radius of the Sun',   RS/Light**2),
      Unit.new('Nafut(by GRS-80)',            EqRad*2*Math::PI/(4*12**7), :TGM ),
      Unit.new('astronomical unit or Astru',        AU),
      Unit.new('lighttim(12.)',                     Light*Tim,            :TGM ),
      Unit.new('light second(10.)',                 Light,                :SI  ),
      Unit.new("light #{Nic}",                      Light*Sh,             :Univ),
      Unit.new('terno light solar day',             Light*50,             :Univ),
      Unit.new('light (Julian) year',               LY,                   :SI  ),
      Unit.new('persec',                            PSEC,                 :SI  ),
      Unit.new('thou or mil',                       Inch/1000.0),
      Unit.new('inch',                              Inch),
      Unit.new('foot',                              Foot),
      Unit.new('yard',                              Yard),
      Unit.new('fathom',                            Yard*2),
      Unit.new('mile',                              Mile),
      Unit.new('metric nautical mile',              1852.0),
      Unit.new('nautical league',                   1852.0*3),
      Unit.new('league(12.)',                       Mh*12*12*12*12,       :Univ),
      Unit.new('uncia(12.)',                        Mh/12,                :Univ),
      Unit.new('&#23610;',                          Shaku),
      Unit.new('&#38291;',                          Shaku*6),
      Unit.new('&#37324;',                          Shaku*6*60*36)
    ],

    [['10000001', 'Date', {'fq' => Time.now.utc, 'fu'=>1, 'tu'=>2}],
      JulianDate.new(        'JulianDate',          'JulianDate',     :Clock10),
      CalendarContainer.new( 'Gregorian(10.)',      'Gregorian',      :Clock10),
      CalendarContainer.new( 'Gregorian(12.)',      'Gregorian',      :Clock12),
      CalendarContainer.new( 'Julian(10.)',         'Julian',         :Clock10),
      CalendarContainer.new( "<a href='http://translate.weblio.jp/web/english?lp=JE&url=http%3A%2F%2Fsuchowan.at.webry.info%2F201311%2Farticle_16.html&rdt=tl&sentenceStyle=spoken' target='_blank'>FromCE500</a>", 'FromCE500',      :Clock12),
      CalendarContainer.new( 'Holocene',            'Holocene',       :Clock12),
      CalendarContainer.new( "Calendar <a href='http://www.asahi-net.or.jp/~dd6t-sg/univunit-e/e28.pdf' target='_blank'>D.1.1</a> of" +
                                     " <a href='http://dozenal.com/' target='_blank'>dozenal.com</a>",
                                                    'Calendar1',      :Clock12),
      CalendarContainer.new( "Calendar <a href='http://www.asahi-net.or.jp/~dd6t-sg/univunit-e/e28.pdf' target='_blank'>D.1.2</a> of" +
                                     " <a href='http://dozenal.com/' target='_blank'>dozenal.com</a>",
                                                    'Calendar2',      :Clock12),
    ],

    [['10000001', 'Time'],
      Unit.new("#{Nic}",                            Sh,                   :Univ),
      Unit.new('second(10.)',                       1.0,                  :SI  ),
      Unit.new('Tim(12.)',                          Tim,                  :TGM ),
      Unit.new('Tick',                              Tk,                   :SDN ),
      Unit.new('Tim(16.)',                          St,                   :Tonal),
      Unit.new('gravitic second',                   SG,                   :NilU),
      Unit.new('Planck time',                       Planck/Light),
      Unit.new('terno solar clock',                 DAY/(12**3 * 128),    :NilU),
      Unit.new('terno solar day or moment',         DAY/(12**3),          :NilU, [ 1, ["'",128]]),
      Unit.new('minute',                            60.0,                 nil,   [ 1, [":", 60]]),
      Unit.new('hour(12.)',                         3600.0,               :TGM,  Config.uus ? [1, [";",12**2],["'",128]] : []),
      Unit.new('hour(10.)',                         3600.0,               :SI,   [ 1, [":", 60],  [":", 60]]),
      Unit.new('dour(12.)',                         7200.0,               :Univ, [ 1, [";",12**2],["'",128]]),
      Unit.new('day(10.)',                          DAY,                  :SI,   [ 1, ["T", 24]]+[[":", 60]]*2),
      Unit.new('solar day(12.)',                    DAY,                  :Univ, [ 1, [";",12**3],["'",128]]),
      Unit.new('week',                              DAY*7),
      Unit.new('fortnight',                         DAY*14),
      Unit.new('common year',                       365.0*86400),
      Unit.new('Julian year',                       365.25*86400),
      Unit.new('leap year',                         366.0*86400),
      Unit.new('year(10.)',                         YEAR,                 :SI  ),
      Unit.new('sidereal month',                    27.321661547*86400,   :SI  ),
      Unit.new('synodic month',                     29.530588853*86400,   :SI  ),
      Unit.new('solar year(12.)',                   YEAR,                 :Univ, [64, ["`",    64]]),
      Unit.new('solar span(12.)',                   YEAR*64,              :Univ),
      Unit.new('age of solar system',               45.68E8*YEAR),
      Unit.new('age of the universe',               4.354E17)
    ],

    [['10100001', 'Mass'],
      Unit.new(Looloh,                              Gh,                   :Univ),
      Unit.new('gram(10.)',                         1.0E-3,               :SI  ),
      Unit.new('Maz',                               Maz,                  :TGM ),
      Unit.new('Myd',                               Md,                   :SDN ),
      Unit.new('pon(16.)',                          Gt,                   :Tonal),
      Unit.new('electron mass',                     ElectronMass),
      Unit.new('unified atomic mass unit or Dalton, emiMaz',Uatm),
      Unit.new('gravitic gram',                     GG,                   :NilU),
      Unit.new('Planck mass',                       Math.sqrt(Quantum*Light/Newtonian)),
      Unit.new('pound',                             Pound),
      Unit.new('ounce',                             Ounce),
      Unit.new('troy pound',                        Pound/7000*5760),
      Unit.new('troy ounce',                        Pound/7000*480),
      Unit.new('short ton',                         Pound*2000),
      Unit.new('metric ton',                        1000.0),
      Unit.new('long ton',                          Pound*2240),
      Unit.new('slug',                              Pound*G/Foot),
      Unit.new('stone',                             14*Pound),
      Unit.new('hundredweight cental',              100*Pound),
      Unit.new('hundredweight long',                112*Pound),
      Unit.new('Oum(TGM ounce)',                    Maz/12**3*2,          :TGM),
      Unit.new('&#36011;',                          Kuan)
    ],

    [['10000001', 'Area'],
      Unit.new(Harmon,                              Mh**2,                :Univ,  2),
      Unit.new('meter(10.)',                        1.0,                  :SI,    2),
      Unit.new('Surf',                              Grafut**2,            :TGM ),
      Unit.new('Geck',                              Gk**2,                :SDN,   2),
      Unit.new('meter(16.)',                        Mt**2,                :Tonal, 2),
      Unit.new('square(12.)',                       Mh**2,                :Univ),
      Unit.new('are',                               100.0,                :SI),
      Unit.new('barn',                              1E-28,                :SI),
      Unit.new('acre (international)',              4840*Yard**2),
      Unit.new('foot',                              Foot**2,              nil,    2),
      Unit.new('inch',                              Inch**2,              nil,    2),
      Unit.new('yard',                              Yard**2,              nil,    2),
      Unit.new('mile',                              Mile**2,              nil,    2),
      Unit.new('&#22378;',                          (6*Shaku)**2)
    ],

    [['10000001', 'Volume'],
      Unit.new(Harmon,                              Mh**3,                :Univ,  3),
      Unit.new('meter(10.)',                        1.0,                  :SI,    3),
      Unit.new('Volm',                              Grafut**3,            :TGM ),
      Unit.new('Cask',                              Gk**3,                :SDN),
      Unit.new('gall(16.)',                         Mt**3,                :Tonal),
      Unit.new('cube(12.)',                         Mh**3,                :Univ),
      Unit.new('liter',                             1.0E-3,               :SI ),
      Unit.new('liter(based on density of water)',  1/(Maz/Grafut**3),    :SI ),
      Unit.new('liter(for TGM)',                    1/(Maz/Grafut**3),    :TGM),
      Unit.new('foot',                              Foot**3,              nil,    3),
      Unit.new('inch',                              Inch**3,              nil,    3),
      Unit.new('U.S. barrel (petroleum)',           GallonUS*42),
      Unit.new('U.S. liquid gallon',                GallonUS),
      Unit.new('U.S. liquid quart',                 GallonUS/4),
      Unit.new('U.S. liquid pint',                  GallonUS/8),
      Unit.new('U.S. liquid cup',                   GallonUS/16),
      Unit.new('U.S. fluid ounce',                  GallonUS/128),
      Unit.new('U.S. customaryteaspoon',            GallonUS/128/6),
      Unit.new('Imperial gallon',                   GallonUK),
      Unit.new('Imperial quart',                    GallonUK/4),
      Unit.new('Imperial pint',                     GallonUK/8),
      Unit.new('Imperial cup(breakfast)',           GallonUK/16),
      Unit.new('Imperial fluid ounce',              GallonUK/160),
      Unit.new('Imperial teaspoon',                 GallonUK/160*5/24),
      Unit.new('Galvol(TGM gallon)',                Grafut**3*2/12,       :TGM ),
      Unit.new('Quartol(TGM quart)',                Grafut**3*6/12**2,    :TGM ),
      Unit.new('Tumblol(TGM pint)',                 Grafut**3*3/12**2,    :TGM ),
      Unit.new('Teaspoonful',                       Grafut**3*4/12**4,    :TGM ),
      Unit.new('&#21319;',                          Shou)
    ],

    [['10100001', 'Speed or velocity'],
      Unit.new("#{Harmon}/#{Nic} (=atol)",          Mh/Sh,                :Univ),
      Unit.new('meter(10.)/second(10.)',            1.0,                  :SI  ),
      Unit.new('Vlos',                              Grafut/Tim,           :TGM ),
      Unit.new('Kine',                              Kn,                   :SDN ),
      Unit.new('speed of light in vacuum or Lightvlos', Light),
      Unit.new("#{Harmon}/terno solar clock",       Mh/(50.0/128),        :Univ),
      Unit.new("#{Harmon}/terno solar day",         Mh/50,                :Univ),
      Unit.new("#{Harmon}/hour",                    Mh/3600,              :Univ),
      Unit.new("#{Harmon}/unino solar day",         Mh/7200,              :Univ),
      Unit.new("#{Harmon}/solar day",               Mh/86400,             :Univ),
      Unit.new('Navlos(by GRS-80)',       EqRad*2*Math::PI/(4*12**7)/Tim, :TGM ),
      Unit.new('meter(10.)/minute',                 1.0/60,               :SI  ),
      Unit.new('meter(10.)/hour',                   1.0/3600,             :SI  ),
      Unit.new('meter(10.)/day',                    1.0/86400,            :SI  ),
      Unit.new('inch/second',                       Inch),
      Unit.new('inch/minute',                       Inch/60),
      Unit.new('inch/hour',                         Inch/3600),
      Unit.new('foot/second',                       Foot),
      Unit.new('foot/minute',                       Foot/60),
      Unit.new('foot/hour',                         Foot/3600),
      Unit.new('mile/second',                       Mile),
      Unit.new('mile/minute',                       Mile/60),
      Unit.new('mile/hour',                         Mile/3600),
      Unit.new('knot',                              1852.0/3600),
      Unit.new('AU/year',                           AU/YEAR)
    ],

    [['10001001', 'Amount of substance'],
      Unit.new('mole(12.)',                         Molh,                 :Univ),
      Unit.new('mole(10.)',                         1.0,                  :SI  ),
      Unit.new('Molz',                              1000*Maz,             :TGM ),
      Unit.new('Berzel',                            Bz,                   :SDN ),
      Unit.new('natural mol or per Avogadro',       1.0/Avogadro,         :Univ)
    ],

    [['11001001', 'Thermodynamic temperature', {'fq'=>'0'}],
      Unit.new('Kelvin(12.)',                       Kh,                   :Univ),
      Unit.new('Kelvin(10.)',                       1.0,                  :SI  ),
      Unit.new('Calg',                              Calg,                 :TGM ),
      Unit.new('Ardor',                             Ad,                   :SDN ),
      Unit.new('temp(16.)',                         Kt,                   :Tonal,0,  273.15),
      Unit.new('melting point of ice(VSMOW)',       1.0,                  nil,   0,  273.15+0.000089),
      Unit.new('triple point of water',             1.0,                  nil,   0,  273.16),
      Unit.new('boiling point of water(VSMOW)',     1.0,                  nil,   0,  273.15+99.9839),
      Unit.new('degree Hyper Kelvin',               12**4*Kh,             :Univ, 0, "1182354".to_i(12)*Kh),
      Unit.new('degree Celsius',                    1.0,                  nil,   0,  273.15),
      Unit.new('degree Delisle',                    2.0/3,                nil,   0,  373.15, -1),
      Unit.new('degree Fahrenheit',                 5.0/9,                nil,   0,  459.67*5/9),
      Unit.new('degree Newton',                     100.0/33,             nil,   0,  273.15),
      Unit.new('degree Rankine',                    5.0/9),
      Unit.new('degree R&#233;aumur',               5.0/4,                nil,   0,  273.15),
      Unit.new('degree R&#248;mer',                 40.0/21,              nil,   0,  273.15-7.5*40/21),
      Unit.new('Decigree',                          Calg*12**2,           nil,   0,  273.15),
      Unit.new('gravitic Kelvin',                   KG,                   :NilU),
      Unit.new('Planck temperature',                Math.sqrt(Quantum*Light**5/Newtonian)/Boltzmann)
    ],

    [['01000001', 'Difference in temperature'],
      Unit.new('Kelvin(12.)',                       Kh,                   :Univ),
      Unit.new('Kelvin(10.)',                       1.0,                  :SI  ),
      Unit.new('Calg',                              Calg,                 :TGM ),
      Unit.new('Ardor',                             Ad,                   :SDN ),
      Unit.new('temp(16.)',                         Kt,                   :Tonal),
      Unit.new('Hyper Kelvin',                      12**4*Kh,             :Univ),
      Unit.new('Celsius',                           1.0,                  :SI  ),
      Unit.new('Delisle',                           2.0/3,                :SI  ),
      Unit.new('Fahrenheit',                        5.0/9,                :SI  ),
      Unit.new('Newton',                            100.0/33,             :SI  ),
      Unit.new('Rankine',                           5.0/9,                :SI  ),
      Unit.new('R&#233;aumur',                      5.0/4,                :SI  ),
      Unit.new('R&#248;mer',                        40.0/21,              :SI  ),
      Unit.new('Decigree',                          Calg*12**2,           :TGM ),
      Unit.new('gravitic Kelvin',                   KG,                   :NilU),
      Unit.new('Planck temperature',                Math.sqrt(Quantum*Light**5/Newtonian)/Boltzmann)
    ],

    [[['11101001', 'Energy, work, or amount of heat'],
      ['00100001', 'Earthquake magnitude',
        {'fu'=>5-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'fl'=>+8, 'fq'=>'0',
         'tu'=>4-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'tl'=>0}]],
      Unit.new('Joule(12.)',                        Jh,                   :Univ),
      Unit.new('Joule(10.)',                        1.0,                  :SI  ),
      Unit.new('Werg',                              Werg,                 :TGM ),
      Unit.new('Young',                             Yu,                   :SDN ),
      Unit.new('ton of TNT',                        Calorie*1E6,          :SI  ),
      Unit.new('earthquake magnitude 0.0',          63.0*1E3),
      Unit.new('erg',                               1.0E-7,               :SI  ),
      Unit.new('calorie (thermochemical)',          Calorie,              :SI  ),
      Unit.new('Watt(10.) hour',                    3600.0,               :SI  ),
      Unit.new('British Thermal Unit (ISO)',        1054.5,               :SI  ),
      Unit.new('gravitic Joule',                    JG,                   :NilU),
      Unit.new('Planck energy',                     Math.sqrt(Quantum*Light**5/Newtonian)),
      Unit.new('electron Volt',                     Electron,             :SI  ),
      Unit.new('electron nohm Ampere',              Electron*Ch/Sh*Ohmn,  :Univ),
      Unit.new('electron Pel',                      Electron*Kur*Og,      :TGM),
      Unit.new('photon energy at 540THz',           2*Math::PI*Quantum*540E12),
      Unit.new('foot-pound force',                  Foot*Pound*G),
      Unit.new('inch-pound force',                  Inch*Pound*G),
      Unit.new('horsepower hour',                   550*Foot*Pound*G*3600)
    ],

    [['10100001', 'Power or heat flow rate'],
      Unit.new('Watt(12.)',                         Jh/Sh,                :Univ),
      Unit.new('Watt(10.)',                         1.0,                  :SI  ),
      Unit.new('Pov',                               Werg/Tim,             :TGM ),
      Unit.new('Povi',                              Pv,                   :SDN ),
      Unit.new('effect(16.)',                       Wt,                   :Tonal),
      Unit.new('British Thermal Unit/second',       1054.5,               :SI  ),
      Unit.new('British Thermal Unit/minute',       1054.5/60,            :SI  ),
      Unit.new('British Thermal Unit/hour',         1054.5/3600,          :SI  ),
      Unit.new('thermodynamic calorie/second',      Calorie,              :SI  ),
      Unit.new('thermodynamic calorie/minute',      Calorie/60,           :SI  ),
      Unit.new('thermodynamic calorie/hour',        Calorie/3600,         :SI  ),
      Unit.new('foot-pound force/second',           Foot*Pound*G),
      Unit.new('foot-pound force/minute',           Foot*Pound*G/60),
      Unit.new('foot-pound force/hour',             Foot*Pound*G/3600),
      Unit.new('horsepower',                        550*Foot*Pound*G),
      Unit.new('gravitic Watt',                     WG,                   :NilU)
    ],

    [['10100001', 'Force'],
      Unit.new('Newton(12.)',                       Jh/Mh,                :Univ),
      Unit.new('Newton(10.)',                       1.0,                  :SI  ),
      Unit.new('Mag',                               Maz*Gee,              :TGM ),
      Unit.new('Huygen',                            Hy,                   :SDN ),
      Unit.new('dyne',                              1.0E-5,               :SI  ),
      Unit.new('gravitic Newton',                   NG,                   :NilU),
      Unit.new('gravitational force constant',      Light**4/6.67384E-11),
      Unit.new('gravitational force constant(recommend)', 35*Jh/Mh*12**40),
      Unit.new("#{Looloh} gee",                     Gh*GE,                :Univ),
      Unit.new('gram(10.)-force',                   1.0E-3*G,             :SI  ),
      Unit.new('pound-force',                       Pound*G),
      Unit.new('ounce-force',                       Ounce*G),
      Unit.new('short ton-force',                   Pound*2000*G)
    ],

    [[['01101001', 'Pressure or mechanical stress'],
      ['00100001', 'Sound pressure level (dB_SPL)',
        {'fu'=>6-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'fl'=>+4, 'fq'=>'0',
         'tu'=>5-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'tl'=>+6}]],
      Unit.new('Pascal(12.)',                       Jh/Mh**3,             :Univ),
      Unit.new('Pascal(10.)',                       1.0,                  :SI  ),
      Unit.new('Prem',                              Werg/Grafut**3,       :TGM ),
      Unit.new('Boyle',                             Bo,                   :SDN ),
      Unit.new('bar',                               1.0E5,                :SI  ),
      Unit.new('reference of sound pressure level(12.)', 20.0E-6,         :Univ),
      Unit.new('reference of sound pressure level(10.)', 20.0E-6,         :SI  ),
      Unit.new('atmosphere (standard)',             101325.0,             :SI  ),
      Unit.new('atmosphere (recommend for UUS)',    Jh/Mh**3 * 31968,     :Univ),
      Unit.new('Atmoz (recommend for TGM)',         Werg/Grafut**3 * 35,  :TGM ),
      Unit.new('torr',                              101325.0/760,         :SI  ),
      Unit.new('meter of mercury',                  13595.1*G,            :SI  ),
      Unit.new("#{Harmon} of saltwater(recommend)", 6*12**2*Jh/Mh**3,     :Univ),
      Unit.new('gram(10.)-force/cm^2',              10.0*G,               :SI  ),
      Unit.new('pound-force/inch^2',                Pound*G/Inch**2),
      Unit.new('pound-force/foot^2',                Pound*G/Foot**2),
      Unit.new('short ton-force/foot^2',            Pound*2000*G/Foot**2)
    ],

    [[['00100001', 'Power density'],
      ['00100001', 'Sound intensity level (dB_SIL)',
        {'fu'=>5-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'fl'=>+3, 'fq'=>'0',
         'tu'=>4-(Config.uus ? 0:1)-(Config.tgm ? 0:1)-(Config.idus ? 0:1), 'tl'=>+5}]],
      Unit.new("Watt(12.)/#{Harmon}^2",             Jh/Sh/Mh**2,          :Univ),
      Unit.new('Watt(10.)/meter(10.)^2',            1.0,                  :SI  ),
      Unit.new('Penz',                              Werg/Tim/Grafut**2,   :TGM ),
      Unit.new('Povi/Geck^2',                       Pv/Gk**2,             :SDN ),
      Unit.new('reference of sound intensity level(12.)', 1.0E-12,        :Univ),
      Unit.new('reference of sound intensity level(10.)', 1.0E-12,        :SI  ),
      Unit.new('black-body radiation at ice point', Math::PI**2*Boltzmann**4/(60*Quantum**3*Light**2)*273.15**4)
    ],

    [['10100001', 'Acceleration'],
      Unit.new("#{Harmon}/#{Nic}^2",                Mh/Sh**2,             :Univ),
      Unit.new('meter(10.)/second(10.)^2',          1.0,                  :SI  ),
      Unit.new('Gee',                               Gee,                  :TGM ),
      Unit.new('Kine/Tick',                         Gk/Tk**2,             :SDN ),
      Unit.new('standard gravity(recommend)',       5.5*Mh/Sh**2),
      Unit.new("standard gravity(gee)",             GE),
      Unit.new('standard gravity(CGPM1901)',        G),
      Unit.new('light/year',                        Light / YEAR),
      Unit.new('gal',                               1.0E-2,               :SI  ),
      Unit.new('meter(10.)/hour/second(10.)',       1.0/3600,             :SI  ),
      Unit.new('inch/second^2',                     Inch),
      Unit.new('inch/minute/second',                Inch/60),
      Unit.new('inch/hour/second',                  Inch/3600),
      Unit.new('foot/second^2',                     Foot),
      Unit.new('foot/minute/second',                Foot/60),
      Unit.new('foot/hour/second',                  Foot/3600),
      Unit.new('yard/second^2',                     Yard),
      Unit.new('yard/minute/second',                Yard/60),
      Unit.new('yard/hour/second',                  Yard/3600),
      Unit.new('mile/second^2',                     Mile),
      Unit.new('mile/minute/second',                Mile/60),
      Unit.new('mile/hour/second',                  Mile/3600),
      Unit.new('knot/second',                       1852.0/3600)
    ],

    [['00100001', 'Gravitational potential'],
      Unit.new("#{Harmon}/#{Nic}^2",                Mh**2/Sh**2,          :Univ,  2),
      Unit.new('meter(10.)/second(10.)^2',          1.0,                  :SI,    2),
      Unit.new('Vlov',                              Grafut*Gee,           :TGM ),
      Unit.new('Kine^2',                            Kn**2,                :SDN ),
      Unit.new('Lightvlov',                         Light**2,             :Nil),
      Unit.new('Geoid potential of the Earth',      RE/((PoleRad+2*EqRad)/3))
    ],

    [['00100001', 'Gravitational constant'],
      Unit.new("(#{Harmon}/#{Nic})^4/Newton(12.)",  (Mh/Sh)**4/(Jh/Mh),    :NilU),
      Unit.new('(meter(10.)/second(10.))^4/Newton(10.)', 1.0,              nil  ),
      Unit.new('Vlov^4 / Mag',              (Grafut/Tim)**4/(Werg/Grafut), :Nil ),
      Unit.new('Kine^4 / Huygen',                   Kn**4/Hy,              :SDN ),
      Unit.new('gravitic meter/second)^4/Newton',   (MG/SG)**4/(JG/MG),    :NilU),
      Unit.new('Newtonian constant of gravitation', 6.67384E-11)
    ],

    [['00100001', 'Gravitational parameter'],
      Unit.new("#{Harmon}/#{Nic}^2",                Mh**3/Sh**2,          :Univ,  3),
      Unit.new('meter(10.)/second(10.)^2',          1.0,                  :SI,    3),
      Unit.new('Graft/Tim^2',                       Grafut**3/Tim**2,     :TGM,   3),
      Unit.new('Geck/Tick^2',                       Gk**3/Tk**2,          :SDN,   3),
      Unit.new('gravitational parameter of the Earth', RE),
      Unit.new('gravitational parameter of the Sun',   RS)
    ],

    [['00100001', 'Flow (volume)'],
      Unit.new("#{Harmon}/#{Nic}",                  Mh**3/Sh,             :Univ,  3),
      Unit.new('meter(10.)/second(10.)',            1.0,                  :SI,    3),
      Unit.new('Flo',                               Grafut**3/Tim,        :TGM ),
      Unit.new('Cask/Tick',                         Ca/Tk,                :SDN ),
      Unit.new('liter/minute',                      1.0E-3/60,            :SI  ),
      Unit.new('foot/second',                       Foot**3,              nil,    3),
      Unit.new('foot/minute',                       Foot**3/60,           nil,    3),
      Unit.new('inch/second',                       Inch**3,              nil,    3),
      Unit.new('inch/minute',                       Inch**3/60,           nil,    3),
      Unit.new('U.S. liquid gallon/minute',         GallonUS/60),
      Unit.new('U.S. liquid gallon/hour',           GallonUS/3600),
      Unit.new('U.S. liquid gallon/day',            GallonUS/86400),
      Unit.new('Imperial gallon/minute',            GallonUK/60),
      Unit.new('Imperial gallon/hour',              GallonUK/3600),
      Unit.new('Imperial gallon/day',               GallonUK/86400)
    ],

    [['10101001', 'Density'],
      Unit.new("#{Looloh}/#{Harmon}^3",             Gh/Mh**3,             :Univ),
      Unit.new('gram(10.)/meter(10.)^3',            1.0E-3,               :SI  ),
      Unit.new('Denz',                              Maz/Grafut**3,        :TGM ),
      Unit.new('Spig ',                             Sg,                   :SDN ),
      Unit.new('maximum density of water',          Density),
      Unit.new('pound/inch^3',                      Pound/Inch**3),
      Unit.new('pound/foot^3',                      Pound/Foot**3),
      Unit.new('pound/gallon(U.S.liquid)',          Pound/GallonUS),
      Unit.new('pound/gallon(Imperial)',            Pound/GallonUK),
      Unit.new('ounce/inch^3',                      Ounce/Inch**3),
      Unit.new('ounce/foot^3',                      Ounce/Foot**3),
      Unit.new('ounce/gallon(U.S.liquid)',          Ounce/GallonUS),
      Unit.new('ounce/gallon(Imperial)',            Ounce/GallonUK)
    ],

    [['01100001', 'Specific volume'],
      Unit.new("#{Harmon}/#{Looloh}",               Mh**3/Gh,             :Univ,  3),
      Unit.new('meter(10.)/kilogram',               1.0,                  :SI,    3),
      Unit.new('Vosp',                              Grafut**3/Maz,        :TGM ),
      Unit.new('Spig',                              1/Sg,                 :SDN,  -1)
    ],

    [['00100001', 'Action'],
      Unit.new("Joule(12.) #{Nic}",                 Jh*Sh,                :Univ),
      Unit.new('Joule(10.) second(10.)',            1.0,                  :SI  ),
      Unit.new('Ag',                                Werg*Tim,             :TGM ),
      Unit.new('Young Tick',                        Yu*Tk,                :SDN ),
      Unit.new('quantum of action',                 Quantum)
    ],

    [['00100001', 'Momentum'],
      Unit.new("Joule(12.) #{Nic}/#{Harmon}",       Jh*Sh/Mh,             :Univ),
      Unit.new('gram(10.) meter(10.)/second(10.)',  1.0E-3,               :SI  ),
      Unit.new('Mav',                               Maz*Grafut/Tim,       :TGM ),
      Unit.new('Huygen Tick',                       Hy * Tk,              :SDN ),
    ],

    [['00100001', 'Tension'],
      Unit.new("Newton(12.) / #{Harmon}",           Jh/Mh**2,             :Univ),
      Unit.new('Newton(10.) / meter(10.)',          1.0,                  :SI  ),
      Unit.new('Tenz',                              Werg/Grafut**2,       :TGM ),
      Unit.new('Huygen / Geck',                     Hy/Gk,                :SDN ),
      Unit.new('surface tension of water at 25&#8451;',                71.97E-3)
    ],

    [['00100001', 'Dynamic viscosity'],
      Unit.new("Pascal(12.) #{Nic}",                Jh/Mh**3*Sh,          :Univ),
      Unit.new('Pascal(10.) second(10.)',           1.0,                  :SI  ),
      Unit.new('Viscod',                            Werg/Grafut**3*Tim,   :TGM ),
      Unit.new('Kleve',                             Kv,                   :SDN ),
      Unit.new('Poise',                             0.1,                  :SI  ),
      Unit.new('pound/foot/second',                 Pound/Foot),
      Unit.new('pound/foot/hour',                   Pound/Foot/3600),
      Unit.new('pound-force second/foot^2',         Pound*G/Foot**2),
      Unit.new('pound-force second/inch^2',         Pound*G/Inch**2)
    ],

    [['00100001', 'Kinematic viscosity'],
      Unit.new("#{Harmon} / #{Nic}",                Mh**2/Sh,             :Univ,  2),
      Unit.new('meter(10.) / second(10.)',          1.0,                  :SI,    2),
      Unit.new('Viskin',                            Grafut**2/Tim,        :TGM ),
      Unit.new('Rhine',                             Rh,                   :SDN ),
      Unit.new('Stokes',                            1.0E-4,               :SI  ),
      Unit.new('foot / second',                     Foot**2,              nil,    2)
    ],

    [['00100001', 'Angular velocity'],
      Unit.new("radian / #{Nic}",                   1/Sh,                 :Univ),
      Unit.new('radian / second(10.)',              1.0,                  :SI  ),
      Unit.new('radiVlos',                          1/Tim,                :TGM ),
      Unit.new('Radian / Tick',                     1/Tk,                 :SDN ),
      Unit.new('revolutions per second(10.)',       2*Math::PI,           :SI  ),
      Unit.new('revolutions per minute',            2*Math::PI/60,        :SI  )
    ],

    [['00100001', 'Angular acceleration'],
      Unit.new("radian / #{Nic}^2",                 1/Sh**2,              :Univ),
      Unit.new('radian / second(10.)^2',            1.0,                  :SI  ),
      Unit.new('radiGee',                           1/Tim**2,             :TGM ),
      Unit.new('Radian / Tick^2',                   1/Tk**2,              :SDN )
    ],

    [['00100001', 'Angular momentum'],
      Unit.new("Joule(12.) #{Nic} / radian",        Jh*Sh,                :Univ),
      Unit.new('Joule(10.) second(10.) / radian',   1.0,                  :SI  ),
      Unit.new('radaMav',                           Werg*Tim,             :TGM ),
      Unit.new('Young Tick / Radian',               Yu*Tk,                :SDN )
    ],

    [['00100001', 'Torque or moment of force'],
      Unit.new('Joule(12.)/radian',                 Jh,                   :Univ),
      Unit.new('Newton(10.) meter(10.)',            1.0,                  :SI  ),
      Unit.new('radaMag',                           Werg,                 :TGM ),
      Unit.new('Young / Radian',                    Yu,                   :SDN ),
      Unit.new('meter kilogram force',              1/G,                  :SI  ),
      Unit.new('foot-pound force',                  Foot*Pound*G),
      Unit.new('inch-pound force',                  Inch*Pound*G)
    ],

    [['00100001', 'Moment of inertia'],
      Unit.new("Joule(12.) #{Nic}^2/radian^2",      Jh*Sh**2,             :Univ),
      Unit.new('gram(10.) meter(10.)^2',            1.0E-3,               :SI  ),
      Unit.new('quaraMaz',                          Maz*Grafut**2,        :TGM ),
      Unit.new('Myd Geck^2',                        Md*Gk**2,             :SDN )
    ],

    [['00100001', 'Radiant power'],
      Unit.new('Watt(12.)/radian^2',                Jh/Sh,                :Univ),
      Unit.new('Watt(10.)/sr',                      1.0,                  :SI  ),
      Unit.new('QuaraPenz',                         Werg/Tim,             :TGM ),
      Unit.new('Pv / Steradian',                    Pv,                   :SDN )
    ],

    [['10010001', 'Electric charge'],
      Unit.new('Coulomb(12.)',                      Ch,                   :Univ),
      Unit.new('Coulomb(10.)',                      1.0,                  :SI  ),
      Unit.new('Quel',                              Kur*Tim,              :TGM ),
      Unit.new('Sargo',                             Sa,                   :SDN ),
      Unit.new('gravitic Coulomb',                  CG,                   :NilU),
      Unit.new('Planck charge',                     Ch/12**15),
      Unit.new('charge of an electron',             Electron),
      Unit.new('ab Coulomb',                        10.0,                 :SI  ),
      Unit.new('esu, statcoulomb or Franklin',      0.1/Light,            :SI  ),
      Unit.new('Ampere(10.) hour',                  3600.0,               :SI  )
    ],

    [['00010001', 'Electric flux'],
      Unit.new('turn Coulomb',                      Ch,                   :Univ),
      Unit.new('Coulomb(10.)',                      1.0,                  :SI  ),
      Unit.new('Quel',                              Kur*Tim,              :TGM ),
      Unit.new('Sargo',                             Sa,                   :SDN )
    ],

    [['00010001', 'Magnetic flux'],
      Unit.new('nohm Coulomb',                      Ch*Ohmn,              :Univ),
      Unit.new('Weber',                             1.0,                  :SI  ),
      Unit.new('Flum',                              Kur*Tim*Og,           :TGM ),
      Unit.new('Nikola Geck^2',                     Nx*Gk**2,             :SDN ),
      Unit.new('Maxwell',                           1.0E-8,               :SI  )
    ],

    [['10010001', 'Electric current'],
      Unit.new('Ampere(12.)',                       Ch/Sh,                :Univ),
      Unit.new('Ampere(10.)',                       1.0,                  :SI  ),
      Unit.new('Kur',                               Kur,                  :TGM ),
      Unit.new('Zapp',                              Zp,                   :SDN ),
      Unit.new('ab Ampere',                         10.0,                 :SI  ),
      Unit.new('esu/second',                        0.1/Light,            :SI  )
    ],

    [['00010001', 'Magnetomotive force'],
      Unit.new('turn Ampere',                       Ch/Sh,                :Univ),
      Unit.new('Ampere(10.)',                       1.0,                  :SI  ),
      Unit.new('Kurn',                              Kur,                  :TGM ),
      Unit.new('Zapp',                              Zp,                   :SDN ),
      Unit.new('Gilbert',                           10/(4*Math::PI),      :SI )
    ],

    [['10010001', 'Electromotive force, electric potential'],
      Unit.new('nohm Ampere',                       Ch/Sh*Ohmn,           :Univ),
      Unit.new('Volt',                              1.0,                  :SI  ),
      Unit.new('Pel',                               Kur*Og,               :TGM ),
      Unit.new('Devigi',                            Dv,                   :SDN ),
      Unit.new('ab Volt',                           1.0E-8,               :SI  ),
      Unit.new('stat Volt',                         Light/1E6,            :SI  )
    ],

    [['00010001', 'Magnetic field strength'],
      Unit.new('turn &#216;rsted',                  Ch/Sh/Mh,             :Univ),
      Unit.new('Ampere(10.) / meter(10.)',          1.0,                  :SI  ),
      Unit.new('Magra',                             Kur/Grafut,           :TGM ),
      Unit.new('Zapp / Geck',                       Zp/Gk,                :SDN ),
      Unit.new('&#216;rsted',                       1000/(4*Math::PI),    :SI  )
    ],

    [['00010001', 'Electromotive field strength'],
      Unit.new('nohm &#216;rsted',                  Ch/Sh*Ohmn/Mh,        :Univ),
      Unit.new('Volt / meter(10.)',                 1.0,                  :SI  ),
      Unit.new('Elgra',                             Kur*Og/Grafut,        :TGM ),
      Unit.new('Devigi / Geck',                     Dv/Gk,                :SDN )
    ],

    [['00010001', 'Electric flux density'],
      Unit.new('turn Gauss',                        Ch/Mh**2,             :Univ),
      Unit.new('Coulomb(10.) / meter(10.)^2',       1.0,                  :SI  ),
      Unit.new('Quenz',                             Kur*Tim/Grafut**2,    :TGM ),
      Unit.new('Sargo / Geck^2',                    Sa/Gk**2,             :SDN )
    ],

    [['00010001', 'Magnetic flux density'],
      Unit.new('nohm Gauss',                        Ch/Mh**2*Ohmn,        :Univ),
      Unit.new('Tesla',                             1.0,                  :SI  ),
      Unit.new('Flenz',                             Kur*Tim/Grafut**2*Og, :TGM ),
      Unit.new('Nikola',                            Nx,                   :SDN ),
      Unit.new('Gauss',                             1.0E-4,               :SI  ),
      Unit.new('&#947;(gamma)',                     1.0E-9,               :SI  )
    ],

    [['10010001', 'Impedance or Electrical resistance'],
      Unit.new('nohm or Planck impedance',          Ohmn,                 :Univ),
      Unit.new('Ohm(10.)',                          1.0,                  :SI  ),
      Unit.new('Og',                                Og,                   :TGM ),
      Unit.new('Heaviside',                         Hs,                   :SDN ),
      Unit.new('von Klitzing constant',          2*Math::PI*Quantum/Electron**2)
    ],

    [['00010001', 'Conductance, susceptance, and admittance'],
      Unit.new('nohm',                              1/Ohmn,               :Univ, -1),
      Unit.new('Siemens',                           1.0,                  :SI  ),
      Unit.new('Go',                                1/Og,                 :TGM ),
      Unit.new('Heaviside',                         1/Hs,                 :SDN,  -1)
    ],

    [['00010001', 'Capacitance'],
      Unit.new("#{Nic} / nohm",                     Sh/Ohmn,              :Univ),
      Unit.new('Farad',                             1.0,                  :SI  ),
      Unit.new('Kap',                               Tim/Og,               :TGM ),
      Unit.new('Kapa',                              Kp,                   :SDN )
    ],

    [['00010001', 'Permittivity'],
      Unit.new("#{Nic} radian^2/nohm/#{Harmon}", Sh/Ohmn/Mh/(4*Math::PI), :Univ),
      Unit.new('Farad / meter(10.)',                1.0,                  :SI  ),
      Unit.new('Mit',                               Tim/Og/Grafut,        :TGM ),
      Unit.new('Kapa / Geck',                       Kp/Gk,                :SDN ),
      Unit.new('vacuum permittivity',               1/(4*Math::PI*1E-7)/Light**2)
    ],

    [['00010001', 'Inductance'],
      Unit.new("#{Nic} nohm",                       Sh*Ohmn,              :Univ),
      Unit.new('Henry',                             1.0,                  :SI  ),
      Unit.new('Gen',                               Tim*Og,               :TGM ),
      Unit.new('Elduk',                             Ed,                   :SDN )
    ],

    [['00010001', 'Permeability'],
      Unit.new("#{Nic} nohm/#{Harmon}/radian^2",    4*Math::PI*Sh*Ohmn/Mh,:Univ),
      Unit.new('Henry / meter(10.)',                1.0,                  :SI  ),
      Unit.new('Meab',                              Tim*Og/Grafut,        :TGM ),
      Unit.new('Elduk / Geck',                      Ed/Gk,                :SDN ),
      Unit.new('vacuum permeability',               4*Math::PI*1E-7)
    ],

    [['00010001', 'Electric dipole'],
      Unit.new("Coulomb(12.) #{Harmon}/radian",     Ch*Mh,                :Univ),
      Unit.new('Coulomb(10.) meter(10.)',           1.0,                  :SI  ),
      Unit.new('radaQuel',                          Kur*Tim*Grafut,       :TGM ),
      Unit.new('Sargo Geck',                        Sa*Gk,                :SDN )
    ],

    [['00010001', 'Magnetic moment'],
      Unit.new("nohm Coulomb #{Harmon}",            Ch*Ohmn*Mh,           :Univ),
      Unit.new('Weber meter(10.)',                  1.0,                  :SI  ),
      Unit.new('radaFlum',                          Kur*Tim*Og*Grafut,    :TGM ),
      Unit.new('Heaviside Sargo Geck',              Hs*Sa*Gk,             :SDN )
    ],

    [['00010001', 'Reluctance'],
      Unit.new("turn / #{Nic} nohm",                1/Sh/Ohmn,            :Univ),
      Unit.new('Siemens / second(10.)',             1.0,                  :SI  ),
      Unit.new('radaQuel',                          1/Tim/Og,             :TGM ),
      Unit.new('Heaviside Tick',                    1/Hs/Tk,              :SDN, -1)
    ],

    [['00010001', 'Resistivity'],
      Unit.new("nohm #{Harmon}",                    Ohmn*Mh,              :Univ),
      Unit.new('Ohm(10.) meter(10.)',               1.0,                  :SI  ),
      Unit.new('Rezy',                              Og*Grafut,            :TGM ),
      Unit.new('Heaviside Geck',                    Hs*Gk,                :SDN )
    ],

    [['00010001', 'Conductivity'],
      Unit.new("nohm #{Harmon}",                    1/(Ohmn*Mh),          :Univ, -1),
      Unit.new('Siemens / meter(10.)',              1.0,                  :SI  ),
      Unit.new('Eldu',                              1/(Og*Grafut),        :TGM ),
      Unit.new('Heaviside Geck',                    1/(Hs*Gk),            :SDN,  -1)
    ],

    [['00011001', 'Ionic mobility'],
      Unit.new("#{Harmon} / nohm Coulomb",          Mh**2/(Ohmn*Ch),      :Univ,  2),
      Unit.new('meter(10.) / Volt second(10.)',     1.0,                  :SI,    2),
      Unit.new('Imo',                             Grafut**2/(Kur*Tim*Og), :TGM ),
      Unit.new('Geck / Heaviside Sargo',            Gk**2/(Sa*Hs),        :SDN,   2)
    ],

    [['00010001', 'Electrochemical equivalence'],
      Unit.new("#{Looloh} / Coulomb(12.)",          Gh/Ch,                :Univ),
      Unit.new('gram(10.) / Coulomb(10.)',          1.0E-3,               :SI  ),
      Unit.new('Depoz',                             Maz/(Kur*Tim),        :TGM ),
      Unit.new('Myd / Sargo',                       Md/Sa,                :SDN )
    ],

    [['10000001', 'Logarithm'],
      Unit.new('figure',                            Math.log(12),         :Univ),
      Unit.new('Bel',                               Math.log(10),         :SI  ),
      Unit.new('neper',                             1.0),
      Unit.new('bit',                               Math.log(2),          :Info),
      Unit.new('nibble, nybble or nyble',           Math.log(2)*4,        :Info),
      Unit.new('byte or octet',                     Math.log(2)*8,        :Info)
    ],

    [['01001001', 'Entropy or heat capacity'],
      Unit.new('Joule(12.) / Kelvin(12.)',          Jh/Kh,                :Univ),
      Unit.new('Joule(10.) / Kelvin(10.)',          1.0,                  :SI  ),
      Unit.new('Calkap',                            Werg/Calg,            :TGM ),
      Unit.new('Young / Ardor',                     Yu/Ad,                :SDN ),
      Unit.new('Bolzmann',                          Boltzmann)
    ],

    [['01000001', 'Specific heat capacity'],
      Unit.new("Joule(12.)/#{Looloh} Kelvin(12.)",  Jh/Gh/Kh,             :Univ),
      Unit.new('Joule(10.)/kilogram Kelvin(10.)',   1.0,                  :SI  ),
      Unit.new('Calsp',                             Werg/Maz/Calg,        :TGM ),
      Unit.new('Young / Ardor Myd',                 Yu/(Md*Ad),           :SDN ),
      Unit.new('specific heat of water',            4184.0)
    ],

    [['01000001', 'Thermal conductivity'],
      Unit.new("Watt(12.)/#{Harmon} Kelvin(12.)",   Jh/Sh/Mh/Kh,          :Univ),
      Unit.new('Watt(10.)/meter(10.) Kelvin(10.)',  1.0,                  :SI  ),
      Unit.new('Caldu',                             Werg/Tim/Grafut/Calg, :TGM ),
      Unit.new('Povi / Geck Ardor',                 Pv/(Gk*Ad),           :SDN )
    ],

    [['01000001', 'Temperature gradient'],
      Unit.new("Kelvin(12.)/#{Harmon}",             Kh/Mh,                :Univ),
      Unit.new('Kelvin(10.)/meter(10.)',            1.0,                  :SI  ),
      Unit.new('Temgra',                            Calg/Grafut,          :TGM ),
      Unit.new('Ardor / Geck',                      Ad/Gk,                :SDN )
    ],

    [['01001001', 'Specific energy or specific latent heat'],
      Unit.new("Joule(12.) / #{Looloh}",            Jh/Gh,                :Univ),
      Unit.new('Joule(10.) / kilogram',             1.0,                  :SI  ),
      Unit.new('Wesp',                              (Grafut/Tim)**2,      :TGM ),
      Unit.new('Young / Myd',                       Yu/Md,                :SDN )
    ],

    [[['00001001', 'Molarity'],
      ['00001001', 'Molarity (pH)',
      {'fq' => "6#{Period}99827" , 'fe' => '0',
       'fu' => 1, 'fp' => 3, 'fr' => 10, 'fl' => -1,
       'tu' => 0, 'tp' => 0, 'tr' => 12, 'tl' => -1 }]],
      Unit.new("mole(12.) / #{Harmon}^3",           Molh / Mh**3,         :Univ),
      Unit.new('mole(10.) / meter(10.)^3',          1.0,                  :SI  ),
      Unit.new('Molv',                              1000*Maz/Grafut**3,   :TGM ),
      Unit.new('Berzel / Cask',                     Bz/Ca,                :SDN )
    ],

    [['00001001', 'Molmity'],
      Unit.new("mole(12.) / #{Looloh}",             Molh / Gh,            :Univ),
      Unit.new('mole(10.) / kilogram',              1.0,                  :SI  ),
      Unit.new('Molm',                              1000.0,               :TGM ),
      Unit.new('Berzel / Myd',                      Bz/Md,                :SDN )
    ],

    [['00001001', 'Molar extinction or absorption'],
      Unit.new("#{Harmon} / mole(12.)",             Mh**2 / Molh,         :Univ,  2),
      Unit.new('meter(10.) / mole(10.)',            1.0,                  :SI,    2),
      Unit.new('Surfolz',                           Grafut**2/(1000*Maz), :TGM ),
      Unit.new('Geck / Berzel',                     Gk / Bz,              :SDN )
    ],

    [['00001001', 'Molar volume and refraction'],
      Unit.new("#{Harmon} / mole(12.)",             Mh**3 / Molh,         :Univ,  3),
      Unit.new('meter(10.) / mole(10.)',            1.0,                  :SI,    3),
      Unit.new('Volmolz',                           Grafut**3/(1000*Maz), :TGM ),
      Unit.new('Avolz',  Boltzmann*Avogadro*273.15/(Werg/Grafut**3 * 35), :TGM ),
      Unit.new('Cask / Berzel',                     Ca/Bz,                :SDN ),
      Unit.new('molar volume of an ideal gas', Boltzmann*Avogadro*273.15/101325)
    ],

    [['00001001', 'Molar enthalpy'],
      Unit.new("Joule(12.) / mole(12.)",            Jh / Molh,            :Univ),
      Unit.new('Joule(10.) / mole(10.)',            1.0,                  :SI  ),
      Unit.new('Wergolz',                           Werg/(1000*Maz),      :TGM ),
      Unit.new('Yound / Berzel',                    Yu / Bz,              :SDN )
    ],

    [['00011001', 'Molar electric charge'],
      Unit.new('Coulomb(12.) / mole(12.)',          Ch / Molh,            :Univ),
      Unit.new('Coulomb(10.) / mole(10.)',          1.0,                  :SI  ),
      Unit.new('Quel / Molz',                       Kur*Tim / (1000*Maz), :TGM ),
      Unit.new('Sargo / Berzel',                    Sa / Bz,              :SDN ),
      Unit.new('Faraday or Emelectron',             Electron*Avogadro)
    ],

    [['00011001', 'Molar conductivity'],
      Unit.new("#{Harmon} / nohm mole",             1/Ohmn*Mh**2/Molh,    :Univ, 2),
      Unit.new('Siemens meter(10.)^2 / mole(10.)',  1.0,                  :SI  ),
      Unit.new('Eldulz',                       1/Og*Grafut**2/(1000*Maz), :TGM ),
      Unit.new("Geck / Heaviside Berzel",           1/Hs*Gk**2/Bz,        :SDN,  2)
    ],

    [['00001001', 'Molar entropy'],
      Unit.new('Joule(12.)/ Kelvin(12.) mole(12.) or gas constant',Jh/Kh/Molh,:Univ),
      Unit.new('Joule(10.)/ Kelvin(10.) mole(10.)', 1.0,                  :SI  ),
      Unit.new('Calgolz',                           Werg/Calg/(1000*Maz), :TGM ),
      Unit.new('Young / Ardor Berzel',              Yu/(Ad*Bz),           :SDN )
    ],

    [['00001001', 'Catalytic activity'],
      Unit.new("mole(12.) / #{Nic}",                Molh / Sh,            :Univ),
      Unit.new('katal',                             1.0,                  :SI  ),
      Unit.new('Molz / Tim',                        1000*Maz/Tim,         :TGM ),
      Unit.new('Berzel / Tick',                     Bz/Tk,                :SDN ),
      Unit.new('unit',                              1.0E-7/6,             :SI  )
    ],

    [[['10000101', 'Luminous intensity'],
      ['00000101', 'Absolute magnitude',
        {'fu'=>3-(Config.uus ? 0:1)-(Config.tgm ? 0:1), 'fl'=>-7, 'fq'=>'4.8310628',
         'tu'=>4-(Config.uus ? 0:1)-(Config.tgm ? 0:1), 'tl'=>+5}]],
      Unit.new('effective Watt(12.)/radian^2',      Lmnh,                 :Univ),
      Unit.new('candela',                           1.0,                  :SI  ),
      Unit.new('QuaraLyde',                         Lypov,                :TGM ),
      Unit.new('effective Watt(12.)/sphere',        Lmnh/(4*Math::PI),    :Univ),
      Unit.new('absolute magnitude 0.0',            LuSun*100**(4.8310628/5)),
      Unit.new('luminous intensity of the Sun or Bril', LuSun,            :Nil )
    ],

    [['10000101', 'Luminous flux'],
      Unit.new('effective Watt(12.)',               Lmnh,                 :Univ),
      Unit.new('lumen',                             1.0,                  :SI  ),
      Unit.new('Lypov',                             Lypov,                :TGM )
    ],

    [[['10000101', 'Illuminance'],
      ['00000101', 'Apparent magnitude',
        {'fu'=>3-(Config.uus ? 0:1)-(Config.tgm ? 0:1), 'fl'=>-7, 'fq'=>'-2.736067',
         'tu'=>4-(Config.uus ? 0:1)-(Config.tgm ? 0:1), 'tl'=>+5}]],
      Unit.new("effective Watt(12.)/#{Harmon}^2",   Lmnh/Mh**2,           :Univ),
      Unit.new('lux',                               1.0,                  :SI  ),
      Unit.new('Lyde',                              Lypov/Grafut**2,      :TGM ),
      Unit.new('apparent magnitude 0.0',            2.57504508E-06),
      Unit.new('DubBrite 0.0',                      7.81360588E-09,       :Nil ),
      Unit.new('phot',                              1.0E4,                :SI  ),
      Unit.new('foot candela',                      1.0/Foot**2,          :SI  ),
    ],

    [['00000101', 'Light quantity'],
      Unit.new("effective Watt(12.) #{Nic}",        Lmnh*Sh,              :Univ),
      Unit.new('lumen second(10.)',                 1.0,                  :SI  ),
      Unit.new('Lyqua',                             Lypov*Tim,            :TGM )
    ],

    [['00000101', 'Light sensitivity'],
      Unit.new("#{Harmon} / effective Watt(12.) #{Nic}", Mh**2/(Lmnh*Sh),  :Univ, 2),
      Unit.new('meter(10.) / lumen second(10.)',    1.0,                  :SI,   2),
      Unit.new('Senz',                              Grafut**2/(Lypov*Tim),:TGM )
    ],

    [['00000101', 'Light efficiency'],
      Unit.new('effective Watt(12.) / Watt(12.)',   Lmnh/(Jh/Sh),         :Univ),
      Unit.new('lumen / Watt(10.)',                 1.0,                  :SI  ),
      Unit.new('Lytef',                             Lypov/(Werg/Tim),     :TGM )
    ],

    [['00001101', 'Molar optical rotation'],
      Unit.new("radian #{Harmon}^2 / mole(12.)",    Mh**2/Molh,           :Univ),
      Unit.new('radian meter(10.)^2 / mole(12.)',   1.0,                  :SI  ),
      Unit.new('Orolz',                             Grafut**2/(1000*Maz), :TGM ),
      Unit.new('Radian Geck^2 / Berzel',            Gk**2/Bz,             :SDN )
    ],

    [['00000101', 'Specific optical rotation'],
      Unit.new("radian #{Harmon}^2 / #{Looloh}",    Mh**2/Gh,             :Univ),
      Unit.new('radian meter(10.)^2 / kilogram',    1.0,                  :SI  ),
      Unit.new('Orosp',                             Grafut**2/Maz,        :TGM ),
      Unit.new('Radian Geck^2 / Myd',               Gk**2/Md,             :SDN )
    ],

    [['10010001', 'Solid angle'],
      Unit.new('radian(12.)',                       1.0,                  :Univ,  2),
      Unit.new('steradian(10.)',                    1.0,                  :SI),
      Unit.new('Steradian(12.)',                    1.0,                  :TGM),
      Unit.new('sphere or turn(12.)',               4*Math::PI,           :Univ),
      Unit.new('degree (of arc)',                   (Math::PI/180)**2,    nil,    2),
      Unit.new('minute (of arc)',                 (Math::PI/180/60)**2,   nil,    2),
      Unit.new('second (of arc)',               (Math::PI/180/3600)**2,   nil,    2)
    ],

    [['10000001', 'Plane angle'],
      Unit.new('radian(12.)',                       1.0,                  :Univ),
      Unit.new('radian(10.)',                       1.0,                  :SI),
      Unit.new('radian or [TGM]radiFut',            1.0,                  :TGM),
      Unit.new('circle or cycle(12.)',              2*Math::PI,           :Univ),
      Unit.new('cycle(10.)',                        2*Math::PI,           :SI),
      Unit.new('circle(16.)',                       2*Math::PI,           :Tonal),
      Unit.new('Pi',                                Math::PI,             :TGM),
      Unit.new('degree (of arc)',                   Math::PI/180),
      Unit.new('minute (of arc)',                   Math::PI/180/60),
      Unit.new('second (of arc)',                   Math::PI/180/3600)
    ],

    [['00000101', 'Wave number'],
      Unit.new("cycle/#{Harmon}",                   1/Mh,                 :Univ),
      Unit.new('meter(10.)',                        1.0,                  :SI,   -1),
      Unit.new('Perfut',                            1/Grafut,             :TGM ),
      Unit.new('Geck',                              1/Gk,                 :SDN,  -1),
      Unit.new('reciprocal gravitic meter',         1/MG,                 :NilU),
      Unit.new('Rydberg',                           Rydberg),
      Unit.new('kayser',                            100.0,                :SI  ),
      Unit.new('most sensitive light wave number',  540E12/Light)
    ],

    [['00000101', 'Wave length'],
      Unit.new("#{Harmon}/cycle",                   Mh,                   :Univ),
      Unit.new('meter(10.)',                        1.0,                  :SI  ),
      Unit.new('Grafut',                            Grafut,               :TGM ),
      Unit.new('Geck',                              Gk,                   :SDN ),
      Unit.new('most sensitive light wave length',  Light/540E12),
    ],

    [['10110001', 'Frequency or revolution'],
      Unit.new("cycle / #{Nic}",                    1/Sh,                 :Univ),
      Unit.new('Hertz',                             1.0,                  :SI  ),
      Unit.new('Freq',                              1/Tim,                :TGM ),
      Unit.new('Sonif',                             Sn,                   :SDN ),
      Unit.new('revolutions per minute',            1.0/60,               :SI  )
    ],

    [['00000011', 'Radiation - source activity'],
      Unit.new("natural mole(12.) / #{Nic}",        1/Sh,                 :Univ),
      Unit.new('Becquerel',                         1.0,                  :SI  ),
      Unit.new('decay / Tim',                       1/Tim,                :TGM ),
      Unit.new('Villiard',                          Vi,                   :SDN ),
      Unit.new('Curie',                             3.7E10,               :SI  ),
      Unit.new('Rutherford',                        1.0E6,                :SI  )
    ],

    [['00000011', 'Radiation - exposure'],
      Unit.new("Coulomb(12.) / #{Looloh}",          Ch/Gh,                :Univ),
      Unit.new('Coulomb(10.) / kilogram',           1.0,                  :SI  ),
      Unit.new('Quel / Maz',                        Kur*Tim/Maz,          :TGM ),
      Unit.new('Sargo / Myd',                       Sa/Md,                :SDN ),
      Unit.new('R&#246;ntgen',                      2.58E-4,              :SI  )
    ],

    [['00000011', 'Radiation - absorbed dose'],
      Unit.new("Joule(12.) / #{Looloh}",            Jh/Gh,                :Univ),
      Unit.new('Gray',                              1.0,                  :SI  ),
      Unit.new('Wesp',                              (Grafut/Tim)**2,      :TGM ),
      Unit.new('Sorbi',                             Sb,                   :SDN ),
      Unit.new('rad',                               1.0E-2,               :SI  )
    ],

    [['00000011', 'Radiation - equivalent dose'],
      Unit.new("effective Joule(12.) / #{Looloh}",  Jh/Gh,                :Univ),
      Unit.new('Sievert',                           1.0,                  :SI  ),
      Unit.new('Werg / Maz',                        (Grafut/Tim)**2,      :TGM ),
      Unit.new('Egal',                              Eg,                   :SDN ),
      Unit.new('R&#246;ntgen equivalent man(rem)',  1.0E-2,               :SI  )
    ],

    [['10000001', 'Mathematical constants', {'fu'=>1, 'tu'=>0}],
      Unit.new('1',                                 1.0,                  :NilU),
      Unit.new('&#947;',                            0.5772156649015328606,:NilU),
      Unit.new('&#966;',                            (1+Math.sqrt(5))/2,   :NilU),
      Unit.new('e',                                 Math::E,              :NilU),
      Unit.new('&#960;',                            Math::PI,             :NilU),
      Unit.new('&#8730;2',                          Math.sqrt(2),         :NilU),
      Unit.new('&#8730;3',                          Math.sqrt(3),         :NilU),
      Unit.new('&#8730;5',                          Math.sqrt(5),         :NilU),
      Unit.new('&#8730;7',                          Math.sqrt(7),         :NilU),
      Unit.new('&#8730;10.',                        Math.sqrt(10),        :NilU),
      Unit.new('&#8730;12.',                        Math.sqrt(12),        :NilU),
      Unit.new('log(2)',                            Math.log(2),          :NilU),
      Unit.new('log(3)',                            Math.log(3),          :NilU),
      Unit.new('log(5)',                            Math.log(5),          :NilU),
      Unit.new('log(7)',                            Math.log(7),          :NilU),
      Unit.new('log(10.)',                          Math.log(10),         :NilU),
      Unit.new('log(12.)',                          Math.log(12),         :NilU),
      Unit.new('&#28961;&#37327;&#22823;&#25968;',  10**68)
    ]
  ]

  (0...Units.length).to_a.reverse.each do |i|
    if Units[i][0][0].kind_of?(Array)
      Units[i..i] = Units[i][0].map {|n|
        units     = Units[i].dup
        units[0]  = n
        units
      }
    end
  end

  Units.delete_if do |l|
    l.delete_if do |v|
      if v.kind_of?(Unit)
        v.name.gsub!(/Tim\(1..\)/, 'Tim'  ) unless Config.tgm && Config.tonal
        v.name.gsub!('(10.)', '') unless Config.uus || Config.tonal
        v.name.gsub!('second(10.)', 'second') if Nic    =~ /nic/
        v.name.gsub!('meter(10.)',  'meter')  if Harmon =~ /harmon/ && !Config.tonal
        v.name.gsub!('gram(10.)',   'gram' )  if Looloh =~ /loolo/  && !Config.tonal
        v.name.gsub!('.)', Period + ')')
        ([:Univ, :NilU].include?(v.prefix) && !Config.uus) ||
        (v.prefix == :TGM   && !Config.tgm)                ||
        (v.prefix == :SDN   && !Config.idus)               ||
        (v.prefix == :Tonal && !Config.tonal)
      else
        false
      end
    end
    if l.length < 3 || l[0][0].to_i(2)[Config.category] == 0
      true
    else
      # l[1],l[2] = l[2],l[1] if l[1].prefixes.to_s =~ /metric/
      false
    end
  end
end

module Document

  include Unit

  module_function

  def response
    print "Content-type: text/html; charset=utf-8\n\n"
    print Form
  end

  def query
    begin
      q = ((ENV['QUERY_STRING']||ARGV[0]||'').split(/&/).map {|v| v.split(/=/,2)}).flatten
      q = q.length[0]==0 ? Hash[*q] : {}
      q['d'] = to_num(q['d'], Units, 0)
      case q['c']
      when 'Reset', 'Set', nil
        q = {'d'=>0, 'fu'=>0, 'tu'=>1}
        u = Units[(q['d']||0).to_i][0][2]
        q.update(u) if u
      when /%E2%86%94/
        q['fu'],q['fp'],q['fr'],q['fl'],q['fm'],q['tu'],q['tp'],q['tr'],q['tl'],q['tm'] =
        q['tu'],q['tp'],q['tr'],q['tl'],q['tm'],q['fu'],q['fp'],q['fr'],q['fl'],q['fm'] unless q['tu'].to_i == -1
      when 'd'
        q = {'d'=>q['d'], 'fu'=>0, 'tu'=>1}
        u = Units[(q['d']||0).to_i][0][2]
        q.update(u) if u
      when 'fu'
        u = Units[(q['d']||0).to_i][0][2]||{}
        ['fp','fr','fl','fq','fe'].each do |k|
          q[k] = u[k]
        end
      when 'tu'
        u = Units[(q['d']||0).to_i][0][2]||{}
        ['tp','tr', 'tl'].each do |k|
          q[k] = u[k]
        end
      end

      q['d' ]   = (q['d' ]||0).to_i

      # 'To' part
      q['tu']   = (to_num(q['tu'], Units[q['d']] ,1) || 1).to_i
      q['tr']   = (q['tr']||Prefixes[Units[q['d']][1+[q['tu'],0].max].prefix][0]).to_i
      q['tr']   = 10 if q['tr'] > 36
      q['tm']   = (q['tm'] =~ /on/i)
      q['tp']   = (q['tp']||0).to_i
      q['tl']   = (q['tl']||0).to_i

      # 'From' part
      q['fu']   = (to_num(q['fu'], Units[q['d']] ,1) || 0).to_i
      q['fr']   = (q['fr']||Prefixes[Units[q['d']][1+q['fu']].prefix][0]).to_i
      q['fr']   = 10 if q['fr'] > 36
      q['fm']   = (q['fm'] =~ /on/i)
      q['fp']   = (q['fp']||0).to_i
      q['fl']   = (q['fl']||0).to_i

      q['fe'] ||= '0'
      decode(q['fe'])
      q['fe'].tr!("XE","AB") if q['fr'] == 12
      q['fe']   = q['fe'].to_i(q['fr'])

      case q['fq']
      when Time
        q['fq'] = Units[q['d']][1+q['fu']].
                    convert(q['fr'], Calendar::Gregorian.new.to_jd(*q['fq'].to_a.reverse[4..6]), q['fm'])
      when '0'
        q['fq'] = "0#{Period}" + '0' * Config.precision
      when nil
      else
        decode(q['fq'])
      end
      q['fq'] ||= "1#{Period}" + '0' * Config.precision
      q

    rescue
      return {}
    end
  end

  def to_num(key, target, radix)
    return key unless key =~ /^[A-Z]/i
    decode(key)
    match = /#{key}/
    (radix...target.length).to_a.each do |i|
      return i - radix if target[i][0][1] =~ match
    end
    return nil
  end

  def decode(s)
    s.gsub!(/%([\da-fA-F]{2})/) {|c|
      c[1..-1].to_i(16).chr
    }
  end

  def to_sx(e, b)
    s = e.to_s(b).upcase
    s.tr!('AB', 'XE') if b==12 && Config.xe?
    s
  end

  def to_sxm(e, b, p)
    return to_sx(e, b) unless b==12 && Config.m? && ![:TGM, :SDN].include?(p)
    return '0' if e==0
    s = e.to_s(8)
    s.sub!(/(\d)$/, '@\1')
  # s.sub!(/@0/, '')
    s
  end

  def category(k, title)
    if Config.category == 7-k
      title
    else
      "<a href='#{Cgi}?m=#{Config.code(k)}'>#{title}</a>"
    end
  end

  def dimension
    option = []
    Units.size.times do |i|
      selected = Query['d'] == i ? 'selected ' : ''
      option << "<option #{selected}value=#{i}>(#{i+1}) #{Units[i][0][1]}</option>"
    end
    option.join("\n              ")
  end

  def unit(direction)
    option = []
    option << "<option value='-1'>--- All ---</option>" if direction == 't'
    (Units[Query['d']].size-1).times do |i|
      selected = Query[direction+'u'] == i ? 'selected ' : ''
      text     = Units[Query['d']][i+1].name.dup
      text     = text.sub(/natural |^solar /,'') if text =~ /natural |^solar.+\)/
      text     = text.gsub(/<.+?>/, ' ')
      option << "<option #{selected}value=#{i}>#{text}</option>"
    end
    option.join("\n              ")
  end

  def power(direction)
    return "<option value='0'>&nbsp;&nbsp;&nbsp;&nbsp;</option>" if direction=='t' && Query['tu']==-1
    option = []
    container = Units[Query['d']][1+[Query[direction+'u'],0].max]
    prefixes  = container.prefixes
    (1...prefixes.size).to_a.reverse.each do |i|
      selected = prefixes[i][1] == Query[direction+'p'] ? 'selected ' : ''
      radix = prefixes[0] <=36 ? prefixes[0] : 10
      text  = prefixes[i][0].dup
      case container.name
      when /natural/
        unless text.sub!(/GCD|harmonic/, 'natural')
          index  = text =~ /mic/
          text[(index ? index+3 : 0), 0] = ' natural '
        end
      when /^(Coulomb|mole)/
        text.sub!(/GCD|harmonic/, 'universal')
      when /^solar.+\)$/
        text.sub!(/\[(universal|harmonic)\]/, '[GCD] solar')
      end
      text = "(#{to_sxm(prefixes[i][1], radix, container.prefix)}) #{text}" unless text =~ /&nbsp;/
      option << "<option #{selected}value='#{prefixes[i][1]}'>#{text}</option>"
    end
    option.join("\n              ")
  end

  def radix(direction, full)
    return "<option value='10'>&nbsp;&nbsp;&nbsp;&nbsp;</option>" if direction=='t' && Query['tu']==-1
    option = []
    Bases.keys.sort.each do |k|
      selected = k == Query[direction+'r'] ? 'selected ' : ''
      text = full ? "#{k}#{Period} - (#{Bases[k][2]})" : "#{k}#{Period}"
      option << "<option #{selected}value='#{k}'>#{text}</option>"
    end
    option.join("\n              ")
  end

  def log(direction)
    option = []
    Logs.keys.sort.each do |k|
      selected = k == Query[direction+'l'] ? 'selected ' : ''
      option << "<option #{selected}value='#{k}'>#{Logs[k][0]}</option>"
    end
    option.join("\n              ")
  end


  def mixed_radix
    Units[Query['d']][0][1] =~ /^(Date|Time)$/ ?
                "<td align=center>\n"                                                   +
    "              <input type=hidden name='fm' value=#{Query['fm'] ? 'on':'off'} />\n" +
    "              <input type='checkbox' name='tm' #{Query['tm'] ? 'checked':''}/>\n"  +
    "              mixed radix<br/><small><strong>`</strong> 2^6, <strong>:</strong> 60, <strong>'</strong> 2^7</small>\n" +
    "            </td>"                                                                 :
                "<td align=center>\n"                                                   +
    "              <input type=hidden name='fm' value=#{Query['fm'] ? 'on':'off'} />\n" +
    "              <input type=hidden name='tm' value=#{Query['tm'] ? 'on':'off'} />\n" +
    "              radix\n"                                                             +
    "            </td>"
  end

  def calendar
    return "" unless Query['c'] == 'Convert'

    jd = Units[Query['d']][1+Query['fu']].reverse(Query['fr'], Query['fq'])
    return Units[Query['d']][1+Query['tu']].convert(Query['tr'], jd, Query['tm']) unless Query['tu']==-1

    ("<table border=1>\n" + 
     "          <tr><td align=center>#</td>" +
                   "<td align=center>calendar</td>" +
                   "<td align=center>date</td></tr>\n" +
     "          <tr><td align=right>%d</td><td>%s</td><td align=center>%s</td></tr>\n" * (Units[Query['d']].length-1) +
     "        </table>") %
    (1...Units[Query['d']].length).to_a.map {|i|
      unit = Units[Query['d']][i]
      tr   = unit.radix
      [i, unit.name, unit.convert(tr, jd, Query['tm'])]
    }.flatten
  end

  def ratio(tu, tr, tp)

    return "" unless Query['c'] == 'Convert'

    begin
      fr     = Query['fr']
      fq, fl = reverse(Query['fq'], fr, fr**Query['fe'])
      return "Irregal quantity: '#{Query['fq']}'" unless fq
      fq     = Units[Query['d']][1+Query['fu']].reverse(Query['fp'], Query['fl'], fr, fq)
      return convert(tu, tp, tr, fr, fl, Units[Query['d']][1+tu].convert(tp, Query['tl'], tr, fq)) unless tu==-1

      ("<table border=1>\n" + 
       "          <tr><td align=center>#</td>" +
                     "<td align=center>quantity</td>" +
                     "<td align=center>unit or constant</td></tr>\n" +
       "          <tr><td align=right>%d</td><td>%s</td><td>%s</td></tr>\n" * (Units[Query['d']].length-1) +
       "        </table>") %
      (((1...Units[Query['d']].length).to_a.map {|i|
        unit = Units[Query['d']][i]
        tr   = Prefixes[unit.prefix][0]
        tr   = 10 if tr > 36

        tq   = unit.convert(0, Query['tl'], tr, fq)
        tm   = convert(i-1, 0, tr, fr, fl, tq)
        [tq, tm, unit.name]
      }).sort_by {|v| v[0]}.inject([]) {|m,s| m << [m[-1]?m[-1][0]+1:1, s[1], s[2]]}.flatten)

    rescue
      return "Irregal quantity: '#{Query['fq']}'"
    end
  end

  def reverse(source, radix, power)

    sp, unit =
      case source
      when /T/         ; Query['fr'] < 30 ? [/[T:]/, [1,60,60,24]] : [/:/, [1]]
      when /:.+'/      ; [/[:']/, [ 1, 128,  Query['fr']*6          ]]
      when /[.;](.*)'/ ; [/'/,    [ 1, 128 * Query['fr']**$1.length ]]
      when /'/         ; [/'/,    [ 1, 128                          ]]
      when /:/         ; [/:/,    [ 1, Query['fr']*6,  Query['fr']*6]]
      when /`/         ; [/`/,    [64, 64                           ]]
      else             ; [/:/,    [ 1                               ]]
      end

    return nil unless source.gsub(/[+\s_#{Comma}]/, '') =~ /^(-)?(.+)/

    power  = -power if $1 == '-'
    power *= unit[0]

    $2.split(sp, unit.length).reverse.inject([0,0]) {|sum, part|
      if part
        quantity = part.gsub(/[;@#{Period}]/, '').upcase
        quantity.tr!("XE","AB") if radix == 12
        case part.length - quantity.length
        when 0 ; f = 0
        when 1 ; f = part.length - (part =~ /[;@#{Period}]/) - 1
        else   ; return nil
        end
        value = quantity.to_i(radix)
        raise ArgumentError, 'Irregal quantity' if value == 0 && quantity =~ /[1-9A-Z]/i
        [sum[0] / unit.shift + power * value.to_f / radix ** f, sum[1] + quantity.length]
      else
        [sum[0] / unit.shift, sum[1]]
      end
    }
  end

  def convert(tu, tp, tr, fr, fl, tq)
    tq, ts = (tq >= 0) ? [tq, ''] : [-tq, '-']
    if Query['tm'] # || Query['fq'] =~ /[`:']/
      subunit = Units[Query['d']][1+tu].subunit.dup
      if subunit[0]==1 || Units[Query['d']][1+tu].quantity == Units[Query['d']][1+Query['fu']].quantity
        tq /= subunit.shift||1 
      else
        subunit = []
      end
    else
      subunit = []
    end
    ts += _convert(tq, tr, fr, fl, subunit, false)
    ts.tr!("AB","XE") if tr == 12 && Config.xe?
    ts
  end

  def _convert(quantity, tr, fr, fl, subunit, flag)
    tl = (Math.log(fr)/Math.log(tr)*fl).ceil
    if (quantity.kind_of?(Integer) || quantity.to_i == quantity.to_f)
      ex = ' (exact)'
      tq = quantity.to_i.to_s(tr).upcase
      te = tq.length
      tl = te if (tl > te)
    else
      ex = ''
      te = Math.log(quantity) / Math.log(tr)
      te = te.to_i == te.to_f ? te.to_i + 1 : te.ceil
      tq = [0, 0.5].map {|m| (quantity * tr ** (tl - te) + m).to_i.to_s(tr)}
      te += 1 if te == 0 && tq[0].length != tq[1].length #TODO Avogadro and logarithm
      tq = tq[1].upcase
    end

    if (te<=0 || te>tl)
      return te<=0 ? '0' : tq + '0'*(te-tl) if flag
      tq[0..0] + Bases[tr][0] + insert_space(tq[1...tl],tr) +
      if Config.m? && tr==12
        (te>1 ? ' &times;' : ' &#8725;') + ' U<sup>' + 
        ((te-1).abs.to_s(8) + '@').sub(/(.)@/, '@\1').sub(/^(-?.)@0$/, '\1').sub('@','<small>@</small>') + '</sup>'
      else
        " &times; #{tr}" + Period + '^' + (te-1).to_s(tr).upcase + Bases[tr][0]
      end
    else
      int_part  = tq[0...te]
      quantity -= int_part.to_i(tr)
      ts = insert_comma(int_part, tr) + 
      ( quantity       < 0 ? '' :
        subunit.length > 0 ?
          subunit[0][0] + _convert(quantity * subunit[0][1], tr, fr, fl-te, subunit[1..-1], true) :
          Bases[tr][0]  + insert_space(tq[te..-1],tr)
      )
      ts += ex unless ts =~ /exact/
      ts
    end
  end

  def insert_comma(s, tr)
    (s.reverse.split(/(.{#{Bases[tr][1]}})/).delete_if {|v| v==''}).join(Comma).reverse
  end

  def insert_space(s, tr)
    (s.split(/(.{#{Bases[tr][1]}})/).delete_if {|v| v==''}).join('&nbsp;')
  end

  Cgi   = "#{__FILE__.split(/\//)[-1]}"
  Query = query()
  BODY  = " background='../wall.png' bgproperties=fixed text=#000000 link=#aa5555 vlink=#aa5555"
  Form  = Query['c'] == 'Config' ? <<"ConfigForm" : Units[Query['d']][0][1]=='Date'? <<"DateForm" : <<"UnitForm"
<html>
  <head>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <meta name='Author' content='suchowan@box.email.ne.jp' />
    <meta name='Keywords' content='duodecimal, dozenal, universal unit system, universal system of units' />
    <meta name='Description' content='A Converter Configuration' />
    <title>A Converter Configuration</title>
  </head>
  <body#{BODY}>
    <div align=center>
      <h3>
        A Converter Configuration &nbsp;
        <small>
          [<a href=http://dozenal.com target='_blank'>Home</a>]
        </small>
      </h3>
      <form method=get action='#{Cgi}' name='config_form'>
        <table align=center border=1>
          <tr>
            <td><a href=http://dozenal.com/ target='_blank' >Universal Unit System</a></td>
            <td>
              <select name='s'>
                <option value='0'#{Config.prefix=='eliminate' ? ' selected':''}>eliminate</option>
                <option value='1'#{Config.prefix=='universal' ? ' selected':''}>universal</option>
                <option value='2'#{Config.prefix=='GCD'       ? ' selected':''}>GCD      </option>
                <option value='3'#{Config.prefix=='harmonic'  ? ' selected':''}>harmonic </option>
              </select>
            </td>
          </tr>
          <tr>
            <td>&nbsp;&nbsp;&nbsp;unit name</td>
            <td>
              <select name='a'>
                <option value='0'#{Config.looloh=~/gram/ ? ' selected':''}>rule</option>
                <option value='1'#{Config.looloh=~/lool/ ? ' selected':''}>alias</option>
              </select>
            </td>
          </tr>
          <tr>
            <td><a href=http://www.dozenalsociety.org.uk/pdfs/TGMbooklet.pdf target='_blank' >TGM System</a></td>
            <td>
              <select name='t'>
                <option value='0'#{Config.lightvlos == 'eliminate'   ? ' selected':''}>eliminate</option>
                <option value='1'#{Config.lightvlos == 'exactly'     ? ' selected':''}>Lightvlos exactly</option>
                <option value='2'#{Config.lightvlos == 'not exactly' ? ' selected':''}>Lightvlos not exactly</option>
              </select>
            </td>
          </tr>
          <tr>
            <td><a href=http://dozenal.wikia.com/wiki/IDUS
                   target='_blank' > International Dozenal Unit System</a></td>
            <td>
              <select name='i'>
                <option value='0'#{Config.idus ? '':' selected'}>eliminate</option>
                <option value='1'#{Config.idus ? ' selected':''}>include  </option>
              </select>
            </td>
          </tr>
          <tr>
            <td><a href=http://books.google.com/books?id=aNYGAAAAYAAJ&pg=PA105&source=gbs_selected_pages&cad=0_1#PPP1,M1
                   target='_blank' >Tonal System</a></td>
            <td>
              <select name='n'>
                <option value='0'#{Config.tonal ? '':' selected'}>eliminate</option>
                <option value='1'#{Config.tonal ? ' selected':''}>include  </option>
              </select>
            </td>
          </tr>
          <tr>
            <td>grouping separater</td>
            <td>
              <select name='r'>
                <option value='0'#{Config.comma==',' ? ' selected':''}>","</option>
                <option value='1'#{Config.comma=='.' ? ' selected':''}>"."</option>
              </select>
            </td>
          </tr>
          <tr>
            <td>digit symbols</td>
            <td>
              <select name='d'>
                <option value='0'#{Config.xe? ? ' selected':''}>0123456789XE</option>
                <option value='1'#{Config.xe? ? '':' selected'}>0123456789AB</option>
              </select>
            </td>
          </tr>
          <tr>
            <td>use unillion</td>
            <td>
              <select name='f'>
                <option value='0'#{Config.m? ? '':' selected'}>No </option>
                <option value='1'#{Config.m? ? ' selected':''}>Yes</option>
              </select>
            </td>
          </tr>
          <tr>
            <td>default precision</td>
            <td>
              <select name='p'>
                <option#{Config.precision==1  ? ' selected':''}>1</option>
                <option#{Config.precision==2  ? ' selected':''}>2</option>
                <option#{Config.precision==3  ? ' selected':''}>3</option>
                <option#{Config.precision==4  ? ' selected':''}>4</option>
                <option#{Config.precision==5  ? ' selected':''}>5</option>
                <option#{Config.precision==6  ? ' selected':''}>6</option>
                <option#{Config.precision==7  ? ' selected':''}>7</option>
                <option#{Config.precision==8  ? ' selected':''}>8</option>
                <option#{Config.precision==9  ? ' selected':''}>9</option>
                <option#{Config.precision==10 ? ' selected':''}>10</option>
                <option#{Config.precision==11 ? ' selected':''}>11</option>
                <option#{Config.precision==12 ? ' selected':''}>12</option>
                <option#{Config.precision==13 ? ' selected':''}>13</option>
                <option#{Config.precision==14 ? ' selected':''}>14</option>
                <option#{Config.precision==15 ? ' selected':''}>15</option>
              </select>
            </td>
          </tr>
        </table>
        <input type=submit name='c' value='Set'/>
      </form>
    </div>
  </body>
</html>
ConfigForm
<html>
  <head>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <meta name='Author' content='suchowan@box.email.ne.jp' />
    <meta name='Keywords' content='duodecimal, dozenal, universal unit system, universal system of units' />
    <meta name='Description' content='A Converter' />
    <title>A Converter</title>
    <script language=JavaScript>
      <!--
        function gotosite(option) {
          option += '&m='  + document.query_form.m.value ;
          option += '&d='  + document.query_form.d.value ;
          option += '&tu=' + document.query_form.tu.value;
          option += '&tr=' + document.query_form.tr.value;
          option += '&tm=' + (document.query_form.tm.checked ? 'on' : 'off');
          option += '&fu=' + document.query_form.fu.value;
          option += '&fr=' + document.query_form.fr.value;
          option += '&fm=' + (document.query_form.fm.checked ? 'on' : 'off');
          option += '&fq=' + document.query_form.fq.value;
          top.location.search = option;
        }
      -->
    </script>
  </head>
  <body#{BODY}>
    <div align=center>
      <h3>
        A Converter &nbsp;
        <small>
          [<a href=http://dozenal.com target='_blank'>Home</a>]&nbsp;
          [<a href='#{Cgi}?m=#{Config.code()}&c=Config'>Config</a>]&nbsp;
          [<a href=https://github.com/suchowan/a_converter target='_blank'>GitHub</a>]
        </small>
      </h3>
      <small>
        #{category(0, 'Typical'          )} /
        #{category(1, 'Thermo-'          )} /
        #{category(2, 'Dynamical'        )} /
        #{category(3, 'Electromagnetical')} /
        #{category(4, 'Chemical'         )} /
        #{category(5, 'Optical'          )} /
        #{category(6, 'Radiological'     )} /
        #{category(7, 'All'              )}
      </small>
      <form method=get action='#{Cgi}' name='query_form'>
        <input type=hidden name='m' value='#{Config.code()}' />
        <table border=1>
          <tr>
            <td align=center><strong>dimension</strong></td>
            <td align=center colspan=3>
              <select name='d' onChange='gotosite("c=d")'>
              #{dimension()}
              </select>
              &nbsp;
              <input type=submit name='c' value='Reset' />
            </td>
          </tr>
          <tr>
            <td align=center><strong>date</strong></td>
            <td align=center colspan=3><input type=text name='fq' size=40 value=#{Query['fq']}></td>
          </tr>
          <tr>
            <td align=center>item</td>
            <td align=center>from</td>
            <td align=center rowspan=3>
              #{Query['tu'] == -1 ? '&nbsp;' : '<input type=submit name=\'c\' value=\'&#8596;\' />'}
            </td>
            <td align=center>to</td>
          </tr>
          <tr>
            <td align=center><strong>calendar</strong></td>
            <td align=center>
              <select name='fu' onChange='gotosite("c=fu")'>
              #{unit('f')}
              </select>
            </td>
            <td align=center>
              <select name='tu' onChange='gotosite("c=tu")'>
              #{unit('t')}
              </select>
            </td>
          </tr>
          <tr>
            #{mixed_radix()}
            <td align=center>
              <select name='fr'>
              #{radix('f', true)}
              </select>
            </td>
            <td align=center>
              <select name='tr'>
              #{radix('t', true)}
              </select>
            </td>
          </tr>
        </table>
        <br/>
        <input type=submit name='c' value='Convert'/>
      </form>
      <strong>
        #{calendar()}
      </strong>
    </div>
  </body>
</html>
DateForm
<html>
  <head>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <meta name='Author' content='suchowan@box.email.ne.jp' />
    <meta name='Keywords' content='duodecimal, dozenal, universal unit system, universal system of units' />
    <meta name='Description' content='A Converter' />
    <title>A Converter</title>
    <script language=JavaScript>
      <!--
        function gotosite(option) {
          option += '&m='  + document.query_form.m.value ;
          option += '&d='  + document.query_form.d.value ;
          option += '&tu=' + document.query_form.tu.value;
          option += '&tr=' + document.query_form.tr.value;
          option += '&tm=' + (document.query_form.tm.checked ? 'on' : 'off');
          option += '&tp=' + document.query_form.tp.value;
          option += '&tl=' + document.query_form.tl.value;
          option += '&fu=' + document.query_form.fu.value;
          option += '&fr=' + document.query_form.fr.value;
          option += '&fm=' + (document.query_form.fm.checked ? 'on' : 'off');
          option += '&fp=' + document.query_form.fp.value;
          option += '&fl=' + document.query_form.fl.value;
          option += '&fq=' + document.query_form.fq.value;
          option += '&fe=' + document.query_form.fe.value;
          top.location.search = option;
        }

        function sync_fr_to_frq() {
          document.query_form.frq.selectedIndex = document.query_form.fr.selectedIndex;
        }

        function sync_frq_to_fr() {
          document.query_form.fr.selectedIndex = document.query_form.frq.selectedIndex;
        }
      -->
    </script>
  </head>
  <body#{BODY}>
    <div align=center>
      <h3>
        A Converter &nbsp;
        <small>
          [<a href=http://dozenal.com target='_blank'>Home</a>]&nbsp;
          [<a href='#{Cgi}?m=#{Config.code()}&c=Config'>Config</a>]&nbsp;
          [<a href=https://github.com/suchowan/a_converter target='_blank'>GitHub</a>]
        </small>
      </h3>
      <small>
        #{category(0, 'Typical'          )} /
        #{category(1, 'Thermo-'          )} /
        #{category(2, 'Dynamical'        )} /
        #{category(3, 'Electromagnetical')} /
        #{category(4, 'Chemical'         )} /
        #{category(5, 'Optical'          )} /
        #{category(6, 'Radiological'     )} /
        #{category(7, 'All'              )}
      </small>
      <form method=get action='#{Cgi}' name='query_form'>
        <input type=hidden name='m' value='#{Config.code()}' />
        <table border=1>
          <tr>
            <td align=center><strong>dimension</strong></td>
            <td align=center colspan=3>
              <select name='d' onChange='gotosite("c=d")'>
              #{dimension()}
              </select>
              &nbsp;
              <input type=submit name='c' value='Reset' />
            </td>
          </tr>
          <tr>
            <td align=center><strong>quantity</strong></td>
            <td align=center colspan=3>
              <input type=text name='fq' size=24 value=#{Query['fq']}>
              &times;
              <select name='frq' onChange='sync_frq_to_fr()'>
              #{radix('f', false)}
              </select>
             ^<input type=text name='fe' size=3 value=#{to_sx(Query['fe'],Query['fr'])}>
            </td>
          </tr>
          <tr>
            <td align=center>item</td>
            <td align=center>from</td>
            <td align=center rowspan=5>
              #{Query['tu'] == -1 ? '&nbsp;' : '<input type=submit name=\'c\' value=\'&#8596;\' />'}
            </td>
            <td align=center>to</td>
          </tr>
          <tr>
            <td align=center><strong>unit or<br/>constant</strong></td>
            <td>
              <select name='fu' onChange='gotosite("c=fu")'>
              #{unit('f')}
              </select>
            </td>
            <td>
              <select name='tu' onChange='gotosite("c=tu")'>
              #{unit('t')}
              </select>
            </td>
          </tr>
          <tr>
            <td align=center>power</td>
            <td>
              #{Powers[Units[Query['d']][1+Query['fu']].power]}
              <select name='fp'>
              #{power('f')}
              </select>
            </td>
            <td>
              #{Powers[Units[Query['d']][1+[Query['tu'],0].max].power]}
              <select name='tp'>
              #{power('t')}
              </select>
            </td>
          </tr>
          <tr>
            #{mixed_radix()}
            <td>
              <select name='fr' onChange='sync_fr_to_frq()'>
              #{radix('f', true)}
              </select>
            </td>
            <td>
              <select name='tr'>
              #{radix('t', true)}
              </select>
            </td>
          </tr>
          <tr>
            <td align=center>type</td>
            <td>
              <select name='fl'>
              #{log('f')}
              </select>
            </td>
            <td>
              <select name='tl'>
              #{log('t')}
              </select>
            </td>
          </tr>
        </table>
        <br/>
        <input type=submit name='c' value='Convert'/>
      </form>
      <strong>
        #{Document.ratio(Query['tu'], Query['tr'], Query['tp'])}
      </strong>
    </div>
  </body>
</html>
UnitForm
end

if __FILE__ == $0
  ENV['QUERY_STRING'] ? Document.response : Unit.dump
end
