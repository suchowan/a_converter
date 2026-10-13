// build_page.js -- make the pages (run in src/ of the a_converter repository)
//   ../js/index.html     the converter for everyone (conv.cgi's form); loads conv.js, ui.js, units.json
//   ../js/api.html       the UUS API tester (requests after "#"); loads conv.js and units.json
//   ../404.html          the API tester in one file with absolute links: GitHub Pages answers
//                        /units/REQUEST with it
//   converter_one.html   the converter in one file (works offline, opened as a file); not published
// Templates: converter.html, page.html (here). Scripts and data: ../js/conv.js, ../js/ui.js, ../js/units.json
const fs = require('fs'); const path = require('path');
const here = (f) => path.join(__dirname, f), js = (f) => path.join(__dirname, '..', 'js', f);
const safe = (s) => s.replace(/<\/(script)/gi, '<\\/$1').replace(/<!--/g, '<\\!--');
const inline = (f) => '<script>\n' + safe(fs.readFileSync(f, 'utf8')) + '\n</script>';
const units = '<script>window.UUS_UNITS = ' + safe(JSON.stringify(JSON.parse(fs.readFileSync(js('units.json'), 'utf8')))) + ';</script>';
const SITE = 'https://suchowan.github.io/a_converter/js/';
const conv = fs.readFileSync(here('converter.html'), 'utf8');
const page = fs.readFileSync(here('page.html'), 'utf8');
const out = {
  [js('index.html')]: conv.replace('<!--CONV_JS-->', '<script src="conv.js"></script>').replace('<!--UNITS_JSON-->', '').replace('<!--UI_JS-->', '<script src="ui.js"></script>'),
  [js('api.html')]: page.replace('<!--CONV_JS-->', '<script src="conv.js"></script>').replace('<!--UNITS_JSON-->', ''),
  [path.join(__dirname, '..', '404.html')]: page.replace('<!--CONV_JS-->', () => inline(js('conv.js'))).replace('<!--UNITS_JSON-->', () => units)
    .replace('href="index.html"', 'href="' + SITE + 'index.html"'),
  [here('converter_one.html')]: conv.replace('<!--CONV_JS-->', () => inline(js('conv.js'))).replace('<!--UNITS_JSON-->', () => units).replace('<!--UI_JS-->', () => inline(js('ui.js'))),
};
for (const [f, s] of Object.entries(out)) { fs.writeFileSync(f, s); console.log(path.relative(process.cwd(), f), s.length); }
