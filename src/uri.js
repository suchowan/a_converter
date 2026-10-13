// uri.js -- the URI form against the core: every row written as a URI must give what the core gives,
// and random URIs must be answered or refused with a ConvError
//   node uri.js units.json N seed
const fs = require('fs'); const Conv = require('./conv.js');
const units = JSON.parse(fs.readFileSync(process.argv[2] || 'units.json', 'utf8'));
const c = Conv.load(units); const N = Number(process.argv[3] || 20000); let seed = Number(process.argv[4] || 1);
let ok = 0, bad = 0, skip = 0;
units.dimensions.forEach((D, d) => {
  if (D.calendar) return;
  const first = D.units[0].expression.split(' = ')[0];
  D.units.forEach((u) => {
    for (const part of u.expression.split(' = ')) {
      if (/(^|[ /])1(\^|$| )/.test(part.replace(/^°/, ''))) { skip++; continue; }    // CONST/1 has no URI spelling
      const scale = part.startsWith('°'), e = part.replace(/^°/, '');
      const core = (scale ? '1;0000000°' : '1;0000000*') + e;
      const uri = (scale ? '1.0000000Z0°' : '1.0000000Z0*') + c.uriExpr(e) + '/' + (first.startsWith('°') ? '°' + c.uriExpr(first.slice(1)) : c.uriExpr(first));
      let a, b;
      try { a = c.query(core, first, { value: { fq: '1;0000000', fr: 12, fe: 0 } }); } catch (err) { a = err.code; }
      try { b = c.request(uri); } catch (err) { b = err.code; }
      const ta = typeof a === 'string' ? a : a.results[0].html, tb = typeof b === 'string' ? b : b.results[0].html;
      if (ta === tb) ok++; else { bad++; if (bad < 10) console.log('differs', uri, ta, tb); }
    }
  });
});
console.log(`rows as URIs: same ${ok}, different ${bad}, skipped ${skip}`);
const rnd = () => { seed = (seed * 1103515245 + 12345) & 0x7fffffff; return seed / 0x7fffffff; };
const pick = (a) => a[Math.floor(rnd() * a.length)];
const names = Object.keys(units.names).map((k) => k.includes('/') && !k.startsWith('gravitic/') ? k.replace(/^(\w+)\/(.*)$/, (_, s, n) => n.replace(/(\D)(\d+)/g, '$1_$2') + '_' + s) : k.replace(/(\D)(\d+)/g, '$1_$2').replace(/^gravitic\/(.*)$/, '$1_gravitic'));
const junk = 'abcxeXEZ0123456789;.*°@/_-+%~ p2SIuniversal';
let ans = 0, ref = 0, codes = {};
for (let i = 0; i < N; i++) {
  let p;
  switch (Math.floor(rnd() * 4)) {
    case 0: p = Array.from({ length: Math.floor(rnd() * 25) }, () => pick([...junk])).join(''); break;
    case 1: p = pick(['1Z0', '9E0', '1.5E-3', 'x;eZ2', '0E0', '-1Z0', '1', '1Z']) + pick(['*', '°', '@', '']) + pick(names) + pick(['', '1', '-1', '2', '-2', 'p2']) + pick(['', pick(names)]) + pick(['', '/*', '/' + pick(names), '/°' + pick(names)]) + pick(['', '.json', '.html']); break;
    case 2: p = pick(names) + pick(['', '.html']); break;
    default: { const n = pick(names); const k = Math.floor(rnd() * n.length); p = '1Z0*' + n.slice(0, k) + pick([...junk]) + n.slice(k) + '/*'; }
  }
  try { const r = c.request(p); JSON.stringify(r); ans++; } catch (e) {
    if (!(e instanceof Conv.ConvError)) { console.log('UNCAUGHT', JSON.stringify(p), e.stack.split('\n').slice(0, 2).join(' / ')); process.exitCode = 1; continue; }
    if (e.position !== undefined && (e.position < 0 || e.position > p.length + 2)) { console.log('BAD POSITION', p, JSON.stringify(e)); process.exitCode = 1; }
    ref++; codes[e.code] = (codes[e.code] || 0) + 1;
  }
}
console.log(`random URIs: answered ${ans}, refused ${ref}`, JSON.stringify(codes));
