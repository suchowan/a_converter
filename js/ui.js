/*
 * ui.js -- the conv.cgi form, in the browser, on conv.js and units.json
 *
 * Copyright (c) 2011-2026 Takashi Suga
 * This software is released under the MIT License.
 *
 * The page keeps conv.cgi's parameters in its address (m d fu fq fe fr fp fl fm tu tr tp tl tm), so a
 * conv.cgi address works here with "conv.cgi" replaced by this page, and a page can be bookmarked.
 * A UUS API request after "#" (#9E0*harmon/foot_TRAD) is translated into the same form.
 */
(function () {
  'use strict';
  const $ = (id) => document.getElementById(id);
  const esc = Conv.escapeHTML;
  let UNITS = null;        // units.json as loaded (every system, every category)
  let view = null;         // the dimensions and units this configuration shows
  let eng = null, cfg = null, Q = null;

  // ---------------------------------------------------------------- configuration (conv.rb class Mode)
  function mode(code) {
    const m = parseInt(code, 16) || 0, bit = (k) => (m >> k) & 1;
    const t = (bit(11) * 2 + bit(10) - 1 + 3) % 3, u = (bit(9) * 2 + bit(8) - 1 + 4) % 4;
    let precision = m & 15; if (precision === 0) precision = 7;
    return {
      code: ('00000' + m.toString(16)).slice(-5), mode: m,
      idus: bit(16) === 1, comma: bit(15) ? '.' : ',', period: bit(15) ? ',' : '.', xe: bit(14) === 0,
      tonal: bit(13) === 0, tgm: t !== 0, lightvlos: ['eliminate', 'exactly', 'not exactly'][t],
      uus: u !== 0, prefix: ['eliminate', 'universal', 'GCD', 'harmonic'][u],
      category: 7 - ((m >> 4) & 7), precision,
    };
  }
  function modeCode(c) {      // the inverse, for the configuration form
    let m = c.precision === 7 ? 0 : c.precision;
    if (c.idus) m |= 1 << 16;
    if (c.comma === '.') m |= 0x8000;
    if (!c.xe) m |= 0x4000;
    if (!c.tonal) m |= 0x2000;
    m |= ((['eliminate', 'exactly', 'not exactly'].indexOf(c.lightvlos) + 1) % 3) << 10;
    m |= ((['eliminate', 'universal', 'GCD', 'harmonic'].indexOf(c.prefix) + 1) % 4) << 8;
    m |= 0x80;                                   // unit names: alias (harmon, nic, looloh)
    m |= (7 - c.category) << 4;
    return ('00000' + m.toString(16)).slice(-5);
  }
  const DIGITS = { 2: '01', 3: '012', 4: '0123', 6: '012345', 8: '01234567', 10: '0123456789', 15: '0123456789A..E',
    16: '0123456789A..F', 21: '0123456789A..K', 24: '0123456789A..N', 30: '0123456789A..T', 32: '0123456789A..V' };
  const RADIXES = [2, 3, 4, 6, 8, 10, 12, 15, 16, 21, 24, 30, 32];

  // the dimensions and units of a configuration, as conv.rb's Units.delete_if leaves them
  function makeView(c) {
    const drop = (u) => (['Univ', 'NilU'].includes(u.prefix) && !c.uus) || (u.prefix === 'TGM' && !c.tgm) ||
      (u.prefix === 'SDN' && !c.idus) || (u.prefix === 'Tonal' && !c.tonal);
    const dims = [];
    UNITS.dimensions.forEach((D) => {
      // calendars are not ported yet; the dimension keeps its place so that conv.cgi's numbers stay the same
      if (D.calendar) { if (((parseInt(D.category, 2) >> c.category) & 1) === 1) dims.push(Object.assign({}, D, { source: D.index })); return; }
      const units = D.units.filter((u) => !drop(u));
      if (units.length < 2 || ((parseInt(D.category, 2) >> c.category) & 1) === 0) return;
      // the defaults count units that this configuration may have dropped
      dims.push(Object.assign({}, D, { units, source: D.index }));
    });
    return { prefixes: UNITS.prefixes, dimensions: dims, names: UNITS.names };
  }

  // ---------------------------------------------------------------- the query (conv.rb #query)
  function defaults(d) { return Object.assign({}, view.dimensions[d].defaults || {}); }
  function normalize(q) {
    const D = view.dimensions[q.d] || view.dimensions[0];
    q.d = view.dimensions.indexOf(D);
    if (D.calendar) return q;
    const unitRadix = (u) => { const r = eng.prefixRadix(u); return r > 36 ? 10 : r; };
    const n = D.units.length;
    q.tu = q.tu === undefined || q.tu === '' ? 1 : Number(q.tu); if (q.tu < -1 || q.tu >= n) q.tu = Math.min(1, n - 1);
    q.fu = q.fu === undefined || q.fu === '' ? 0 : Number(q.fu); if (q.fu < 0 || q.fu >= n) q.fu = 0;
    q.tr = Number(q.tr) || unitRadix(D.units[Math.max(q.tu, 0)]); if (q.tr > 36) q.tr = 10;
    q.fr = Number(q.fr) || unitRadix(D.units[q.fu]); if (q.fr > 36) q.fr = 10;
    q.tp = Number(q.tp) || 0; q.fp = Number(q.fp) || 0; q.tl = Number(q.tl) || 0; q.fl = Number(q.fl) || 0;
    q.tm = q.tm === true || q.tm === 'on'; q.fm = q.fm === true || q.fm === 'on';
    if (q.fe === undefined || q.fe === '') q.fe = '0';
    if (q.fq === undefined || q.fq === '') q.fq = '1' + cfg.period + '0'.repeat(cfg.precision);
    return q;
  }
  function fromAddress() {
    const p = new URLSearchParams(location.search);
    const q = {}; for (const [k, v] of p) q[k] = v;
    const c = q.c;
    let out;
    if (c === 'd') out = Object.assign({ d: Number(q.d) || 0, fu: 0, tu: 1 }, defaults(Number(q.d) || 0));
    else if (c === 'Convert' || c === 'fu' || c === 'tu' || q.d !== undefined) {
      out = { d: Number(q.d) || 0 };
      ['fu', 'fq', 'fe', 'fr', 'fp', 'fl', 'fm', 'tu', 'tr', 'tp', 'tl', 'tm'].forEach((k) => { if (q[k] !== undefined) out[k] = q[k]; });
      const dd = defaults(out.d);
      if (c === 'fu') ['fp', 'fr', 'fl', 'fq', 'fe'].forEach((k) => { out[k] = dd[k]; });
      if (c === 'tu') ['tp', 'tr', 'tl'].forEach((k) => { out[k] = dd[k]; });
    } else out = Object.assign({ d: 0, fu: 0, tu: 1 }, defaults(0));
    return normalize(out);
  }
  function toAddress(q) {
    const p = new URLSearchParams();
    p.set('m', cfg.code);
    for (const k of ['d', 'fu', 'fq', 'fe', 'fr', 'fp', 'fl', 'tu', 'tr', 'tp', 'tl']) p.set(k, q[k]);
    p.set('fm', q.fm ? 'on' : 'off'); p.set('tm', q.tm ? 'on' : 'off'); p.set('c', 'Convert');
    return '?' + p.toString();
  }

  // ---------------------------------------------------------------- the form
  const opt = (v, text, sel) => `<option value="${esc(v)}"${sel ? ' selected' : ''}>${text}</option>`;
  function unitText(u) {
    let t = eng.pick(u.name);
    if (/natural |^solar.+\)/.test(t)) t = t.replace(/natural |^solar /, '');
    return t.replace(/<.+?>/g, ' ');
  }
  function powerOptions(D, ui, sel) {
    const u = D.units[Math.max(ui, 0)];
    const P = view.prefixes[u.prefix === null ? '' : u.prefix] || view.prefixes[''];
    const radix = P.radix <= 36 ? P.radix : 10;
    const name = eng.pick(u.name);
    return P.steps.slice().reverse().map(([t, e]) => {
      let text = t;
      if (/natural/.test(name)) {
        if (/GCD|harmonic/.test(text)) text = text.replace(/GCD|harmonic/, 'natural');
        else { const i = text.search(/mic/); const at = i >= 0 ? i + 3 : 0; text = text.slice(0, at) + ' natural ' + text.slice(at); }
      } else if (/^(Coulomb|mole)/.test(name)) text = text.replace(/GCD|harmonic/, 'universal');
      else if (/^solar.+\)$/.test(name)) text = text.replace(/\[(universal|harmonic)\]/, '[GCD] solar');
      if (!/&nbsp;/.test(text)) {
        let s = Math.abs(e).toString(radix).toUpperCase(); if (radix === 12 && cfg.xe) s = s.replace(/A/g, 'X').replace(/B/g, 'E');
        text = `(${e < 0 ? '-' : ''}${s}) ${text}`;
      }
      return opt(e, text, e === sel);
    }).join('');
  }
  function radixOptions(sel, full) {
    return RADIXES.map((k) => opt(k, full ? `${k}${cfg.period} - (${k === 12 ? (cfg.xe ? '0123456789XE' : '0123456789AB') : DIGITS[k]})` : `${k}${cfg.period}`, k === sel)).join('');
  }
  function logOptions(sel) {
    return Object.keys(Conv.LOGS).map(Number).sort((a, b) => a - b).map((k) => opt(k, Conv.LOGS[k][0], k === sel)).join('');
  }
  function drawForm() {
    const D = view.dimensions[Q.d];
    $('d').innerHTML = view.dimensions.map((x, i) => opt(i, `(${i + 1}) ${esc(x.title)}`, i === Q.d)).join('');
    document.querySelectorAll('#form select:not(#d), #form input').forEach((e) => { e.disabled = !!D.calendar; });
    document.querySelectorAll('.cat a').forEach((a) => a.classList.toggle('on', Number(a.dataset.k) === 7 - cfg.category));
    if (D.calendar) { ['fu', 'tu', 'fp', 'tp', 'fr', 'tr', 'fl', 'tl', 'frq'].forEach((k) => { $(k).innerHTML = ''; }); return; }
    $('fq').value = Q.fq; $('fe').value = Q.fe;
    $('frq').innerHTML = radixOptions(Q.fr, false);
    const units = D.units.map((u, i) => opt(i, unitText(u), false)).join('');
    $('fu').innerHTML = units; $('fu').value = String(Q.fu);
    $('tu').innerHTML = opt(-1, '--- All ---', false) + units; $('tu').value = String(Q.tu);
    $('fp').innerHTML = powerOptions(D, Q.fu, Q.fp);
    $('fr').innerHTML = radixOptions(Q.fr, true);
    $('fl').innerHTML = logOptions(Q.fl);
    $('fm').checked = Q.fm;
    const all = Q.tu === -1;
    $('tp').innerHTML = all ? opt(0, '&nbsp;&nbsp;&nbsp;&nbsp;', true) : powerOptions(D, Q.tu, Q.tp);
    $('tr').innerHTML = all ? opt(10, '&nbsp;&nbsp;&nbsp;&nbsp;', true) : radixOptions(Q.tr, true);
    $('tl').innerHTML = logOptions(Q.tl);
    $('tm').checked = Q.tm;
    ['tp', 'tr'].forEach((k) => { $(k).disabled = all; });
    document.querySelectorAll('.cat a').forEach((a) => a.classList.toggle('on', Number(a.dataset.k) === 7 - cfg.category));
  }
  function readForm() {
    Q.fq = $('fq').value; Q.fe = $('fe').value;
    Q.fu = Number($('fu').value); Q.tu = Number($('tu').value);
    Q.fp = Number($('fp').value); Q.fr = Number($('fr').value); Q.fl = Number($('fl').value); Q.fm = $('fm').checked;
    Q.tp = Number($('tp').value); Q.tr = Number($('tr').value); Q.tl = Number($('tl').value); Q.tm = $('tm').checked;
  }

  // ---------------------------------------------------------------- the answer (conv.rb #ratio)
  function convert() {
    const D = view.dimensions[Q.d];
    if (D.calendar) {
      $('out').innerHTML = '<p class="err">The calendars of the Date dimension are not in this converter yet; please use <a href="http://hosi.org/cgi-bin/conv.cgi?m=100f0&amp;c=d&amp;d=1">conv.cgi</a>.</p>';
      history.replaceState(null, '', '?m=' + cfg.code + '&d=' + Q.d + '&c=d');
      permalinks();
      return;
    }
    try {
      const r = eng.convert({ d: Q.d, fu: Q.fu, fq: Q.fq, fe: Q.fe, fr: Q.fr, fp: Q.fp, fl: Q.fl, tu: Q.tu, tr: Q.tr, tp: Q.tp, tl: Q.tl, tm: Q.tm });
      if (typeof r === 'string') {
        $('out').innerHTML = `<p class="single"><span class="q">${r}</span> <span class="u">${esc(unitText(D.units[Q.tu]))}</span></p>`;
      } else {
        $('out').innerHTML = '<div class="wrap"><table class="res"><thead><tr><th>#</th><th>quantity</th><th>unit or constant</th></tr></thead><tbody>' +
          r.map((x) => `<tr><td class="n">${x.n}</td><td class="q">${x.text}</td><td>${esc(unitText(D.units[x.unit]))}</td></tr>`).join('') +
          '</tbody></table></div>';
      }
    } catch (e) {
      $('out').innerHTML = `<p class="err">Irregal quantity: '${esc(Q.fq)}'</p>`;
    }
    permalinks();
    history.replaceState(null, '', toAddress(Q) + location.hash);
  }


  // ---------------------------------------------------------------- permanent links (UUS API URIs)
  // The units and the conversion of the form, written as UUS API requests under http://dozenal.com/units/.
  // A conversion gets a URI only when the request, read back by conv.js, is the same conversion.
  const URI_BASE = 'http://dozenal.com/units/';
  const VIEW_BASE = 'https://suchowan.github.io/a_converter/js/api.html#';
  let api = null;
  const apiConv = () => api || (api = Conv.load(UNITS));
  const href = (req) => encodeURI(req).replace(/#/g, '%23');
  function unitRequest(u) {
    const c = apiConv();
    const first = u.expression.split(/\s*=\s*/)[0];
    const v = cfg.prefix === 'universal' || cfg.prefix === 'GCD' ? cfg.prefix : '';
    let s = c.uriExpr(c.render(first.replace(/^°/, ''), v));
    if (cfg.lightvlos === 'exactly') s = s.replace(/_TGM(?!_)/g, '_TGM_exact');
    return { req: s, scale: first.startsWith('°') };
  }
  // VALUE of the form: the mantissa as typed, E (decimal) or Z (duodecimal), the exponent in decimal
  function valueRequest() {
    if (Q.fr !== 10 && Q.fr !== 12) return null;
    let m = String(Q.fq).trim().replace(/^\+/, '').split(cfg.comma).join('').replace(/\s+/g, '');
    if (cfg.period !== '.') m = m.split(cfg.period).join('.');
    if (/[T:'`]/.test(m)) return null;                     // subunits are not written in a URI
    if (Q.fr === 12) m = m.replace(/[XxAa]/g, 'x').replace(/[EeBb]/g, 'e');
    let t = String(Q.fe).trim();
    if (Q.fr === 12) t = t.replace(/[Xx]/g, 'A').replace(/[Ee]/g, 'B');
    const em = /^([-+]?)([0-9A-Za-z]*)/.exec(t);
    let body = '';                                        // as conv.cgi reads it: the digits of radix fr
    for (const ch of em[2]) { if (isNaN(parseInt(ch, Q.fr))) break; body += ch; }
    const e = (body ? parseInt(body, Q.fr) : 0) * (em[1] === '-' ? -1 : 1);
    return m + (Q.fr === 10 ? 'E' : 'Z') + e;
  }
  function uriLink(req, cls) {
    return `<a class="${cls || ''}" href="${esc(URI_BASE + href(req))}" title="the UUS API (JSON)">${esc(req)}</a>`;
  }
  function permalinks() {
    const D = view.dimensions[Q.d];
    $('fu-uri').innerHTML = ''; $('tu-uri').innerHTML = ''; $('perma').innerHTML = '';
    if (!D || D.calendar) return;
    const all = UNITS.dimensions[D.source].units;
    const fu = D.units[Q.fu], tu = Q.tu >= 0 ? D.units[Q.tu] : null;
    const f = unitRequest(fu), t = tu ? unitRequest(tu) : null;
    $('fu-uri').innerHTML = uriLink(f.req);
    if (t) $('tu-uri').innerHTML = uriLink(t.req);
    const value = valueRequest();
    let req = null;
    if (value !== null && (!tu || Q.tp === 0)) {
      // in a logarithmic dimension, the type Non is the quantity itself, written without "°"
      const logDim = D.title !== 'Thermodynamic temperature';
      const fScale = f.scale && !(logDim && Q.fl === 0), tScale = t && t.scale && !(logDim && Q.tl === 0);
      req = value + (fScale ? '°' : '*') + f.req + '/' + (t ? (tScale ? '°' : '') + t.req : '*');
      try {                                                // the same conversion when read back?
        const r = apiConv().request(req);
        const si = eng.fromQuantity({ d: Q.d, fu: Q.fu, fq: Q.fq, fe: Q.fe, fr: Q.fr, fp: Q.fp, fl: Q.fl }).si;
        const ok = r.kind === 'conversion' && r.query.dimension.index === D.source && all[r.query.row] === fu &&
          r.query.read.fl === Q.fl && (tu ? r.results.length === 1 && all[r.results[0].row] === tu && r.query.read.tl === Q.tl : r.results.length > 1) &&
          Math.abs(r.query.si - si) <= 1e-12 * Math.abs(si);
        if (!ok) req = null;
      } catch (e) { req = null; }
    }
    $('perma').innerHTML = req
      ? `URI: <code>${uriLink(req)}</code><button type="button" id="copy-uri">Copy</button> <a href="${esc(VIEW_BASE + href(req))}">view</a>`
      : 'This conversion has no URI (a radix other than 10 and 12, a prefix, subunits or a type the UUS API does not write).';
    if (req) $('copy-uri').addEventListener('click', () => {
      const text = URI_BASE + href(req);
      (navigator.clipboard ? navigator.clipboard.writeText(text) : Promise.reject()).then(
        () => { $('copy-uri').textContent = 'Copied'; setTimeout(() => { if ($('copy-uri')) $('copy-uri').textContent = 'Copy'; }, 1500); },
        () => { window.prompt('URI', text); });
    });
  }

  // ---------------------------------------------------------------- events
  function setup(units) {
    UNITS = units;
    const p = new URLSearchParams(location.search);
    cfg = mode(p.get('m') || '100f0');
    view = makeView(cfg);
    eng = new Conv.Engine(view, {
      variant: cfg.prefix === 'universal' ? 'universal' : cfg.prefix === 'GCD' ? 'GCD' : '',
      tgm: cfg.lightvlos === 'exactly' ? 'exact' : '', xe: cfg.xe, comma: cfg.comma, period: cfg.period, precision: cfg.precision });
    const req = requestHash();
    Q = req ? fromRequest(req) || fromAddress() : fromAddress();
    drawForm(); convert(); drawConfig();
  }
  // the UUS API request after "#", or null; a "#" naming an element of the page (#config-panel) is not a request
  function requestHash() {
    const h = location.hash.slice(1);
    if (!h) return null;
    let id = h; try { id = decodeURIComponent(h); } catch (e) {}
    const el = document.getElementById(id);
    if (el && el.tagName === 'DETAILS') el.open = true;
    return el ? null : h;
  }
  // a UUS API request (#...) -> the form, through the redirect parameters of conv.js
  function fromRequest(req) {
    try {
      const c = Conv.load(UNITS);
      const r0 = c.request(req);
      if (r0.kind === 'namespace') return null;                // a list of units: api.html shows it
      const p = c.cgiParams(r0);
      const src = view.dimensions.findIndex((x) => x.source === p.d);
      if (src < 0) return null;
      const D = view.dimensions[src], all = UNITS.dimensions[p.d].units;
      const at = (i) => (i < 0 ? -1 : D.units.indexOf(all[i]));
      if (at(p.fu) < 0) return null;
      $('note').textContent = '';
      return normalize({ d: src, fu: at(p.fu), fq: p.fq, fe: p.fe, fr: p.fr, fp: 0, fl: p.fl, tu: p.tu < 0 ? -1 : at(p.tu), tl: p.tl, tm: false });
    } catch (e) {
      $('note').innerHTML = e instanceof Conv.ConvError ? Conv.errorHTML(e, req) : esc(String(e));
      return null;
    }
  }
  function on(id, ev, f) { $(id).addEventListener(ev, f); }
  function wire() {
    on('d', 'change', () => { const d = Number($('d').value); Q = normalize(Object.assign({ d, fu: 0, tu: 1 }, defaults(d))); drawForm(); convert(); });
    on('fu', 'change', () => { readForm(); const dd = defaults(Q.d); ['fp', 'fl', 'fq', 'fe'].forEach((k) => { Q[k] = dd[k]; }); Q.fr = undefined; normalize(Q); drawForm(); convert(); });
    on('tu', 'change', () => { readForm(); const dd = defaults(Q.d); ['tp', 'tl'].forEach((k) => { Q[k] = dd[k]; }); Q.tr = undefined; normalize(Q); drawForm(); convert(); });
    on('frq', 'change', () => { $('fr').value = $('frq').value; readForm(); convert(); });
    on('fr', 'change', () => { $('frq').value = $('fr').value; readForm(); convert(); });
    ['fp', 'fl', 'fm', 'tp', 'tr', 'tl', 'tm'].forEach((k) => on(k, 'change', () => { readForm(); convert(); }));
    ['fq', 'fe'].forEach((k) => on(k, 'input', () => { readForm(); convert(); }));
    on('form', 'submit', (ev) => { ev.preventDefault(); readForm(); convert(); });
    on('reset', 'click', () => { Q = normalize(Object.assign({ d: Q.d, fu: 0, tu: 1 }, defaults(Q.d))); drawForm(); convert(); });
    on('swap', 'click', () => {
      readForm(); if (Q.tu === -1) return;
      [Q.fu, Q.tu] = [Q.tu, Q.fu]; [Q.fp, Q.tp] = [Q.tp, Q.fp]; [Q.fr, Q.tr] = [Q.tr, Q.fr]; [Q.fl, Q.tl] = [Q.tl, Q.fl]; [Q.fm, Q.tm] = [Q.tm, Q.fm];
      drawForm(); convert();
    });
    document.querySelectorAll('.cat a').forEach((a) => a.addEventListener('click', (ev) => {
      ev.preventDefault(); cfg.category = 7 - Number(a.dataset.k); applyConfig();
    }));
    on('config', 'submit', (ev) => {
      ev.preventDefault();
      cfg.prefix = $('s').value; cfg.lightvlos = $('t').value; cfg.idus = $('i').value === '1'; cfg.tonal = $('n').value === '1';
      cfg.comma = $('r').value; cfg.period = cfg.comma === '.' ? ',' : '.'; cfg.xe = $('dg').value === '0'; cfg.precision = Number($('p').value);
      applyConfig();
    });
    window.addEventListener('hashchange', () => { const req = requestHash(); const q = req && fromRequest(req); if (q) { Q = q; drawForm(); convert(); } });
  }
  function applyConfig() {
    cfg = mode(modeCode(cfg));
    const p = new URLSearchParams(); p.set('m', cfg.code);
    history.replaceState(null, '', '?' + p.toString());
    setup(UNITS);
  }
  function drawConfig() {
    const sel = (id, v) => { $(id).value = v; };
    sel('s', cfg.prefix); sel('t', cfg.lightvlos); sel('i', cfg.idus ? '1' : '0'); sel('n', cfg.tonal ? '1' : '0');
    sel('r', cfg.comma); sel('dg', cfg.xe ? '0' : '1'); sel('p', String(cfg.precision));
  }

  window.addEventListener('DOMContentLoaded', () => {
    wire();
    if (window.UUS_UNITS) setup(window.UUS_UNITS);
    else fetch('units.json').then((r) => r.json()).then(setup).catch((e) => { $('out').textContent = 'units.json could not be loaded: ' + e; });
  });
})();
