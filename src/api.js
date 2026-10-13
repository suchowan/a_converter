#!/usr/bin/env node
/*
 * api.js -- the UUS API as a CGI script (Node), next to conv.js and units.json
 *
 *   api.js?api=9E0*harmon/foot_TRAD.json   the answer as JSON (also without ".json")
 *   api.js?api=9E0*harmon/foot_TRAD.html   a redirect to conv.cgi showing the same conversion
 *
 * Copyright (c) 2011-2026 Takashi Suga
 * This software is released under the MIT License.
 *
 * Errors answer JSON { error: { code, message, position?, hint? } } with the HTTP status of the
 * error (400, 404, 409, 422). No CORS header is sent.
 */
'use strict';
const fs = require('fs');
const path = require('path');
const Conv = require('./conv.js');

// where ".html" requests go; the page that imitates conv.cgi takes the same parameters
const CONV_CGI = process.env.UUS_CONV_CGI || 'http://hosi.org/cgi-bin/conv.cgi';
// "render" answers ".html" with a page of its own instead of a redirect
const HTML = process.env.UUS_HTML || 'redirect';

function reply(status, type, body, extra = '') {
  process.stdout.write(`Status: ${status}\r\nContent-Type: ${type}; charset=utf-8\r\n${extra}\r\n`);
  process.stdout.write(body);
}

function main() {
  // the api parameter, taken from the query string as it is ("+" stays "+": it is not a space here)
  const qs = process.env.QUERY_STRING || process.argv[2] || '';
  const m = /(?:^|&)api=([^&]*)/.exec(qs);
  const api = m ? m[1] : '';
  let converter;
  try {
    converter = Conv.load(JSON.parse(fs.readFileSync(path.join(__dirname, 'units.json'), 'utf8')));
  } catch (e) {
    return reply(500, 'application/json', JSON.stringify({ error: { code: 'internal', message: 'units.json could not be read' } }));
  }
  let r;
  try {
    r = converter.request(api);
  } catch (e) {
    if (!(e instanceof Conv.ConvError)) {
      return reply(500, 'application/json', JSON.stringify({ error: { code: 'internal', message: 'internal error' } }));
    }
    const html = /\.html$/.test(decodeSafe(api));
    if (html && HTML === 'render') return reply(e.status, 'text/html', page('Error', Conv.errorHTML(e, api)));
    return reply(e.status, 'application/json', JSON.stringify({ error: e }, null, 1));
  }
  if (r.type === 'html') {
    if (HTML === 'render') return reply(200, 'text/html', page(r.uri || r.unit.uri, converter.toHTML(r, (u) => '?api=' + encodeURIComponent(u) + '.html')));
    const url = converter.cgiURL(r, CONV_CGI);
    return reply(302, 'text/html', `<a href="${Conv.escapeHTML(url)}">${Conv.escapeHTML(url)}</a>\n`, `Location: ${url}\r\n`);
  }
  return reply(200, 'application/json', JSON.stringify(r, null, 1));
}
function decodeSafe(s) { try { return decodeURIComponent(s); } catch (e) { return s; } }
function page(title, body) {
  return `<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${Conv.escapeHTML(title)} — UUS API</title>
<style>body{font:16px/1.5 system-ui,sans-serif;max-width:980px;margin:0 auto;padding:16px}table{border-collapse:collapse}
th,td{border-bottom:1px solid #ccc;padding:4px 8px;text-align:left}td.q{font-family:monospace;text-align:right;white-space:nowrap}</style>
</head><body>${body}</body></html>\n`;
}

main();
