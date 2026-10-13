// diff.js -- differential test: conv.js against conv.rb's own output (cases from oracle.rb)
//   node diff.js units.json cases.json
const fs = require('fs');
const { Engine } = require('./conv.js');
const units = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const cases = JSON.parse(fs.readFileSync(process.argv[3], 'utf8'));
let ok = 0, bad = 0, errOk = 0, shown = 0;
for (const c of cases) {
  const eng = new Engine(units, { variant: c.variant });
  let got, err = null;
  try { got = eng.convert(c.q); } catch (e) { err = e.message; }
  if (c.error || c.rows.length === 0) {
    if (err) { errOk++; continue; }
    bad++; if (shown++ < 15) console.log('expected an error', JSON.stringify(c.q), c.error, '-> got', got && got.slice(0, 2)); continue;
  }
  if (err) { bad++; if (shown++ < 15) console.log('unexpected error', err, JSON.stringify(c.q)); continue; }
  // groups of equal values may come in any order
  let fine = got.length === c.rows.length, i = 0;
  while (fine && i < got.length) {
    let j = i; while (j + 1 < got.length && got[j + 1].value === got[i].value) j++;
    const g = got.slice(i, j + 1).map((r) => r.text + '\t' + r.name).sort();
    const e = c.rows.slice(i, j + 1).map((r) => r[0] + '\t' + r[1]).sort();
    for (let t = 0; t < g.length; t++) if (g[t] !== e[t]) {
      fine = false; if (shown++ < 15) console.log('mismatch', JSON.stringify(c.q), c.variant, '\n   expected', e[t], '\n   got     ', g[t]);
    }
    i = j + 1;
  }
  fine ? ok++ : bad++;
}
console.log(`cases ok=${ok} errors-as-expected=${errOk} bad=${bad}`);
process.exit(bad ? 1 : 0);
