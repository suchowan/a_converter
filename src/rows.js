// rows.js -- every row of units.json, asked by its own expression, must convert like conv.cgi does
const fs = require('fs'); const Conv = require('./conv.js');
const units = JSON.parse(fs.readFileSync(process.argv[2] || 'units.json', 'utf8'));
const c = Conv.load(units); const eng = new Conv.Engine(units);
let ok = 0, bad = 0, amb = 0;
units.dimensions.forEach((D, d) => {
  if (D.calendar) return;
  D.units.forEach((u, i) => {
    for (const part of u.expression.split(' = ')) {
      const scale = part.startsWith('°'); const e = part.replace(/^°/, '');
      const first = D.units[0].expression.split(' = ')[0];
      const r0 = eng.defaultRadix(u);
      const val = r0 === 12 ? '1;0000000' : '1.0000000';
      try {
        const r = c.query(val + (scale ? '°' : '*') + e, first);
        const fl = scale && D.title !== 'Thermodynamic temperature' ? (D.defaults.fl || 0) : 0;
        const tl = first.startsWith('°') && D.title !== 'Thermodynamic temperature' ? (D.defaults.fl || 0) : 0;
        const want = eng.convert({ d, fu: i, fq: val, fe: '0', fr: r0, fl, tu: 0, tl, tm: false });
        if (r.results[0].html === want && (r.query.dimension.index === d || r.query.also.includes(D.title))) ok++;
        else { bad++; if (bad < 10) console.log(D.title, '|', part, '->', first, ':', r.results[0].html, 'want', want, r.query.dimension.title); }
      } catch (err) {
        if (err.code === 'ambiguous') { amb++; console.log('amb', D.title, '|', part, '->', D.units[0].expression); continue; }
        bad++; if (bad < 10) console.log(D.title, '|', part, 'ERROR', JSON.stringify(err));
      }
    }
  });
});
console.log(`rows ok=${ok} bad=${bad} ambiguous=${amb}`);
