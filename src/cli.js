#!/usr/bin/env node
// cli.js -- try conv.js from the command line
//   node cli.js URI [--json]                 the UUS API form:  node cli.js "1Z0*harmon1nic-1/meter_SI1second_SI-1"
//   node cli.js QUANTITY TARGET [--json]     the core form:     node cli.js "1;6*meter" SI/meter
//   --units FILE                             another units.json
const fs = require('fs'); const path = require('path'); const Conv = require('./conv.js');
const args = process.argv.slice(2); const json = args.includes('--json');
let file = path.join(__dirname, 'units.json'); const i = args.indexOf('--units'); if (i >= 0) { file = args[i + 1]; args.splice(i, 2); }
const rest = args.filter((a) => a !== '--json');
const c = Conv.load(JSON.parse(fs.readFileSync(file, 'utf8')));
try {
  const r = rest.length === 1 ? c.request(rest[0]) : c.query(rest[0], rest[1]);
  if (json) { console.log(JSON.stringify(r, null, 2)); process.exit(0); }
  if (r.kind === 'unit') {
    const u = r.unit;
    console.log(`${u.uri}: ${u.description} (${u.system}${u.variant ? ', ' + u.variant : ''}; SI ${JSON.stringify(u.si)})`);
    for (const w of u.rows) console.log(`  ${w.dimension}: ${w.key}`);
    process.exit(0);
  }
  const Q = r.query;
  console.log(`${r.uri || Q.canonical}  (${Q.dimension.title}${Q.also.length ? '; also ' + Q.also.join(', ') : ''}; SI ${Q.si})`);
  for (const x of r.results) console.log(`  ${x.text.padStart(30)}  ${x.expression}${x.description ? '  -- ' + x.description : ''}`);
} catch (e) {
  if (!(e instanceof Conv.ConvError)) throw e;
  console.error(`${e.status} ${e.code}: ${e.message}` + (e.position !== undefined ? ` (at ${e.position})` : '') + (e.hint ? `\n  hint: ${e.hint}` : ''));
  process.exit(1);
}
