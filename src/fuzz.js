// fuzz.js -- random and mutated queries: conv.js must answer or raise a ConvError, nothing else
//   node fuzz.js units.json N seed
const fs = require('fs'); const Conv = require('./conv.js');
const units = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const N = Number(process.argv[3] || 20000); let seed = Number(process.argv[4] || 1);
const rnd = () => { seed = (seed * 1103515245 + 12345) & 0x7fffffff; return seed / 0x7fffffff; };
const pick = (a) => a[Math.floor(rnd() * a.length)];
const c = Conv.load(units);
const names = Object.keys(units.names);
const exprs = units.dimensions.flatMap((d) => d.calendar ? [] : d.units.map((u) => u.expression.split(' = ')[0]));
const chars = 'abcXE0123456789;.*°@^/- \t%&<>"\'`:T_+eE\u0000é\u{1F600}';
const value = () => pick(['1', '0', '-1', '2;6', '1.5', '1e3', '1E-400', '9'.repeat(400), '1^3', 'X;E', '0.0000001', '1..2', '', '1:30', "1'5", '-0', '1e999', '+3']);
let ok = 0, err = 0, codes = {};
for (let i = 0; i < N; i++) {
  let q, t;
  switch (Math.floor(rnd() * 5)) {
    case 0: q = Array.from({ length: Math.floor(rnd() * 30) }, () => pick([...chars])).join(''); t = rnd() < 0.5 ? null : Array.from({ length: Math.floor(rnd() * 10) }, () => pick([...chars])).join(''); break;
    case 1: q = value() + pick(['*', '°', '@', '']) + pick(exprs); t = rnd() < 0.5 ? null : pick(exprs); break;
    case 2: q = value() + '*' + Array.from({ length: 1 + Math.floor(rnd() * 3) }, () => pick(names) + (rnd() < 0.3 ? '^' + pick(['2', '-1', '0', '99', 'x']) : '')).join(pick([' ', '.', '  '])); t = rnd() < 0.5 ? null : pick(names); break;
    case 3: { const e = pick(exprs); const k = Math.floor(rnd() * (e.length + 1)); q = value() + '*' + e.slice(0, k) + pick([...chars]) + e.slice(k); t = rnd() < 0.5 ? null : '°' + pick(exprs); break; }
    default: q = pick(exprs); t = pick(exprs);
  }
  try {
    const r = c.query(q, t);
    if (!r.results.length) throw new Error('no results');
    for (const x of r.results) if (typeof x.text !== 'string' || /undefined|NaN/.test(x.text)) throw new Error('bad text ' + x.text);
    JSON.stringify(r);
    ok++;
  } catch (e) {
    if (!(e instanceof Conv.ConvError)) { console.log('UNCAUGHT', JSON.stringify(q), JSON.stringify(t), e.stack.split('\n').slice(0, 3).join(' / ')); process.exitCode = 1; continue; }
    if (e.position !== undefined && (e.position < 0 || e.position > Math.max(q.length, (t || '').length))) { console.log('BAD POSITION', q, t, JSON.stringify(e)); process.exitCode = 1; }
    if (![400, 404, 409, 422].includes(e.status)) { console.log('BAD STATUS', e.status); process.exitCode = 1; }
    err++; codes[e.code] = (codes[e.code] || 0) + 1;
  }
}
console.log(`answered ${ok}, refused ${err}`, JSON.stringify(codes));
