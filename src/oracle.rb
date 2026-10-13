# oracle.rb -- run conv.rb (the CGI) on random queries and record its tables, for differential tests of conv.js
#   ruby oracle.rb conv.rb units.json N seed > cases.json
require 'json'
conv, uj, n, seed = ARGV; n = n.to_i; srand(seed.to_i)
units = JSON.parse(File.read(uj))
dims = units['dimensions'].each_with_index.reject { |d, _| d['calendar'] }
MODES = { '100f0' => '', '102f0' => 'universal', '103f0' => 'GCD' }
def digits(r) = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[0, r]
cases = []
n.times do
  d, di = dims.sample
  fu = rand(d['units'].size)
  fr = [10, 12, 12, 16, 2, 8, 6].sample
  int = (1..rand(1..5)).map { digits(fr)[rand(fr)] }.join.sub(/\A0+(?=.)/, '')
  frac = (1..rand(0..8)).map { digits(fr)[rand(fr)] }.join
  fq = (rand < 0.15 ? '-' : '') + int + (frac.empty? ? '' : (fr == 12 ? ';' : '.') + frac)
  fq = fq.tr('AB', 'XE') if fr == 12 && rand < 0.5
  case rand(10)                               # conv.cgi's subunit notations now and then
  when 0 then fq = "#{rand(30)}:#{rand(60)}:#{rand(60)}"
  when 1 then fq = "#{rand(100)}'#{rand(128)}"
  when 2 then fq = "#{rand(9)}#{fr == 12 ? ';' : '.'}#{rand(9)}'#{rand(100)}"
  when 3 then fq = "#{rand(20)}T#{rand(24)}:#{rand(60)}"
  when 4 then fq = "#{rand(9)}`#{rand(64)}"
  when 5 then fq = ['', 'x', '1..2', '+', '_', '1,234', ' 12 ', '0', '-0', '1e5'].sample
  end
  fe = [0, 0, 0, 1, -1, 3, -5].sample
  fl = d['defaults'] && d['defaults']['fl'] ? [d['defaults']['fl'], 0].sample : [0, 0, 0, 1, -1, 3, -7].sample
  tl = d['defaults'] && d['defaults']['tl'] ? [d['defaults']['tl'], 0].sample : [0, 0, 0, 2, -2, 5].sample
  tm = rand < 0.2
  m = MODES.keys.sample
  qs = "m=#{m}&c=Convert&d=#{di}&fu=#{fu}&fq=#{fq.gsub(';', '%3B')}&fe=#{fe}&fr=#{fr}&fp=0&fl=#{fl}&tu=-1&tl=#{tl}&tm=#{tm ? 'on' : 'off'}"
  html = IO.popen({ 'QUERY_STRING' => qs }, ['ruby', conv], &:read)
  rows = html.scan(%r{<tr><td align=right>(\d+)</td><td>([^<]*)</td><td>([^<]*)</td></tr>}).map { |_, t, nm| [t, nm] }
  err = html[/Irregal quantity[^<]*/]
  cases << { 'q' => { 'd' => di, 'fu' => fu, 'fq' => fq, 'fe' => fe.to_s, 'fr' => fr, 'fp' => 0, 'fl' => fl, 'tu' => -1, 'tl' => tl, 'tm' => tm },
             'variant' => MODES[m], 'rows' => rows, 'error' => err }
end
puts JSON.generate(cases)
