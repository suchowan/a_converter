// redirect_test.js -- the conv.cgi address made for a request must show what conv.js answers
//   node redirect_test.js units.json conv.rb N seed
const fs = require('fs'); const { execFileSync } = require('child_process'); const Conv = require('./conv.js');
const units = JSON.parse(fs.readFileSync(process.argv[2], 'utf8')); const conv = process.argv[3];
const N = Number(process.argv[4] || 200); let seed = Number(process.argv[5] || 1);
const rnd = () => { seed = (seed * 1103515245 + 12345) & 0x7fffffff; return seed / 0x7fffffff; };
const pick = (a) => a[Math.floor(rnd() * a.length)];
const c = Conv.load(units);
const exprs = [];
units.dimensions.forEach((D) => { if (!D.calendar) D.units.forEach((u) => { const p = u.expression.split(' = ')[0]; exprs.push([D, p]); }); });
let ok = 0, bad = 0, n = 0;
while (n < N) {
  const [D, p] = pick(exprs); const [, t] = pick(exprs.filter(([E]) => E === D));
  const sc = p.startsWith('°'), tsc = t.startsWith('°');
  const val = pick(['1.0000000Z0', '9E0', '1.6Z-2', '2.5E3', '7;7Z1', '-3.25E0', '0E0', '1.23456E-4', '9']);
  const req = val + (sc ? '°' : '*') + c.uriExpr(p.replace(/^°/, '')) + '/' + (rnd() < 0.3 ? '*' : (tsc ? '°' : '') + c.uriExpr(t.replace(/^°/, '')));
  let r; try { r = c.request(req); } catch (e) { continue; }
  n++;
  const qs = c.cgiURL(r, '').slice(1);
  const html = execFileSync('ruby', [conv], { env: Object.assign({}, process.env, { QUERY_STRING: qs }) }).toString();
  const rows = [...html.matchAll(/<tr><td align=right>(\d+)<\/td><td>([^<]*)<\/td><td>([^<]*)<\/td><\/tr>/g)].map((m) => m[2]);
  let got;
  if (r.results.length > 1 || rows.length > 0) got = rows;
  else { const m = /<\/form>\s*<strong>\s*([\s\S]*?)\s*<\/strong>/.exec(html); got = m ? [m[1].trim()] : []; }
  const want = r.results.map((x) => x.html);
  const same = got.length === want.length && [...got].sort().join('|') === [...want].sort().join('|');
  if (same) ok++; else { bad++; if (bad < 6) console.log('differs', req, '\n  ', qs, '\n   cgi:', got.slice(0, 3), '\n   js: ', want.slice(0, 3)); }
}
console.log(`redirects: same ${ok}, different ${bad}`);
