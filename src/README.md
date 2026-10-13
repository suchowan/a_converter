# conv.js

The converter of conv.rb / conv.cgi in JavaScript, running on `units.json` alone (no
server, no dependencies). It works in a browser (global `Conv`) and in Node
(`require('./conv.js')`).

## The UUS API (URI form)

The public form follows the UUS API draft of 2026-06-28, as revised since:

    REQUEST    ::= ( UNITS | CONVERSION ) [ "." TYPE ]            TYPE ::= json | html
    CONVERSION ::= QUANTITY "/" ( QUANTITY | "*" )                 "*": every unit of the dimension
    QUANTITY   ::= [ VALUE ( "*" | "°" | "@" ) ] UNITS              "@" is "°" in ASCII
    UNITS      ::= UNIT [ POWER ] { UNIT [ POWER ] }
    POWER      ::= [ "-" ] NUMBER [ "p2" ]
    UNIT       ::= NAME { "_" ( NAMESPACE | VARIANT ) }
    NAMESPACE  ::= SI | TGM | IDUS | TONAL | TRAD | CGS | CONST
    VARIANT    ::= harmonic | universal | GCD | gravitic | exact
    VALUE      ::= NUMBER12 ( "E" | "Z" ) [ "-" | "+" ] NUMBER      E: decimal, Z: duodecimal; a decimal power of 10 or 12
    NUMBER12   ::= [ "-" ] [0-9xe]+ [ ( "." | ";" ) [0-9xe]+ ]       (decimal digits before E)

* `SI/meter` and `universal/meter` are first rewritten as `meter_SI` and `meter_universal`,
  so that "/" only separates the quantity from the target.
* A run of digits inside a name is written after `_`: `Omega_1` (cycle), `Omega_2` (turn),
  `log_2_CONST`, `earthquakeMagnitude_00_CONST`. The constant 1 is `one_CONST`.
* The power follows its unit: `harmon1nic-1` (speed), `harmon1nic-2` (acceleration),
  `harmon2nic-1` (harmon² nic⁻¹), `Omega_1nic-1` (frequency). The `1` may be left out
  (`harmonnic-1`) when the units can be read only one way; the answer always writes it.
* UNITS alone: one unit gives its description (`harmon.html`); several, or a QUANTITY with a
  VALUE and no "/", are converted to the SI unit of the dimension.
* A VALUE without E or Z is read in the radix of the unit's system (an extension); `;` as the
  point is an extension too, so that a duodecimal answer can be typed back as it is.

```js
const c = Conv.load(units);
c.request('9E0*harmon/foot_TRAD.json');
c.request('1.00000000E0*harmon1nic-1/meter_SI1second_SI-1');
c.request('0E0°Celsius_SI/°Fahrenheit_TRAD');
c.request('1Z0*harmon1nic-2/*');
c.request('harmon.html');
```

A conversion answers `{ type, kind: 'conversion', query, results, uri }` (`uri` is the
request in canonical form); a unit answers `{ type, kind: 'unit', unit }`.

## The page

`page.html` is the converter page; `node build_page.js` makes two pages from it:

* `index.html` loads `conv.js` and `units.json` from its own folder (for a web site);
* `uus.html` carries both inside (about 250 kB) and works offline, opened as a file.

The request is read from the address: after `#` (`uus.html#9E0*harmon/foot_TRAD`), after
`/units/` in the path, or from `?q=`. On a static host such as GitHub Pages, `uus.html`
saved as `404.html` answers every `/units/...` address. A static host cannot send
`.json` itself; the page shows the JSON of the answer on request, and a server can call
`request()` and `toHTML()` / `JSON.stringify` the same way.

`toHTML(answer)` and `Conv.errorHTML(error, input)` give the HTML of an answer or a
refusal (the request is escaped; the error shows where in the request it is). Each unit
in a table links to the same quantity converted to that unit.

## Two layers

