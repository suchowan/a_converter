/*
 * conv.js -- the unit converter of conv.rb, running on units.json alone
 *
 * Copyright (c) 2011-2026 Takashi Suga
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 *
 * Two layers:
 *   Engine  a port of conv.rb's numerics and number formatting (conv.cgi's "Convert"),
 *           driven by the same parameters (d, fu, fq, fe, fr, fp, fl, tu, tr, tp, tl, tm).
 *           It is tested against pages saved from the production conv.cgi.
 *   query   the URI-name interface: "<VALUE>*<UNITS>" or "<VALUE>°<UNITS>", converted to a
 *           target <UNITS> or to every unit of the dimension; the names come from the
 *           maintained name tables (units.json "names").
 *
 * Works in a browser (global Conv) and in Node (require('./conv.js')). No dependencies.
 */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory();
  else root.Conv = factory();
}(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  // ------------------------------------------------------------------ conv.rb tables
  // Logs[type] = [description, multiplier, base]; an integer base k means radix ** k with base = radix
  const LOGS = {
    '-8': ['31.6 ^ (-quantity)', -1, Math.pow(1000, 0.5)], '-7': ['2.51 ^ (-quantity)', -1, Math.pow(100, 0.2)],
    '-6': ['(&#8730;2) ^ (-quantity)', -2, 2.0, true], '-5': ['2 ^ (-quantity)', -1, 2.0, true],
    '-4': ['(&#8730;radix) ^ (-quantity/radix)', -2, 1], '-3': ['radix ^ (-quantity/radix)', -1, 1],
    '-2': ['(&#8730;radix) ^ (-quantity)', -2, 0], '-1': ['radix ^ (-quantity)', -1, 0],
    '0': ['Non', 0, 0],
    '1': ['radix ^ quantity', 1, 0], '2': ['(&#8730;radix) ^ quantity', 2, 0],
    '3': ['radix ^ (quantity/radix)', 1, 1], '4': ['(&#8730;radix) ^ (quantity/radix)', 2, 1],
    '5': ['2 ^ quantity', 1, 2.0, true], '6': ['(&#8730;2) ^ quantity', 2, 2.0, true],
    '7': ['2.51 ^ quantity', 1, Math.pow(100, 0.2)], '8': ['31.6 ^ quantity', 1, Math.pow(1000, 0.5)],
  };
  // a float base (2.0, 1000**0.5, ...) is used as it is; the 4th field marks 2.0, which is a Float in conv.rb
  const isIntBase = (l) => Number.isInteger(l[2]) && !l[3];

  // Bases[radix] = [point, group size]
  const GROUP = { 2: 8, 3: 8, 4: 8, 6: 4, 8: 4, 10: 3, 12: 4, 15: 4, 16: 4, 21: 4, 24: 4, 30: 4, 32: 4 };

  class EngineError extends Error {}

  // radix ** n as conv.rb computes it (Integer ** Integer is exact, a negative power a Rational)
  function pw(r, n) {
    if (n >= 0) return Number(BigInt(r) ** BigInt(n));
    return 1 / Number(BigInt(r) ** BigInt(-n));
  }
  // Float#to_i.to_s(radix).upcase
  const intStr = (x, r) => {
    if (!isFinite(x)) throw new EngineError('FloatDomainError');      // Ruby: Infinity.to_i raises
    return BigInt(Math.trunc(x)).toString(r).toUpperCase();
  };


  // ------------------------------------------------------------------ Engine
  class Engine {
    // units: the parsed units.json; opts: { variant: '' | 'universal' | 'GCD', tgm: '' | 'exact',
    //   xe: true (duodecimal digits X E), comma: ',', period: '.', precision: 7 }
    constructor(units, opts = {}) {
      this.units = units;
      this.variant = opts.variant || '';
      this.tgm = opts.tgm || '';
      this.xe = opts.xe !== false;
      this.comma = opts.comma || ',';
      this.period = opts.period || '.';
      this.precision = opts.precision || 7;
    }
    pick(x) {                                  // a value that may differ between variants
      if (x === null || typeof x !== 'object' || Array.isArray(x)) return x;
      if ('universal' in x || 'GCD' in x) return x[this.variant] !== undefined ? x[this.variant] : x[''];
      if ('exact' in x) return x[this.tgm] !== undefined ? x[this.tgm] : x[''];
      return x[''];
    }
    point(r) { return r === 12 ? ';' : r === 8 ? '<sub><small>@</small></sub>' : this.period; }
    prefixRadix(u) { const p = this.units.prefixes[u.prefix === null ? '' : u.prefix] || this.units.prefixes['']; return p.radix; }
    defaultRadix(u) { const r = this.prefixRadix(u); return r > 36 ? 10 : r; }
    dim(d) {
      const D = this.units.dimensions[d];
      if (!D || D.calendar) throw new EngineError('no such dimension');
      return D;
    }

    // Unit#convert: SI value -> number in this unit (log type l)
    unitConvert(u, prefix, l, radix, other) {
      const q = (other - this.pick(u.offset)) * u.sign / (this.pick(u.factor) * pw(this.prefixRadix(u), prefix * u.power));
      if (l === 0) return q;
      const L = LOGS[l]; let base, exp;
      if (isIntBase(L)) { base = radix; exp = pw(radix, L[2]); } else { base = L[2]; exp = 1; }
      return Math.log(q) / Math.log(base) * (L[1] * exp);
    }
    // Unit#reverse: number in this unit -> SI value
    unitReverse(u, prefix, l, radix, other) {
      if (l !== 0) {
        const L = LOGS[l]; let base, exp;
        if (isIntBase(L)) { base = radix; exp = pw(radix, L[2]); } else { base = L[2]; exp = 1; }
        other = Math.pow(base, other / (L[1] * exp));
      }
      return this.pick(u.offset) + u.sign * other * (this.pick(u.factor) * pw(this.prefixRadix(u), prefix * u.power));
    }

    // conv.rb #reverse: the typed quantity -> [value, number of digits]; null if it cannot be read
    readQuantity(source, radix, power, fr) {
      let sp, unit;
      if (/T/.test(source)) [sp, unit] = fr < 30 ? [/[T:]/, [1, 60, 60, 24]] : [/:/, [1]];
      else if (/:.+'/.test(source)) [sp, unit] = [/[:']/, [1, 128, fr * 6]];
      else if (/[.;](.*)'/.test(source)) { const m = /[.;](.*)'/.exec(source); [sp, unit] = [/'/, [1, 128 * Math.pow(fr, m[1].length)]]; }
      else if (/'/.test(source)) [sp, unit] = [/'/, [1, 128]];
      else if (/:/.test(source)) [sp, unit] = [/:/, [1, fr * 6, fr * 6]];
      else if (/`/.test(source)) [sp, unit] = [/`/, [64, 64]];
      else [sp, unit] = [/:/, [1]];
      const cleaned = source.replace(new RegExp('[+\\s_' + escapeRe(this.comma) + ']', 'g'), '');
      const m = /^(-)?(.+)/s.exec(cleaned);
      if (!m) return null;
      if (m[1] === '-') power = -power;
      power *= unit[0];
      const parts = splitLimit(m[2], sp, unit.length).reverse();
      let sum = [0, 0];
      const pointRe = new RegExp('[;@' + escapeRe(this.period) + ']');
      for (const part of parts) {
        if (part === undefined) { sum = [sum[0] / unit.shift(), sum[1]]; continue; }
        let quantity = part.replace(new RegExp(pointRe.source, 'g'), '').toUpperCase();
        if (radix === 12) quantity = quantity.replace(/X/g, 'A').replace(/E/g, 'B');
        let f;
        const removed = part.length - quantity.length;
        if (removed === 0) f = 0;
        else if (removed === 1) f = part.length - part.search(pointRe) - 1;
        else return null;
        const value = rubyToI(quantity, radix);
        if (value === 0 && /[1-9A-Z]/i.test(quantity)) throw new EngineError('Irregal quantity');
        sum = [sum[0] / unit.shift() + power * value / pw(radix, f), sum[1] + quantity.length];
      }
      return sum;
    }

    // conv.rb #_convert: number -> text in radix tr, with as many digits as fl digits of radix fr carry
    format(quantity, tr, fr, fl, subunit, flag) {
      let tl = Math.ceil(Math.log(fr) / Math.log(tr) * fl);
      let ex, tq, te;
      if (Math.trunc(quantity) === quantity) {
        ex = ' (exact)';
        tq = intStr(quantity, tr);
        te = tq.length;
        if (tl > te) tl = te;
      } else {
        if (!isFinite(quantity) || isNaN(quantity)) throw new EngineError('FloatDomainError');
        ex = '';
        let t = Math.log(quantity) / Math.log(tr);
        if (isNaN(t)) throw new EngineError('FloatDomainError');
        te = Math.trunc(t) === t ? Math.trunc(t) + 1 : Math.ceil(t);
        const s = [0, 0.5].map((m) => intStr(quantity * pw(tr, tl - te) + m, tr));
        if (te === 0 && s[0].length !== s[1].length) te += 1;
        tq = s[1];
      }
      const pt = this.point(tr);
      if (te <= 0 || te > tl) {
        if (flag) return te <= 0 ? '0' : tq + '0'.repeat(te - tl);
        return tq.slice(0, 1) + pt + this.insertSpace(tq.slice(1, tl), tr) +
          ' &times; ' + tr + this.period + '^' + (te - 1).toString(tr).toUpperCase() + pt;
      }
      const intPart = tq.slice(0, te);
      quantity -= Number(parseBig(intPart, tr));
      let ts = this.insertComma(intPart, tr) + (
        quantity < 0 ? '' :
          subunit.length > 0 ?
            subunit[0][0] + this.format(quantity * subunit[0][1], tr, fr, fl - te, subunit.slice(1), true) :
            pt + this.insertSpace(tq.slice(te), tr));
      if (!/exact/.test(ts)) ts += ex;
      return ts;
    }
    insertComma(s, tr) {
      const n = GROUP[tr]; const out = [];
      for (let i = s.length; i > 0; i -= n) out.unshift(s.slice(Math.max(0, i - n), i));
      return out.join(this.comma);
    }
    insertSpace(s, tr) {
      const n = GROUP[tr]; const out = [];
      for (let i = 0; i < s.length; i += n) out.push(s.slice(i, i + n));
      return out.join('&nbsp;');
    }
    // conv.rb #convert: signed, with subunits when tm is on
    text(D, tu, fu, tr, fr, fl, tq, tm) {
      let ts = '';
      if (tq < 0) { tq = -tq; ts = '-'; }
      let subunit = [];
      if (tm) {
        subunit = (D.units[tu].subunit || []).slice();
        if (subunit[0] === 1 || this.pick(D.units[tu].factor) === this.pick(D.units[fu].factor)) tq /= (subunit.shift() || 1);
        else subunit = [];
      }
      ts += this.format(tq, tr, fr, fl, subunit, false);
      if (tr === 12 && this.xe) ts = ts.replace(/A/g, 'X').replace(/B/g, 'E');
      return ts;
    }

    // the SI value and digit count of a typed quantity: q = { d, fu, fq, fe, fr, fp, fl }
    fromQuantity(q) {
      const D = this.dim(q.d);
      const u = D.units[q.fu];
      if (!u) throw new EngineError('no such unit');
      const fr = q.fr || this.defaultRadix(u);
      // as conv.cgi: no quantity means 1 with the default precision, and a bare "0" gets that precision too
      let fq = q.fq === undefined || q.fq === null ? '1' + this.period + '0'.repeat(this.precision) : String(q.fq);
      if (fq === '0') fq = '0' + this.period + '0'.repeat(this.precision);
      // fe (the exponent) is typed in radix fr, as conv.cgi reads it ("-5" in radix 2 is 0)
      let fe = q.fe || 0;
      if (typeof fe === 'string') {
        let t = fe; if (fr === 12) t = t.replace(/X/g, 'A').replace(/E/g, 'B');
        const m = /^\s*([-+]?)(.*)$/s.exec(t);
        fe = rubyToI(m[2].toUpperCase(), fr) * (m[1] === '-' ? -1 : 1);
      }
      const r = this.readQuantity(fq, fr, pw(fr, fe), fr);
      if (!r) throw new EngineError("Irregal quantity: '" + fq + "'");
      return { si: this.unitReverse(u, q.fp || 0, q.fl || 0, fr, r[0]), digits: r[1], fr };
    }

    // conv.cgi's "Convert": q = { d, fu, fq, fe, fr, fp, fl, tu, tr, tp, tl, tm }; tu = -1 lists every unit.
    // Returns [{ n, text, name, unit }] (the table) or one text.
    convert(q) {
      const D = this.dim(q.d);
      const { si, digits, fr } = this.fromQuantity(q);
      const tl = q.tl || 0;
      if (q.tu !== undefined && q.tu !== -1) {
        const u = D.units[q.tu];
        if (!u) throw new EngineError('no such unit');
        const tr = q.tr || this.defaultRadix(u);
        return this.text(D, q.tu, q.fu, tr, fr, digits, this.unitConvert(u, q.tp || 0, tl, tr, si), q.tm);
      }
      const rows = D.units.map((u, i) => {
        const tr = this.defaultRadix(u);
        const tq = this.unitConvert(u, 0, tl, tr, si);
        return { tq, text: this.text(D, i, q.fu, tr, fr, digits, tq, q.tm), name: this.pick(u.name), unit: i };
      });
      if (rows.some((r) => isNaN(r.tq))) throw new EngineError("Irregal quantity: '" + q.fq + "'");
      rows.sort((a, b) => a.tq - b.tq);
      return rows.map((r, i) => ({ n: i + 1, text: r.text, name: r.name, unit: r.unit, value: r.tq }));
    }
  }

  // ------------------------------------------------------------------ helpers
  function escapeRe(s) { return s.replace(/[.*+?^${}()|[\]\\\-]/g, '\\$&'); }
  // String#split(regex, limit) as Ruby does it, for a separator regex without captures
  function splitLimit(s, re, limit) {
    const g = new RegExp(re.source, 'g'); const out = []; let last = 0, m;
    while (out.length < limit - 1 && (m = g.exec(s)) !== null) {
      out.push(s.slice(last, m.index)); last = m.index + m[0].length;
      if (m[0].length === 0) g.lastIndex++;
    }
    out.push(s.slice(last));
    if (limit === 1) return [s];
    return out;
  }
  // String#to_i(radix): the leading valid digits, 0 if none
  function rubyToI(s, radix) {
    const digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.slice(0, radix);
    let i = 0; while (i < s.length && digits.includes(s[i])) i++;
    if (i === 0) return 0;
    return Number(parseBig(s.slice(0, i), radix));
  }
  function parseBig(s, radix) {
    let v = 0n; const R = BigInt(radix);
    for (const c of s) v = v * R + BigInt(parseInt(c, 36));
    return v;
  }

  // ------------------------------------------------------------------ the URI-name interface
  //
  //   QUANTITY ::= [ VALUE OP ] UNITS          OP ::= "*" | "°" | "@"   ("@" = "°" in ASCII)
  //   UNITS    ::= TERM { SEP TERM }           SEP ::= " " | "."
  //   TERM     ::= [ SYSTEM "/" ] [ VARIANT "/" ] NAME [ "^" INTEGER ]
  //   SYSTEM   ::= SI | TGM | IDUS | TONAL | TRAD | CGS | CONST     (none: UUS)
  //   VARIANT  ::= harmonic | universal | GCD | gravitic  (UUS)  |  exact  (TGM)
//   NAME     ::= a name of the tables; harmon nic looloh (harmonic) and loolou (universal) also set the variant
  //   VALUE    ::= NUMBER [ ( "Z" | "E" | "^" ) EXPONENT ]  -- read as conv.cgi reads it, in the radix of
  //                the unit's system (UUS, TGM, IDUS duodecimal with ";" or "." and X E or A B; TONAL
  //                hexadecimal; the others decimal). "Z" (any radix) and "^" give a power of that radix,
  //                the exponent written in it; "E" or "e" (radix 10 and below only, where E is no digit)
  //                a power of ten.
  //                The number of digits typed sets the precision of the answer; no VALUE means 1 with
  //                the default precision.
  //   "*" (or no VALUE) multiplies the unit; "°" reads VALUE on a scale: a temperature on the scale of
  //   "°X", or a logarithmic level (magnitude, dB) whose reference is X.
  //
  // query(quantity, target, options) -> { query, results } or throws ConvError { code, status, position,
  // message, hint }. Without a target, results lists every unit of the dimension (as conv.cgi's "All").
  class ConvError extends Error {
    constructor(code, status, message, position, hint) {
      super(message); this.code = code; this.status = status;
      if (position !== undefined && position !== null) this.position = position;
      if (hint) this.hint = hint;
    }
    toJSON() {
      const o = { code: this.code, message: this.message };
      if (this.position !== undefined) o.position = this.position;
      if (this.hint) o.hint = this.hint;
      return o;
    }
  }
  const SYSTEMS = ['SI', 'TGM', 'IDUS', 'TONAL', 'TRAD', 'CGS', 'CONST'];
  const UUS_VARIANTS = ['harmonic', 'universal', 'GCD'];
  const RADIX_OF = { UUS: 12, TGM: 12, IDUS: 12, TONAL: 16 };   // others 10

  // HTML of conv.rb names and engine texts -> plain text
  function plain(s) {
    return String(s).replace(/<[^>]*>/g, '').replace(/&nbsp;/g, ' ').replace(/&times;/g, '×')
      .replace(/&#8725;/g, '∕').replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)))
      .replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
  }

  class Converter {
    constructor(units, opts = {}) {
      if (!units || !units.names) throw new Error('units.json without "names": generate it with the name tables');
      this.units = units; this.opts = opts;
      this.engines = {};
      // names of one variant (harmon nic looloh loolou): label -> name, by variant
      this.vnames = { harmonic: {}, universal: {}, GCD: {} };
      for (const [n, info] of Object.entries(units.names)) if (info.variant) this.vnames[info.variant][info.label] = n;
      // expression (normalized) -> rows written that way
      this.rows = new Map();
      units.dimensions.forEach((D, d) => {
        if (D.calendar) return;
        D.units.forEach((u, i) => {
          if (!u.expression) return;
          u.expression.split(/\s*=\s*/).forEach((part) => {
            const scale = part.startsWith('°');
            const key = this.normalize(this.terms(part.replace(/^°/, ''), 0, true)).key;
            if (!this.rows.has(key)) this.rows.set(key, []);
            this.rows.get(key).push({ d, u: i, scale });
          });
        });
      });
    }
    engine(variant, tgm) {
      const k = variant + '/' + tgm;
      return this.engines[k] || (this.engines[k] = new Engine(this.units, Object.assign({}, this.opts, { variant, tgm })));
    }

    // UNITS -> [{ text, at, system, variant, name, label, power, info }]
    terms(s, offset, trusted) {
      const out = [];
      const re = /[^\s.]+/g; let m;
      if (!trusted) {
        const bad = /[^A-Za-z0-9/^\-\s.]/.exec(s);
        if (bad) throw new ConvError('syntax', 400, `unexpected character "${bad[0]}"`, offset + bad.index);
      }
      while ((m = re.exec(s)) !== null) {
        const text = m[0], at = offset + m.index;
        const tm = /^((?:[A-Za-z][A-Za-z0-9]*\/){0,2})([A-Za-z0-9]+)(?:\^(-?\d+))?$/.exec(text);
        if (!tm) throw new ConvError('syntax', 400, `cannot read "${text}" as a unit (NAME, SYSTEM/NAME, NAME^n)`, at);
        const path = tm[1] ? tm[1].slice(0, -1).split('/') : [];
        let system = 'UUS', variant = '';
        let p = 0;
        if (path[p] && SYSTEMS.includes(path[p])) system = path[p++];
        else if (path[p] && SYSTEMS.includes(path[p].toUpperCase()) && !trusted) {
          throw new ConvError('unknown_system', 404, `no system "${path[p]}"`, at, `systems are written in capitals: ${path[p].toUpperCase()}`);
        }
        if (p < path.length) {
          const v = path[p];
          const ok = system === 'UUS' ? UUS_VARIANTS.concat(['gravitic']).includes(v) : system === 'TGM' && v === 'exact';
          if (!ok) {
            if (p === 0 && !trusted) throw new ConvError('unknown_system', 404, `no system or variant "${v}"`, at,
              system === 'UUS' ? `systems: ${SYSTEMS.join(' ')}; UUS variants: ${UUS_VARIANTS.join(' ')} gravitic` : undefined);
            throw new ConvError('bad_variant', 400, `"${v}" is not a variant of ${system}`, at,
              system === 'UUS' ? `UUS variants: ${UUS_VARIANTS.join(' ')} gravitic` : system === 'TGM' ? 'TGM variant: exact' : `${system} has no variants`);
          }
          variant = v; p++;
        }
        if (p < path.length) throw new ConvError('syntax', 400, `too many "/" in "${text}"`, at);
        const name = tm[2];
        const power = tm[3] === undefined ? 1 : Number(tm[3]);
        if (tm[3] !== undefined && (power === 0 || Math.abs(power) > 12)) throw new ConvError('syntax', 400, `power ${tm[3]} out of range`, at);
        const key = system === 'UUS' ? (variant === 'gravitic' ? 'gravitic/' + name : name) : system + '/' + name;
        const info = this.units.names[key];
        if (!info) {
          if (trusted) throw new Error('units.json: unknown name ' + key);
          throw new ConvError('unknown_name', 404, `no unit "${key}"`, at, this.suggest(key));
        }
        if (info.variant) {                      // harmon, nic, looloh, loolou: a name of one variant
          if (variant && variant !== info.variant) {
            throw new ConvError('bad_variant', 400, `"${name}" is the ${info.variant} ${info.label}`, at, `write ${name} or ${variant}/${info.label}`);
          }
          variant = info.variant;
        }
        out.push({ text, at, system, variant, name, label: info.label, power, info });
      }
      if (out.length === 0) throw new ConvError('syntax', 400, 'no unit given', offset);
      return out;
    }
    // a hint only when it is certain: the same name in other capitals, or the name in another system
    suggest(key) {
      const names = this.units.names;
      const lower = key.toLowerCase();
      const same = Object.keys(names).filter((k) => k.toLowerCase() === lower);
      if (same.length === 1) return `did you mean "${same[0]}"?`;
      const bare = key.replace(/^.*\//, '');
      const elsewhere = Object.keys(names).filter((k) => k.replace(/^.*\//, '') === bare && !k.startsWith('gravitic/'));
      if (elsewhere.length > 0 && elsewhere.length <= 4) return `"${bare}" exists as ${elsewhere.map((k) => '"' + k + '"').join(', ')}`;
      return undefined;
    }
    // an expression as the answer writes it in a UUS variant ('' = harmonic): the names of that variant
    // where it has its own (harmon nic looloh; loolou), otherwise VARIANT/name for universal and GCD
    // on the units whose value depends on the variant
    render(expr, v) {
      const own = this.vnames[v || 'harmonic'];
      return expr.split(' ').map((t) => {
        const m = /^(°?)([^\s^=]+)(\^-?\d+)?$/.exec(t);
        const info = m && this.units.names[m[2]];
        if (!info || info.system !== 'UUS' || m[2].includes('/') || info.variant) return t;
        if (own[m[2]]) return m[1] + own[m[2]] + (m[3] || '');
        // a unit with the same value in every variant (light, Coulomb, mole, ...) needs no variant
        return v && info.value !== null && typeof info.value === 'object' ? m[1] + v + '/' + m[2] + (m[3] || '') : t;
      }).join(' ');
    }
    normalize(terms) {
      const pow = new Map();
      for (const t of terms) pow.set(t.label, (pow.get(t.label) || 0) + t.power);
      const parts = [...pow].filter(([, p]) => p !== 0).sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
      return { key: parts.map(([l, p]) => (p === 1 ? l : l + '^' + p)).join(' '), parts };
    }
    variantOf(terms) {
      let uus = '', tgm = '', at = null;
      for (const t of terms) {
        if (t.system === 'UUS' && UUS_VARIANTS.includes(t.variant)) {
          const v = t.variant === 'harmonic' ? '' : t.variant;
          if (at !== null && uus !== v) throw new ConvError('variant_conflict', 400, 'two UUS variants in one query', t.at);
          uus = v; at = t.at;
        }
        if (t.system === 'TGM' && t.variant === 'exact') tgm = 'exact';
      }
      return { uus, tgm };
    }

    // split "VALUE OP UNITS"
    parseQuantity(s) {
      const m = /[*°@]/.exec(s);
      if (!m) return { value: null, op: '*', units: s, unitsAt: 0 };
      if (/[*°@]/.test(s.slice(m.index + 1))) throw new ConvError('syntax', 400, `a second "${s.slice(m.index + 1).match(/[*°@]/)[0]}"`, m.index + 1 + s.slice(m.index + 1).search(/[*°@]/));
      const value = s.slice(0, m.index).trim();
      if (value === '') throw new ConvError('syntax', 400, `no value before "${m[0]}"`, m.index);
      return { value, valueAt: s.indexOf(value), op: m[0] === '*' ? '*' : '°', units: s.slice(m.index + 1), unitsAt: m.index + 1 };
    }

    // VALUE -> { fq, fe } for the engine, checked character by character in the radix
    readValue(v, at, radix) {
      let num = v, fe = '0', feAt = null;
      // exponent: "Z" in every radix (a power of that radix, written in it); "E" (or "e") where E is not
      // a digit (radix 10 and below), a power of ten; "^" as conv.cgi's exponent field
      const z = v.indexOf('Z');
      const caret = v.indexOf('^');
      const e = radix <= 10 ? v.search(/[Ee]/) : -1;
      const cut = [z, caret, e].filter((i) => i > 0);
      if (cut.length > 1) throw new ConvError('bad_value', 400, 'two exponents in the value', at + Math.max(...cut));
      if (cut.length === 1) { const i = cut[0]; num = v.slice(0, i); fe = v.slice(i + 1); feAt = at + i + 1; }
      else if (z === 0 || caret === 0 || e === 0) throw new ConvError('bad_value', 400, 'no digits before the exponent', at);
      const digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.slice(0, radix) + (radix === 12 ? 'XE' : '');
      const sub = /[:'`T]/.test(num);                     // conv.cgi's subunit notations (h:m:s, ' and `)
      let points = 0;
      for (let i = 0; i < num.length; i++) {
        const c = num[i].toUpperCase();
        if (i === 0 && (c === '-' || c === '+')) continue;
        if (c === ';' || c === '.') { points++; if (points > 1 && !sub) throw new ConvError('bad_value', 400, 'two points in the value', at + i); continue; }
        if (sub && /[:'`T_]/.test(c)) continue;
        if (c === '_') continue;
        if (!digits.includes(c)) throw new ConvError('bad_value', 400, `"${num[i]}" is not a digit in radix ${radix}`, at + i,
          radix === 12 && /[AB]/.test(c) === false && /[0-9]/.test(c) === false ? 'duodecimal digits: 0-9 X E (or A B)' : undefined);
      }
      if (!/[0-9A-Za-z]/.test(num)) throw new ConvError('bad_value', 400, 'no digits in the value', at);
      if (feAt !== null) {
        const m = /^[-+]?/.exec(fe)[0].length;
        if (m === fe.length) throw new ConvError('bad_value', 400, 'no digits in the exponent', feAt + m);
        for (let i = m; i < fe.length; i++) if (!digits.includes(fe[i].toUpperCase())) {
          throw new ConvError('bad_value', 400, `"${fe[i]}" is not a digit of the exponent in radix ${radix}`, feAt + i);
        }
        if (radix === 12) fe = fe.replace(/X/gi, 'A').replace(/E/gi, 'B');
      }
      return { fq: num, fe };
    }

    // find the rows written as these terms; ° chooses the scale rows
    match(terms, scale, at) {
      const { key } = this.normalize(terms);
      const rows = (this.rows.get(key) || []).filter((r) => r.scale === scale);
      if (rows.length === 0) {
        const other = (this.rows.get(key) || []).filter((r) => r.scale !== scale);
        if (other.length) {
          throw new ConvError('not_written', 422, scale ? `"${key}" is not a scale: no "°" here` : `"${key}" is a point on a scale: write it as °${key}`, at,
            scale ? undefined : `e.g. 0°${key}`);
        }
        throw new ConvError('not_written', 422, `no conv.rb unit is written "${key}"`, at,
          terms.length > 1 ? 'combinations are the ones conv.rb lists; see the dimension in question for the forms it has' : undefined);
      }
      return { key, rows };
    }

    query(quantity, target, options = {}) {
      if (typeof quantity !== 'string' || quantity.trim() === '') throw new ConvError('empty', 400, 'no quantity given', 0);
      if (quantity.length > 512) throw new ConvError('syntax', 400, 'the quantity is too long', 512);
      const Q = this.parseQuantity(quantity);
      const qt = this.terms(Q.units, Q.unitsAt);
      const qm = this.match(qt, Q.op === '°', Q.unitsAt);
      const vr = this.variantOf(qt);
      let tt = null, tScale = false, tm = null, tvr = null;
      if (target !== undefined && target !== null && String(target).trim() !== '') {
        let t = String(target);
        if (t.length > 512) throw new ConvError('syntax', 400, 'the target is too long', 512, undefined);
        let tAt = 0;
        if (/^[°@]/.test(t.trim())) { tScale = true; tAt = t.search(/[°@]/) + 1; t = t.slice(tAt); }
        if (/[*°@]/.test(t)) throw new ConvError('syntax', 400, 'a target is units only', tAt + t.search(/[*°@]/));
        tt = this.terms(t, tAt);
        // the target may name another variant: 1 looloh in loolou is the harmonic gram in universal grams
        tvr = this.variantOf(tt);
        const named = (ts) => ts.some((x) => UUS_VARIANTS.includes(x.variant));
        if (!named(qt)) vr.uus = tvr.uus;
        if (!named(tt)) tvr.uus = vr.uus;
        if (!qt.some((x) => x.variant === 'exact')) vr.tgm = vr.tgm || tvr.tgm;
        tvr.tgm = tvr.tgm || vr.tgm;
        tm = this.normalize(tt).key;
      }
      // the row of the quantity; with a target, a dimension the target belongs to as well
      let cands = qm.rows;
      // a quantity (no "°") may be answered as a level of a logarithmic dimension: a target with "°"
      const isLog = (d) => this.units.dimensions[d].scale && this.units.dimensions[d].title !== 'Thermodynamic temperature';
      if (tm !== null && tScale && Q.op !== '°') {
        const tRows = this.rows.get(tm) || [];
        const levels = (this.rows.get(qm.key) || []).filter((r) => r.scale && isLog(r.d) && tRows.some((x) => x.d === r.d && x.scale));
        if (levels.length) cands = levels;
      }
      if (tm !== null) {
        const tRows = this.rows.get(tm) || [];
        const both = cands.filter((r) => tRows.some((x) => x.d === r.d));
        if (both.length === 0) {
          if (tRows.length === 0) this.match(tt, tScale, 0);      // throws not_written for the target
          const dq = [...new Set(cands.map((r) => this.units.dimensions[r.d].title))].join(', ');
          const dt = [...new Set(tRows.map((r) => this.units.dimensions[r.d].title))].join(', ');
          throw new ConvError('incompatible', 422, `"${qm.key}" (${dq}) cannot be converted to "${tm}" (${dt})`, 0);
        }
        cands = both;
      }
      let dims = [...new Set(cands.map((r) => r.d))];
      // SI writes some units of two dimensions alike because it sets a constant to 1 in one of them
      // (Hz counts cycles, ...): without a target, the dimension without that implicit constant is meant
      // (with a target in both dimensions the answer is the same in either, as check_tables.rb verifies)
      const alsoIn = dims.length > 1 ? dims.slice() : [];
      if (dims.length > 1) {
        const plainDims = dims.filter((x) => !this.units.dimensions[x].implicit);
        if (plainDims.length === 1) dims = plainDims;
        else if (tm !== null) dims = [(plainDims.length ? plainDims : dims)[0]];
        cands = cands.filter((r) => r.d === dims[0] || dims.length > 1);
      }
      if (dims.length > 1) {
        throw new ConvError('ambiguous', 409, `"${qm.key}" is a unit of ${dims.map((d) => this.units.dimensions[d].title).join(' and ')}`,
          Q.unitsAt, 'give a target to say which');
      }
      const from = cands[0], d = from.d, D = this.units.dimensions[d];
      const eng = this.engine(vr.uus, vr.tgm);
      const fu = D.units[from.u];
      const fr = options.value ? options.value.fr : eng.defaultRadix(fu);
      const logType = D.defaults && D.defaults.fl ? D.defaults.fl : 0;
      const fl = Q.op === '°' && D.scale ? (options.fl !== undefined ? options.fl : (D.title === 'Thermodynamic temperature' ? 0 : logType)) : 0;
      let val = { fq: undefined, fe: '0' };
      if (options.value) val = { fq: options.value.fq, fe: options.value.fe };
      else if (Q.value !== null) val = this.readValue(Q.value, Q.valueAt, fr);
      const base = { d, fu: from.u, fq: val.fq, fe: val.fe, fr, fp: 0, fl, tm: !!options.subunits };
      let si, digits;
      try { ({ si, digits } = eng.fromQuantity(base)); } catch (e) {
        if (e instanceof EngineError) throw new ConvError('bad_value', 400, `cannot read the value "${Q.value}"`, Q.valueAt);
        throw e;
      }
      if (!isFinite(si)) throw new ConvError('out_of_range', 422, 'the value is out of range', Q.valueAt);
      const describe = (u, rowIndex, v) => {
        const expr = this.render(u.expression, v);
        const first = u.expression.split(/\s*=\s*/)[0];
        const r = { expression: expr, key: plain(eng.pick(u.name)) };
        const single = /^°?[^\s^]+$/.test(first) && this.units.names[first.replace(/^°/, '')];
        if (single && single.description) r.description = plain(single.description);
        r.row = rowIndex;
        return r;
      };
      // the units in the order conv.rb writes them (the row's own expression), not sorted
      const order = (u, key) => u.expression.split(/\s*=\s*/).map((x) => x.replace(/^°/, ''))
        .find((x) => this.normalize(this.terms(x, 0, true)).key === key) || key;
      let tExpr = null, tlUsed = 0;
      let results;
      try {
        if (tm !== null) {
          if (tScale && !D.scale) throw new ConvError('not_written', 422, `${D.title} has no scale: write the target without "°"`, 0);
          // a level (°) in a logarithmic dimension may be answered as the quantity itself: a target without "°"
          const logDim = isLog(d);
          const asQuantity = logDim && !tScale && Q.op === '°';
          const tRow = (this.rows.get(tm) || []).find((x) => x.d === d && (x.scale === tScale || !D.scale || asQuantity));
          if (tRow) tExpr = order(D.units[tRow.u], tm);
          if (!tRow) throw new ConvError('not_written', 422, tScale ? `"${tm}" is not a scale here` : `write the target as °${tm}`, 0);
          const tu = tRow.u, u = D.units[tu];
          const tr = eng.defaultRadix(u);
          const tl = tScale && logDim ? (options.tl !== undefined ? options.tl : logType) : 0;
          tlUsed = tl;
          const teng = this.engine(tvr.uus, tvr.tgm);
          const v = teng.unitConvert(u, 0, tl, tr, si);
          if (isNaN(v)) throw new ConvError('out_of_range', 422, 'no such level: the quantity is not positive', 0);
          const html = teng.text(D, tu, from.u, tr, fr, digits, v, !!options.subunits);
          results = [Object.assign(describe(u, tu, tvr.uus), { value: v, text: plain(html), html, radix: tr })];
        } else {
          const tl = Q.op === '°' && D.scale && D.title !== 'Thermodynamic temperature' ? (options.tl !== undefined ? options.tl : logType) : 0;
          tlUsed = tl;
          const table = eng.convert(Object.assign({}, base, { tu: -1, tl }));
          results = table.map((r) => Object.assign(describe(D.units[r.unit], r.unit, vr.uus), { value: r.value, text: plain(r.text), html: r.text, radix: eng.defaultRadix(D.units[r.unit]) }));
        }
      } catch (e) {
        if (e instanceof EngineError) throw new ConvError('out_of_range', 422, 'the quantity has no value in some unit (a level of a quantity that is not positive?)', 0);
        throw e;
      }
      const fromExpr = order(fu, qm.key);
      const canonical = (Q.value !== null ? Q.value + (Q.op === '°' ? '°' : '*') : (Q.op === '°' ? '°' : '')) + this.render(fromExpr, vr.uus);
      return {
        query: {
          input: quantity, target: tm !== null ? (tScale ? '°' : '') + this.render(tExpr || tm, tvr.uus) : null, canonical,
          value: Q.value, operator: Q.op, units: fromExpr,
          terms: qt.map((t) => ({ name: t.label, system: t.system, power: t.power, description: plain(t.info.description || '') })),
          dimension: { index: d, title: D.title }, row: from.u,
          // what the engine was given: the typed value (fe: a power of fr) and the logarithmic types
          read: { fq: val.fq === undefined ? null : val.fq, fe: val.fe, fr, fl, tl: tlUsed },
          also: alsoIn.filter((x) => x !== d).map((x) => this.units.dimensions[x].title), key: plain(eng.pick(fu.name)),
          variant: { UUS: vr.uus || 'harmonic', TGM: vr.tgm || '' },
          targetVariant: tvr ? { UUS: tvr.uus || 'harmonic', TGM: tvr.tgm || '' } : null, radix: fr, digits, si,
        },
        results,
      };
    }
  }

  // ------------------------------------------------------------------ the UUS API (URI form)
  //
  // UUS API draft of 2026-06-28, as revised since:
  //   REQUEST    ::= ( UNITS | CONVERSION ) [ "." TYPE ]            TYPE ::= json | html
  //   CONVERSION ::= QUANTITY "/" ( QUANTITY | "*" )                 "*": every unit of the dimension
  //   QUANTITY   ::= [ VALUE ( "*" | "°" | "@" ) ] UNITS
  //   UNITS      ::= UNIT [ POWER ] { UNIT [ POWER ] }                 harmon1nic-1, harmon2nic-1
  //   POWER      ::= [ "-" ] NUMBER [ "p2" ]                           p2: halves
  //   UNIT       ::= NAME { "_" ( NAMESPACE | VARIANT ) }              meter_SI, meter_universal
  //   NAME       ::= a name of the tables; a run of digits in it is written after "_" (Omega_1, log_2)
  //   NAMESPACE  ::= SI | TGM | IDUS | TONAL | TRAD | CGS | CONST     VARIANT ::= harmonic | universal | GCD | gravitic | exact
  //   VALUE      ::= NUMBER12 ( "E" | "Z" ) [ "-" | "+" ] NUMBER      E: decimal, Z: duodecimal, then a decimal power
  //   NUMBER12   ::= [ "-" ] [0-9xeXE]+ [ ( "." | ";" ) [0-9xeXE]+ ]     (decimal digits only before E)
  // "NAMESPACE/" and "VARIANT/" before a name are first rewritten as "_NAMESPACE" and "_VARIANT" after it.
  // Units may follow each other without a power (harmonnic-1) when only one reading is possible.
  // A VALUE without E or Z is read in the radix of the unit's system (an extension).
  //   UNITS alone: one unit -> its description; several -> converted to the SI unit of the dimension
  //   QUANTITY alone (with a VALUE): converted to the SI unit of the dimension
  const NAMESPACES = ['SI', 'TGM', 'IDUS', 'TONAL', 'TRAD', 'CGS', 'CONST'];
  const VARIANTS = ['harmonic', 'universal', 'GCD', 'gravitic', 'exact'];
  const uriName = (n) => n.replace(/(\D)(\d+)/g, '$1_$2');     // log2 -> log_2, Omega1 -> Omega_1

  Converter.prototype.uriIndex = function () {
    if (this._uri) return this._uri;
    const list = [];                                            // { spell, system, name }
    for (const [k, info] of Object.entries(this.units.names)) {
      if (k.startsWith('gravitic/')) continue;
      const [system, name] = k.includes('/') ? k.split('/') : ['UUS', k];
      if (/^\d/.test(name)) continue;                           // CONST/1 has no URI spelling
      list.push({ spell: uriName(name), system, name });
    }
    list.sort((a, b) => b.spell.length - a.spell.length);
    return (this._uri = list);
  };

  // UNITS in URI form -> the core's form ("SYS/VARIANT/name^p ..."); positions refer to the string given
  Converter.prototype.uriUnits = function (s, at, map) {
    const pos = (i) => (map ? map[Math.min(i, map.length - 1)] : i) + at;
    const list = this.uriIndex();
    const memo = new Map(); let far = 0;
    // all readings from position i: arrays of terms
    const go = (i) => {
      if (i === s.length) return [[]];
      if (memo.has(i)) return memo.get(i);
      far = Math.max(far, i);
      const out = [];
      for (const n of list) {
        if (!s.startsWith(n.spell, i)) continue;
        let j = i + n.spell.length;
        // suffixes
        let sys = 'UUS', variant = '';
        const sm = /^((?:_[A-Za-z]+)*)/.exec(s.slice(j))[1];
        const suf = sm ? sm.slice(1).split('_') : [];
        let ok = true, used = 0;
        for (const x of suf) {
          if (NAMESPACES.includes(x) && sys === 'UUS' && !variant) { sys = x; used++; }
          else if (VARIANTS.includes(x) && !variant) { variant = x; used++; }
          else break;
        }
        const sufLen = suf.slice(0, used).reduce((a, x) => a + 1 + x.length, 0);
        if (sys !== n.system) ok = false;
        if (!ok) continue;
        j += sufLen;
        let power = 1;
        const pm = /^(-?)(\d+)(p2)?/.exec(s.slice(j));
        if (pm) {
          power = Number(pm[2]) * (pm[1] === '-' ? -1 : 1) / (pm[3] ? 2 : 1);
          j += pm[0].length;
        }
        if (power === 0) continue;
        if (!Number.isInteger(power)) {
          throw new ConvError('not_written', 422, `no conv.rb unit has the power ${power}`, pos(j - pm[0].length));
        }
        const term = (sys === 'UUS' ? '' : sys + '/') + (variant ? variant + '/' : '') + n.name + (power === 1 ? '' : '^' + power);
        for (const rest of go(j)) { out.push([{ term, at: pos(i) }].concat(rest)); if (out.length > 8) break; }
        if (out.length > 8) break;
      }
      memo.set(i, out);
      return out;
    };
    const all = go(0);
    if (all.length === 0) {
      const hint = /^[a-z]/i.test(s.slice(far)) ? this.suggestUri(s.slice(far)) : undefined;
      throw new ConvError(far === 0 ? 'unknown_name' : 'syntax', far === 0 ? 404 : 400,
        `cannot read a unit at "${s.slice(far, far + 24)}"`, pos(far), hint);
    }
    const fewest = Math.min(...all.map((r) => r.length));
    const best = all.filter((r) => r.length === fewest);
    const keys = [...new Set(best.map((r) => r.map((t) => t.term).join(' ')))];
    if (keys.length > 1) throw new ConvError('ambiguous', 409, `"${s}" can be read as ${keys.map((k) => '"' + k + '"').join(' or ')}`, at,
      'write the power (1) after each unit, e.g. harmon1nic-1');
    return keys[0];
  };
  Converter.prototype.suggestUri = function (rest) {
    const word = /^[A-Za-z]+/.exec(rest)[0];
    const hit = this.uriIndex().filter((n) => n.spell.toLowerCase() === word.toLowerCase());
    if (hit.length === 1) return `did you mean "${hit[0].spell}${hit[0].system === 'UUS' ? '' : '_' + hit[0].system}"?`;
    const other = this.uriIndex().filter((n) => n.spell === word && n.system !== 'UUS');
    if (other.length && other.length <= 4) return `"${word}" is ${other.map((n) => n.spell + '_' + n.system).join(', ')}`;
    return undefined;
  };

  // VALUE in URI form -> { fq, fr, fe } for the engine, or null when there is no E or Z
  Converter.prototype.uriValue = function (v, at) {
    const m = /^([-+]?[0-9A-Za-z.;]+?)([EZ])([-+]?\d+)$/.exec(v);
    if (!m) {
      if (/[EZ][-+]?$/.test(v)) throw new ConvError('bad_value', 400, 'the power after E or Z is missing', at + v.length);
      return null;
    }
    const fr = m[2] === 'E' ? 10 : 12;
    const digits = fr === 10 ? '0123456789' : '0123456789XEABxeab';
    let points = 0;
    for (let i = 0; i < m[1].length; i++) {
      const c = m[1][i];
      if (i === 0 && /[-+]/.test(c)) continue;
      if (c === '.' || c === ';') { if (++points > 1) throw new ConvError('bad_value', 400, 'two points in the value', at + i); continue; }
      if (!digits.includes(c)) throw new ConvError('bad_value', 400, `"${c}" is not a ${fr === 10 ? 'decimal' : 'duodecimal'} digit`, at + i,
        fr === 10 && /[xe]/i.test(c) ? 'a duodecimal value ends in Z: 1.6Z0' : undefined);
    }
    if (!/[0-9A-Za-z]/.test(m[1])) throw new ConvError('bad_value', 400, 'no digits in the value', at);
    const fq = fr === 12 ? m[1].replace(/x/g, 'X').replace(/e/g, 'E').replace(/a/g, 'X').replace(/b/g, 'E').replace(/A/g, 'X').replace(/B/g, 'E') : m[1];
    const exp = Number(m[3]);
    if (Math.abs(exp) > 400) throw new ConvError('out_of_range', 422, 'the power is out of range', at + m[1].length + 1);
    return { fq, fr, fe: exp };
  };

  // the SI unit of a dimension: the first row written in SI names only
  Converter.prototype.siTarget = function (d) {
    const D = this.units.dimensions[d];
    for (const u of D.units) {
      const p = u.expression.split(/\s*=\s*/).find((x) => x.replace(/^°/, '').split(' ').every((t) => t.startsWith('SI/')));
      if (p) return p;
    }
    return null;
  };

  // request(path) -> { type, kind: 'unit' | 'conversion', ... }
  Converter.prototype.request = function (path, options = {}) {
    let s = String(path);
    try { s = decodeURIComponent(s); } catch (e) { throw new ConvError('syntax', 400, 'broken %-encoding', 0); }
    s = s.replace(/^uus:/, '').replace(/^\/?(?:units|uus)(?:\/|$)/, '').replace(/^\//, '');
    if (s.length > 512) throw new ConvError('syntax', 400, 'the request is too long', 512);
    let type = 'json';
    const tm = /\.(json|html)$/.exec(s);
    if (tm) { type = tm[1]; s = s.slice(0, tm.index); }
    // a namespace ("", "SI/", "universal/", "TGM/exact/"): the list of its units
    const ns = this.namespaceRequest(s);
    if (ns) return Object.assign({ type, kind: 'namespace' }, ns);
    // NAMESPACE/ and VARIANT/ -> suffixes, keeping a map back to the positions of s
    const out = []; const map = [];
    const re = new RegExp('^((?:(?:' + NAMESPACES.concat(VARIANTS).join('|') + ')/)+)([A-Za-z][A-Za-z0-9_]*)');
    for (let i = 0; i < s.length;) {
      const prev = i === 0 ? '' : s[i - 1];
      const m = /[A-Za-z_]/.test(prev) ? null : re.exec(s.slice(i));     // after a power digit a new unit begins
      if (m) {
        const pre = m[1].slice(0, -1).split('/');
        const sys = pre.filter((x) => NAMESPACES.includes(x)), vs = pre.filter((x) => VARIANTS.includes(x));
        const name = /^[A-Za-z]+(?:_\d+[A-Za-z]*)*/.exec(m[2])[0];
        const txt = name + sys.concat(vs).map((x) => '_' + x).join('');
        for (let k = 0; k < txt.length; k++) { out.push(txt[k]); map.push(i + m[1].length + Math.min(k, name.length - 1)); }
        i += m[1].length + name.length;
        continue;
      }
      out.push(s[i]); map.push(i); i++;
    }
    const t = out.join('');
    const parts = t.split('/');
    if (parts.length > 2) throw new ConvError('syntax', 400, 'more than one "/" outside SYSTEM/NAME', map[t.indexOf('/', t.indexOf('/') + 1)]);
    const [q, target] = parts;
    const qAt = 0, tAt = parts.length > 1 ? q.length + 1 : 0;
    const sub = (a, b) => map.slice(a, b);
    // the quantity
    const om = /[*°@]/.exec(q);
    let value = null, op = '*', unitsStr = q, unitsAt = 0;
    if (om) {
      if (/[*°@]/.test(q.slice(om.index + 1))) throw new ConvError('syntax', 400, 'a second operator', map[om.index + 1 + q.slice(om.index + 1).search(/[*°@]/)]);
      value = q.slice(0, om.index); op = om[0] === '*' ? '*' : '°'; unitsStr = q.slice(om.index + 1); unitsAt = om.index + 1;
      if (value === '') throw new ConvError('syntax', 400, `no value before "${om[0]}"`, map[om.index]);
    }
    if (unitsStr === '') throw new ConvError('syntax', 400, 'no unit given', map[Math.min(unitsAt, map.length - 1)] || 0);
    const units = this.uriUnits(unitsStr, 0, sub(unitsAt, q.length));
    // UNITS alone, one unit: its description
    if (value === null && op === '*' && target === undefined && !/\s/.test(units) && !/\^/.test(units)) {
      return Object.assign({ type, kind: 'unit' }, this.describeUnit(units));
    }
    let v = null;
    if (value !== null) v = this.uriValue(value, map[0]);
    let targetUnits = null;
    if (target !== undefined && target !== '*') {
      if (target === '') throw new ConvError('syntax', 400, 'nothing after "/"', map[tAt - 1]);
      let tt = target, tOff = tAt, deg = '';
      if (/^[°@]/.test(tt)) { deg = '°'; tt = tt.slice(1); tOff++; }
      if (/[*°@]/.test(tt)) throw new ConvError('syntax', 400, 'a target is units only (or "*")', map[tOff + tt.search(/[*°@]/)]);
      targetUnits = deg + this.uriUnits(tt, 0, sub(tOff, tOff + tt.length));
    }
    const core = (value !== null ? (v ? '1' : value) + (op === '°' ? '°' : '*') : (op === '°' ? '°' : '')) + units;
    const opts = Object.assign({}, options);
    if (v) opts.value = v;
    if (targetUnits === null && target === undefined) {
      // no "/": to the SI unit of the dimension
      const probe = this.query(core, null, Object.assign({}, opts, { probe: true }));
      const si = this.siTarget(probe.query.dimension.index);
      if (si) targetUnits = si;
    }
    const r = this.query(core, targetUnits, opts);
    r.query.input = String(path);
    if (value !== null) r.query.value = value;
    const uri = this.toUri(r);
    r.query.canonical = uri;
    return Object.assign({ type, kind: 'conversion' }, r, { uri });
  };

  // NAMESPACE_INDEX ::= [ NAMESPACE "/" ] [ VARIANT "/" ]: "" is the UUS (harmonic) with the other namespaces;
  // the variants are those of the UUS (harmonic universal GCD gravitic) and of TGM (exact). The "/" at the end
  // may be left out. Anything else is not a namespace (null).
  Converter.prototype.namespaceRequest = function (s) {
    const parts = s.split('/').filter((x) => x !== '');
    if (s !== '' && !/^[A-Za-z]+(\/[A-Za-z]+)?\/?$/.test(s)) return null;
    if (!parts.every((x) => NAMESPACES.includes(x) || VARIANTS.includes(x))) return null;
    let sys = 'UUS', variant = null;
    parts.forEach((x, i) => {
      if (NAMESPACES.includes(x)) {
        if (i > 0) throw new ConvError('syntax', 400, `the namespace comes first: ${x}/`, 0);
        sys = x;
      } else {
        if (variant) throw new ConvError('syntax', 400, 'two variants', 0);
        variant = x;
      }
    });
    if (variant === 'exact' && sys !== 'TGM') throw new ConvError('bad_variant', 400, 'exact is a variant of TGM: TGM/exact/', 0);
    if (variant && variant !== 'exact' && sys !== 'UUS') throw new ConvError('bad_variant', 400, `${sys} has no variant ${variant}`, 0);
    const out = this.namespaceIndex(sys, variant);
    if (parts.length === 0) out.namespace.namespaces = this.namespaceList();
    return out;
  };
  // the dimensions each name of the tables is a unit of (as a whole row expression)
  Converter.prototype.dimensionsOf = function (label) {
    if (!this._dims) {
      this._dims = new Map();
      this.units.dimensions.forEach((D) => {
        if (D.calendar) return;
        D.units.forEach((u) => u.expression.split(/\s*=\s*/).forEach((p) => {
          const k = p.replace(/^°/, '');
          if (/\s|\^/.test(k)) return;
          const a = this._dims.get(k) || []; if (!a.includes(D.title)) a.push(D.title); this._dims.set(k, a);
        }));
      });
    }
    return this._dims.get(label) || [];
  };
  Converter.prototype.namespaceIndex = function (sys, variant) {
    const w = sys === 'UUS' ? (variant || 'harmonic') : variant;
    const v = w === 'harmonic' || w === 'gravitic' ? '' : w;
    const units = []; const seen = new Set();
    const at = (n) => n.row || [1e9, 0];                      // in conv.rb's order, by the first row of each name
    const entries = Object.entries(this.units.names).filter(([k, n]) => n.system === sys)
      .sort((a, b) => at(a[1])[0] - at(b[1])[0] || at(a[1])[1] - at(b[1])[1]);
    for (const [k, n] of entries) {
      if (sys === 'UUS') {
        const grav = k.startsWith('gravitic/');
        if ((w === 'gravitic') !== grav) continue;
        if (!grav && (n.variant ? n.variant !== w : n.variants && n.variants.length && !n.variants.includes(w))) continue;
      }
      const varies = n.value !== null && typeof n.value === 'object';
      let uri = this.uriExpr(sys === 'UUS' && !k.startsWith('gravitic/') ? this.render(k, v) : k);
      if (w === 'exact' && varies) uri = uri.replace(/_TGM(?!_)/g, '_TGM_exact');
      if (seen.has(uri)) {                                       // another name of the same unit (dour = solarUnitia)
        const own = uriName(k.replace(/^.*\//, '')) + (sys === 'UUS' ? '' : '_' + sys);
        const e = units.find((x) => x.uri === uri);
        if (own !== uri && !own.startsWith(uri + '_') && !(e.aliases || []).includes(own)) (e.aliases = e.aliases || []).push(own);
        continue;
      }
      seen.add(uri);
      let si = n.value;
      if (varies) si = n.value[w === 'exact' ? 'exact' : v || ''];
      units.push({ uri, label: n.label, description: plain(n.description || ''), dimensions: this.dimensionsOf(n.label), si: si === undefined ? null : si });
    }
    const uri = (sys === 'UUS' ? '' : sys + '/') + (variant ? variant + '/' : '');
    return { namespace: { uri, system: sys, variant: variant || (sys === 'UUS' ? 'harmonic' : null), count: units.length, units } };
  };
  Converter.prototype.namespaceList = function () {
    const one = (sys, variant) => {
      const r = this.namespaceIndex(sys, variant).namespace;
      return { uri: r.uri, system: sys, variant: variant || null, count: r.count };
    };
    return ['harmonic', 'universal', 'GCD', 'gravitic'].map((x) => one('UUS', x))
      .concat(NAMESPACES.map((x) => one(x, null)), [one('TGM', 'exact')]);
  };

  // URI spelling of an expression of the tables: "SI/meter SI/second^-1" -> "meter_SI1second_SI-1"
  Converter.prototype.uriExpr = function (expr) {
    const ts = expr.split(' ').filter((x) => x);
    return ts.map((t, i) => {
      const m = /^(°?)(?:([A-Z]+)\/)?(?:(harmonic|universal|GCD|gravitic|exact)\/)?([^\s^]+)(?:\^(-?\d+))?$/.exec(t);
      if (!m) return t;
      const p = m[5] !== undefined ? m[5] : (i < ts.length - 1 ? '1' : '');
      // the label of the unit (CONST/1 is written by its label CONST/one)
      const info = this.units.names[(m[2] ? m[2] + '/' : '') + (m[3] === 'gravitic' ? 'gravitic/' : '') + m[4]];
      const name = info && !info.variant ? info.label.replace(/^.*\//, '') : m[4];
      return m[1] + uriName(name) + (m[2] ? '_' + m[2] : '') + (m[3] ? '_' + m[3] : '') + p;
    }).join('');
  };
  Converter.prototype.toUri = function (r) {
    const q = r.query;
    const v = q.variant.UUS === 'harmonic' ? '' : q.variant.UUS;
    const tv = q.targetVariant ? (q.targetVariant.UUS === 'harmonic' ? '' : q.targetVariant.UUS) : v;
    // TGM units in the exact variant keep "_exact"
    const exact = (s, w) => (w && w.TGM === 'exact' ? s.replace(/_TGM(?!_)/g, '_TGM_exact') : s);
    const quantity = (q.value !== null ? q.value + (q.operator === '°' ? '°' : '*') : (q.operator === '°' ? '°' : '')) + exact(this.uriExpr(this.render(q.units, v)), q.variant);
    const t = q.target ? q.target.replace(/^°/, '') : null;
    return quantity + '/' + (t ? (q.target.startsWith('°') ? '°' : '') + exact(this.uriExpr(this.render(t.replace(/\b(universal|GCD)\//g, ''), tv)), q.targetVariant || q.variant) : '*');
  };

  Converter.prototype.describeUnit = function (key) {
    const m = /^(?:([A-Z]+)\/)?(?:(harmonic|universal|GCD|gravitic|exact)\/)?(.+)$/.exec(key);
    const k = (m[1] ? m[1] + '/' : '') + (m[2] === 'gravitic' ? 'gravitic/' : '') + m[3];
    const n = this.units.names[k];
    if (!n) throw new ConvError('unknown_name', 404, `no unit "${key}"`, 0);
    const where = [];
    this.units.dimensions.forEach((D, d) => {
      if (D.calendar) return;
      D.units.forEach((u, i) => { if (u.expression.split(/\s*=\s*/).some((p) => p.replace(/^°/, '') === n.label)) where.push({ dimension: D.title, row: i, key: plain(this.engine('', '').pick(u.name)) }); });
    });
    let value = n.value;
    if (m[2] && value && typeof value === 'object') value = value[m[2] === 'harmonic' ? '' : m[2]];
    return { unit: { name: key, uri: uriName(m[3]) + (m[1] ? '_' + m[1] : '') + (m[2] && m[2] !== 'gravitic' ? '_' + m[2] : '') + (m[2] === 'gravitic' ? '_gravitic' : ''),
      label: n.label, system: n.system, variant: n.variant || m[2] || null, variants: n.variants || null,
      description: plain(n.description || ''), si: value, rows: where } };
  };

  // the conv.cgi parameters of an answer, for a redirect to conv.cgi (or to the page that imitates it)
  Converter.prototype.cgiParams = function (r) {
    if (r.kind === 'namespace') throw new ConvError('not_written', 422, 'a namespace has no conv.cgi page', 0);
    const code = (uus, tgm) => {
      const u = { '': 0, harmonic: 0, universal: 2, GCD: 3 }[uus] || 0, t = tgm === 'exact' ? 2 : 0;
      return (0x100f0 | (u << 8) | (t << 10)).toString(16);
    };
    if (r.kind === 'unit') {
      const w = r.unit.rows[0];
      const d = w ? this.units.dimensions.findIndex((D) => D.title === w.dimension) : 0;
      const v = r.unit.variant && r.unit.variant !== 'gravitic' ? r.unit.variant : '';
      return { m: code(v, ''), d, fu: w ? w.row : 0, tu: -1, fm: 'off', tm: 'off', c: 'Convert' };
    }
    const q = r.query, rd = q.read;
    const radixStr = (n, fr) => {               // an exponent as conv.cgi reads it: in radix fr
      if (typeof n === 'string') return n;
      const t = Math.abs(n).toString(fr).toUpperCase();
      return (n < 0 ? '-' : '') + (fr === 12 ? t.replace(/A/g, 'X').replace(/B/g, 'E') : t);
    };
    const p = { m: code(q.variant.UUS === 'harmonic' ? '' : q.variant.UUS, q.variant.TGM), d: q.dimension.index, fu: q.row };
    if (rd.fq !== null) { p.fq = rd.fq; p.fe = radixStr(rd.fe, rd.fr); }
    Object.assign(p, { fr: rd.fr, fp: 0, fl: rd.fl, fm: 'off',
      tu: q.target && r.results.length === 1 ? r.results[0].row : -1, tp: 0, tl: rd.tl, tm: 'off', c: 'Convert' });
    return p;
  };
  Converter.prototype.cgiURL = function (r, base) {
    const p = this.cgiParams(r);
    return base + '?' + Object.entries(p).map(([k, v]) => k + '=' + encodeURIComponent(String(v)).replace(/%3B/g, ';')).join('&');
  };

  function load(units, opts) { return new Converter(units, opts); }

  // ------------------------------------------------------------------ HTML
  // toHTML(answer of request) and errorHTML(error, input) give an HTML fragment; link(uri) makes the
  // href of another request (by default "#" + the request, for the single-page converter).
  // Everything that comes from the request is escaped; the cells of the table are conv.cgi's HTML.
  const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  const defaultLink = (uri) => '#' + encodeURI(uri).replace(/#/g, '%23');

  Converter.prototype.toHTML = function (r, link = defaultLink) {
    const a = (uri, text) => `<a href="${esc(link(uri))}">${text}</a>`;
    if (r.kind === 'namespace') {
      const N = r.namespace;
      const title = N.uri === '' ? 'UUS (harmonic) and the other namespaces' : N.uri;
      const nsl = N.namespaces ? `<ul class="uus-namespaces">${N.namespaces.map((x) =>
        `<li>${a(x.uri, esc(x.uri))} — ${esc(x.system)}${x.variant ? ' (' + esc(x.variant) + ')' : ''}, ${x.count} units</li>`).join('')}</ul>` : '';
      const rows = N.units.map((u, i) => `<tr><td class="n">${i + 1}</td><td class="u">${a(u.uri, esc(u.uri))}</td>` +
        `<td class="k">${esc(u.description)}${u.aliases ? ' <span class="also">(also ' + u.aliases.map((x) => a(x, esc(x))).join(', ') + ')</span>' : ''}</td>` +
        `<td class="k">${esc(u.dimensions.join(', '))}</td></tr>`).join('\n');
      return `<section class="uus-namespace">
<h2>${esc(title)}</h2>
${nsl}<table class="uus-results">
<thead><tr><th>#</th><th>URI</th><th>description</th><th>dimension</th></tr></thead>
<tbody>
${rows}
</tbody>
</table>
</section>`;
    }
    if (r.kind === 'unit') {
      const u = r.unit;
      const rows = u.rows.map((w) => `<li>${esc(w.dimension)}: ${esc(w.key)} — ${a('1Z0*' + u.uri + '/*', 'all units of this dimension')}</li>`).join('');
      const si = u.si === null || u.si === undefined ? '' : typeof u.si === 'object'
        ? Object.entries(u.si).map(([k, v]) => `${esc(k || 'harmonic')}: ${esc(v)}`).join(', ') : esc(u.si);
      return `<section class="uus-unit">
<h2>${esc(u.uri)}</h2>
<p class="desc">${esc(u.description)}</p>
<table class="uus-props">
<tr><th>system</th><td>${a(u.system === 'UUS' ? (u.variant && !['harmonic', 'gravitic'].includes(u.variant) ? u.variant + '/' : u.variant === 'gravitic' ? 'gravitic/' : '/') : u.system + '/', esc(u.system))}${u.variant ? ' (' + esc(u.variant) + ')' : ''}</td></tr>
<tr><th>name in the tables</th><td>${esc(u.label)}</td></tr>
${u.variants ? `<tr><th>variants</th><td>${esc(u.variants.join(', '))}</td></tr>` : ''}
<tr><th>value in SI units</th><td>${si}</td></tr>
</table>
${rows ? `<ul class="uus-rows">${rows}</ul>` : ''}
</section>`;
    }
    const q = r.query;
    const head = `<p class="uus-query"><code>${esc(r.uri)}</code><br>${esc(q.dimension.title)}` +
      (q.also && q.also.length ? ` <span class="also">(also ${esc(q.also.join(', '))})</span>` : '') + '</p>';
    // each unit in URI form, linked to the same quantity converted to that unit alone
    const quantity = r.uri.slice(0, r.uri.lastIndexOf('/'));
    const rows = r.results.map((x, i) => {
      const first = x.expression.split(/\s*=\s*/)[0];
      const uri = (first.startsWith('°') ? '°' : '') + this.uriExpr(first.replace(/^°/, ''));
      return `<tr><td class="n">${i + 1}</td><td class="q">${x.html}</td>` +
        `<td class="u" title="${esc(x.expression)}">${a(quantity + '/' + uri, esc(uri))}</td><td class="k">${esc(x.description || x.key)}</td></tr>`;
    }).join('\n');
    return `<section class="uus-conversion">
${head}
<table class="uus-results">
<thead><tr><th>#</th><th>quantity</th><th>unit</th><th>conv.rb</th></tr></thead>
<tbody>
${rows}
</tbody>
</table>
</section>`;
  };

  function errorHTML(err, input) {
    const s = String(input === undefined ? '' : input);
    let shown = s;
    try { shown = decodeURIComponent(s); } catch (e) { /* keep it as it is */ }
    const at = err.position !== undefined ? Math.min(err.position, shown.length) : null;
    const mark = at === null ? '' : `<pre class="uus-at">${esc(shown)}\n${' '.repeat(at)}^</pre>`;
    return `<section class="uus-error">
<p><strong>${esc(err.status || '')} ${esc(err.code || 'error')}</strong>: ${esc(err.message)}</p>
${mark}${err.hint ? `<p class="hint">${esc(err.hint)}</p>` : ''}
</section>`;
  }

  return { Engine, EngineError, Converter, ConvError, load, plain, errorHTML, escapeHTML: esc, LOGS, pw };
}));
