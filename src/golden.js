// golden.js -- compare conv.js with pages saved from the production conv.cgi
//   node golden.js units.json <log dir> <variant: harmonic | universal | GCD>
// The saved pages predate some fixes of conv.rb texts and values; those are listed in RENAMED and
// CHANGED and reported separately. conv.rb sorts the table with an unstable sort, so rows whose
// values are equal may come in any order among themselves.
const fs = require('fs'); const path = require('path');
const { Engine } = require('./conv.js');
const [, , uj, dir, variant] = process.argv;
const units = JSON.parse(fs.readFileSync(uj, 'utf8'));
const eng = new Engine(units, { variant: variant === 'harmonic' ? '' : variant });
const RENAMED = {                                   // text in the saved pages -> text in conv.rb now
  'lighttim(12.)': 'lightTim(12.)', 'dour(12.)': 'solar unitia or dour', 'Vlov^4 / Mag': 'Vlos^4 / Mag',
  'gravitic meter/second)^4/Newton': '(gravitic meter/second)^4/Newton', 'Graft/Tim^2': 'Grafut/Tim^2',
  'Spig ': 'Spig', 'Pv / Steradian': 'Povi / Steradian', 'radaQuel@Reluctance': '1/Tim/Og',
  'Bolzmann': 'Boltzmann', 'Yound / Berzel': 'Young / Berzel', 'effective Watt(12.)/sphere': 'effective Watt(12.)/turn(12.)',
  'radian meter(10.)^2 / mole(12.)': 'radian meter(10.)^2 / mole(10.)',
};
const CHANGED = ['atmosphere (recommend for UUS)'];  // value changed on purpose (2026-10-12)
let ok = 0, bad = 0, pages = 0, skipped = 0, renamed = 0, changed = 0, gone = 0;
for (const f of fs.readdirSync(dir).filter((f) => /\.html$/.test(f)).sort()) {
  const html = fs.readFileSync(path.join(dir, f), 'utf8').replace(/\r/g, '');
  const sel = (name) => {
    const m = new RegExp("<select name='" + name + "'[^>]*>([\\s\\S]*?)</select>").exec(html);
    if (!m) return undefined;
    const o = /<option selected value='?(-?\d+)'?/.exec(m[1]);
    return o ? Number(o[1]) : undefined;
  };
  const fqm = /name='fq'[^>]*value=([^ >]*)>/.exec(html);
  const fem = /name='fe'[^>]*value=([^ >]*)>/.exec(html);
  const d = sel('d');
  const rows = [...html.matchAll(/<tr><td align=right>(\d+)<\/td><td>([^<]*)<\/td><td>([^<]*)<\/td><\/tr>/g)];
  if (d === undefined || !fqm || rows.length === 0) { skipped++; continue; }
  const q = { d, fu: sel('fu'), fq: fqm[1], fe: fem ? Number(fem[1]) : 0, fr: sel('fr'), fp: sel('fp') || 0,
              fl: sel('fl') || 0, tl: sel('tl') || 0, tu: -1, tm: false };
  pages++;
  let got;
  try { got = eng.convert(q); } catch (e) { console.log(f, 'ERROR', e.message); bad += rows.length; continue; }
  const title = units.dimensions[d].title;
  let exp = rows.map((r) => {
    let name = r[3], ren = RENAMED[name + '@' + title] || RENAMED[name];
    if (ren) { renamed++; name = ren; }
    return { text: r[2], name };
  });
  const names = new Set(got.map((g) => g.name));
  exp = exp.filter((e) => names.has(e.name) || (gone++, console.log(`${f}: '${e.name}' is no longer in conv.rb`), false));
  // rows whose value was changed on purpose are left out on both sides
  changed += exp.filter((e) => CHANGED.includes(e.name)).length;
  exp = exp.filter((e) => !CHANGED.includes(e.name)); got = got.filter((g) => !CHANGED.includes(g.name));
  // compare group by group of equal values
  let i = 0;
  while (i < got.length) {
    let j = i; while (j + 1 < got.length && got[j + 1].value === got[i].value) j++;
    const k = (r) => r.text + '\t' + r.name;
    const g = got.slice(i, j + 1).map(k).sort(), e = exp.slice(i, j + 1).map(k).sort();
    for (let t = 0; t < g.length; t++) {
      if (g[t] === e[t]) { ok++; continue; }
      bad++;
      if (bad <= 30) console.log(`${f} d=${d} rows ${i + 1}-${j + 1}: expected ${e[t]}  got ${g[t]}`);
    }
    i = j + 1;
  }
  if (got.length !== exp.length) console.log(f, 'row count', got.length, exp.length);
}
console.log(`${variant}: pages=${pages} skipped=${skipped} rows ok=${ok} mismatch=${bad} ` +
            `(renamed since ${renamed}, value changed on purpose ${changed}, removed ${gone})`);
process.exit(bad ? 1 : 0);