**Engine** — a port of conv.rb's numerics and number formatting: reading a typed
quantity (radix, digits, `;`, X E, the `h:m:s`, `'` and `` ` `` subunit notations,
the exponent field), the unit conversions with offsets and logarithmic types, and the
output text with conv.cgi's precision rule, grouping, `× 12.^-3;` notation and
`(exact)`. It takes conv.cgi's own parameters (`d fu fq fe fr fp fl tu tr tp tl tm`).

**query** — the core of the API, taking the units written as in the name tables (spaces,
`SYS/name^p`); `request` translates the URI form into it:

    QUANTITY ::= [ VALUE OP ] UNITS          OP  ::= "*" | "°" | "@"   ("@" is "°" in ASCII)
    UNITS    ::= TERM { SEP TERM }           SEP ::= " " | "."
    TERM     ::= [ SYSTEM "/" ] [ VARIANT "/" ] NAME [ "^" INTEGER ]
    SYSTEM   ::= SI | TGM | IDUS | TONAL | TRAD | CGS | CONST     (none: UUS)
    VARIANT  ::= harmonic | universal | GCD | gravitic (UUS)  |  exact (TGM)
    VALUE    ::= NUMBER [ ( "Z" | "E" | "^" ) EXPONENT ]

* VALUE is read as conv.cgi reads it, in the radix of the unit (UUS, TGM, IDUS:
  duodecimal, point `;` or `.`, digits X E or A B; TONAL: hexadecimal; others decimal).
  `Z` works in every radix: `1;6Z2` is 1;6 × 12², the exponent written in that radix.
  `E` (or `e`) only where E is not a digit (radix 10 and below): `1.5E3` is 1.5 × 10³.
  `^` is the same as `Z` (conv.cgi's exponent field).
* The digits typed set the precision of the answer, as in conv.cgi: `1*meter` has one
  digit, `1;0000000*meter` eight; no VALUE means 1 with the default precision (8 digits).
* `°` reads VALUE on a scale: a temperature on the scale `°X`, or a level (magnitude,
  dB) whose reference is X, with the dimension's default logarithmic type.
* The units must be written as conv.rb lists them (the expressions of the name
  tables); the order of the terms and aliases do not matter.
* Without a target, the answer lists every unit of the dimension (conv.cgi's "All").
* `harmon`, `nic`, `looloh` (harmonic) and `loolou` (universal) are names of one variant
  (`tables/variant_names.csv`): `harmon` is `harmonic/meter`. The target may be in another
  variant than the quantity: `1;0000000*looloh` to `loolou` gives the harmonic gram in
  universal grams.
* Answers write UUS units as each variant names them: harmonic `harmon nic looloh`
  (other units bare), universal `universal/meter universal/second loolou`, GCD
  `GCD/meter GCD/second GCD/gram`. Units whose value is the same in every variant
  (`light`, `Coulomb`, `mole`, ...) are written bare.

```js
const c = Conv.load(units);                       // units = the parsed units.json
c.query('1;6*meter', 'SI/meter');
c.query('0°SI/Celsius', '°TRAD/Fahrenheit');
c.query('3°CONST/earthquakeMagnitude00');         // every unit, as levels
```

The answer:

    { query:   { input, target, canonical, value, operator, units, terms[{name, system, power, description}],
                 dimension{index, title}, also[...], row, key, variant{UUS, TGM}, radix, digits, si },
      results: [{ expression, key, description?, row, value, text, html, radix }] }

`also` names the other dimensions the same units belong to (see below); `text` is the
plain form of `html`, which is exactly conv.cgi's cell.

Refusals throw `Conv.ConvError` with `code`, `status` (HTTP), `message`, and where
known `position` (in the string that was given) and `hint` (only when certain):

| code | status | |
|---|---|---|
| empty, syntax | 400 | nothing given; cannot be read as QUANTITY / UNITS |
| bad_value, bad_variant, variant_conflict | 400 | VALUE not in the radix; wrong variant; two UUS variants |
| unknown_name, unknown_system | 404 | name or system not in the tables |
| ambiguous | 409 | the units belong to two dimensions; give a target |
| not_written, incompatible, out_of_range | 422 | no conv.rb unit is written so; target in another dimension; no level of a non-positive quantity |

**Shared units.** SI writes some units of two dimensions alike because it sets a
constant to 1 in one of them (`implicit.csv`: Hz counts cycles, the rationalized units
count turns). Without a target the dimension without that constant is taken
(`SI/meter` is a length, not a wave length); with a target both give the same answer.
`TRAD/footPoundForce` (energy or torque) and `Joule gram^-1` (specific energy or
absorbed dose) stay ambiguous without a target.

Not yet ported: the Date dimension (calendars).

## Tests

    node golden.js units.json ../log harmonic     # the pages saved from production conv.cgi
    node golden.js units.json ../logu universal
    ruby oracle.rb conv.rb units.json 600 2 > cases.json   # conv.rb itself on random queries
    node diff.js units.json cases.json
    node rows.js units.json                        # every row through the name interface
    node fuzz.js units.json 20000 1                # random input: an answer or a ConvError, nothing else
    node uri.js units.json 20000 1                 # every row as a URI; random URIs
    node build_page.js                             # index.html and uus.html
    node cli.js "1Z0*harmon1nic-1/meter_SI1second_SI-1"   # try it

Results on 2026-10-12: golden 750/750 rows in both variants (13 rows renamed since the
pages were saved, 2 rows whose value was changed on purpose); 1,500 random conv.rb
queries identical (including radixes 2–16, subunits, logarithmic types, errors); 772
rows through the name interface; 100,000 fuzz inputs without an uncaught error.
