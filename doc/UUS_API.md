# UUS API — the request syntax and the answers

Version 2026-10-13. This revises the draft of 2026-06-28
([blog](https://suchowan.seesaa.net/)); the differences are listed at the end.

The UUS API names units and conversions by URI. The same request works in two places:

| where | form | answers |
|---|---|---|
| hosi.org (server) | `http://dozenal.com/units/REQUEST` | JSON, or a redirect to conv.cgi |
| any browser (no server) | `https://suchowan.github.io/a_converter/js/api.html#REQUEST` | an HTML page |

Both run the same program, [`conv.js`](../js/conv.js), on the same data, [`units.json`](../js/units.json),
which is generated from [`conv.rb`](../bin/conv.rb) and the name tables in [`bin/tables/`](../bin/tables/).
The namespace `uus:` stands for `http://dozenal.com/units/`.

## 1. Abstract syntax

```
REQUEST    ::= ( UNITS | CONVERSION ) [ "." TYPE ]
TYPE       ::= "json" | "html"
CONVERSION ::= QUANTITY "/" TARGET
TARGET     ::= [ SCALE ] UNITS | "*"
QUANTITY   ::= [ VALUE OP ] UNITS
OP         ::= "*" | SCALE
SCALE      ::= "°" | "@"                                  "@" is "°" written in ASCII
UNITS      ::= UNIT [ POWER ] { UNIT [ POWER ] }
POWER      ::= [ "-" ] DIGITS [ "p2" ]
UNIT       ::= NAME { "_" ( NAMESPACE | VARIANT ) }
NAMESPACE  ::= "SI" | "TGM" | "IDUS" | "TONAL" | "TRAD" | "CGS" | "CONST"
VARIANT    ::= "harmonic" | "universal" | "GCD" | "gravitic" | "exact"
NAME       ::= LETTERS { "_" DIGITS [ LETTERS ] }             a name of the name tables
VALUE      ::= MANTISSA ( "E" | "Z" ) [ "-" | "+" ] DIGITS
MANTISSA   ::= [ "-" ] DIGIT12 { DIGIT12 } [ POINT DIGIT12 { DIGIT12 } ]
POINT      ::= "." | ";"
DIGIT12    ::= "0" … "9" | "x" | "e" | "X"                    "x" = ten, "e" = eleven
LETTERS    ::= ( "a" … "z" | "A" … "Z" ) { "a" … "z" | "A" … "Z" }
DIGITS     ::= ( "0" … "9" ) { "0" … "9" }
```

### 1.1 Before the syntax is applied

1. The request is percent-decoded (`%C2%B0` is `°`). A broken `%`-sequence is an error.
2. A trailing `.json` or `.html` is taken as TYPE; the default is `json`.
3. A namespace or variant written **before** a name with `/` is moved **after** it with `_`:
   `SI/meter` → `meter_SI`, `universal/meter` → `meter_universal`,
   `TGM/exact/Grafut` → `Grafut_TGM_exact`. After this, `/` only separates QUANTITY and TARGET.

### 1.2 Units

* A UNIT without NAMESPACE is a unit of the Universal Unit System (UUS); every other unit
  carries its namespace: `meter_SI`, `foot_TRAD`, `Grafut_TGM`.
* POWER follows its unit and belongs to it: `harmon1nic-1` is harmon·nic⁻¹ (speed),
  `harmon1nic-2` acceleration, `harmon2nic-1` harmon²·nic⁻¹. `p2` halves it (`2p2` = 1).
* POWER may be left out when the units can be read only one way (`harmonnic-1`); of the
  readings the one with fewest units is taken, and if two remain the request is refused
  (`ambiguous`). Answers always write the power.
* A run of digits inside a name of the tables is written after `_`: the table name `Omega1`
  is `Omega_1`, `log2` (CONST) is `log_2_CONST`, `earthquakeMagnitude00` is
  `earthquakeMagnitude_00_CONST`. The constant 1 is `one_CONST`.
* The units must form a unit that conv.rb lists in some dimension (the expressions of
  `bin/tables/entries.csv`); their order does not matter, and aliases are equal
  (`dour` = `solarUnitia`, `Omega_1` = `cycle`).

### 1.3 Variants

* UUS: `harmonic` (default), `universal`, `GCD`; `gravitic` units are units of their own.
  `harmon`, `nic`, `looloh` are the harmonic meter, second and gram; `loolou` the universal gram.
* TGM: `exact` (Lightvlos exactly); the default is Lightvlos not exactly.
* The TARGET may be in another variant than the QUANTITY: `1Z0*looloh/loolou`.
* A unit whose value is the same in every variant (`light`, `Coulomb`, `mole`, …) is written
  without a variant in the answers.

### 1.4 VALUE

* `E` reads the mantissa as decimal, `Z` as duodecimal; DIGITS after it is a **decimal**
  exponent of 10 or 12, and is not left out: `9E0`, `1.5E-3`, `1.6Z0`, `x;eZ2` (= 10;11 × 12²).
* The digits of the mantissa set the precision of the answer, as in conv.cgi: `1Z0` gives about
  two digits, `1.0000000Z0` about eight. Without VALUE the quantity is 1 with eight digits.
* *Extensions:* `;` as the point (so that a duodecimal answer can be typed back as it is);
  a VALUE without `E` or `Z` is read in the radix of the unit's system (duodecimal for UUS,
  TGM, IDUS; hexadecimal for TONAL; decimal otherwise).

### 1.5 Scales: `°`

* In thermodynamic temperature, `°X` is the point of the scale X: `0E0°Celsius_SI` is the
  freezing point, `0E0°Celsius_SI/°Fahrenheit_TRAD` gives 32. Without `°` the same name is an
  interval (difference in temperature).
* In the logarithmic dimensions (earthquake magnitude, sound pressure and intensity levels,
  absolute and apparent magnitude, pH), `°X` is a level whose reference is X, on the dimension's
  logarithmic scale: `3E0°earthquakeMagnitude_00_CONST` is magnitude 3.
* `°` elsewhere, or a scale unit written without `°`, is refused (`not_written`).

## 2. What a request does

| request | answer |
|---|---|
| `UNIT` (one unit, no VALUE) | the description of the unit |
| `UNITS` (several) or `QUANTITY` with VALUE, no `/` | converted to the SI unit of the dimension |
| `QUANTITY/UNITS` | the quantity in that unit |
| `QUANTITY/*` | the quantity in every unit of the dimension, in conv.cgi's order |

**Units in two dimensions.** SI writes some units of two dimensions alike because it sets a
constant to 1 in one of them (`bin/tables/implicit.csv`): Hz counts cycles, Bq counts entities,
the rationalized electromagnetic units count full solid angles. `meter_SI` is a length and also
a wave length; `Coulomb_SI` a charge and also an electric flux. Without a target the dimension
without that constant is taken, and the other is named in `also`; with a target the answer is the
same in either. Where no such rule decides (`footPoundForce_TRAD`: energy or torque;
`Joule1gram-1`: specific energy or absorbed dose), a target is required.

## 3. Answers (JSON)

A conversion:

```json
{ "type": "json", "kind": "conversion",
  "uri": "9E0*harmon/foot_TRAD",
  "query": {
    "input": "9E0*harmon/foot_TRAD", "canonical": "9E0*harmon/foot_TRAD",
    "target": "TRAD/foot", "value": "9E0", "operator": "*", "units": "meter",
    "terms": [ { "name": "meter", "system": "UUS", "power": 1, "description": "harmonic meter" } ],
    "dimension": { "index": 0, "title": "Length" }, "also": [],
    "row": 0, "key": "harmon",
    "variant": { "UUS": "harmonic", "TGM": "" }, "targetVariant": { "UUS": "harmonic", "TGM": "" },
    "read": { "fq": "9", "fe": 0, "fr": 10, "fl": 0, "tl": 0 },
    "radix": 10, "digits": 1, "si": 2.4511698534756032 },
  "results": [
    { "expression": "TRAD/foot", "key": "foot", "description": "foot", "row": 26,
      "value": 8.041895844736231, "text": "8.", "html": "8.", "radix": 10 } ] }
```

* `uri` / `canonical`: the request written canonically (units in conv.rb's order, powers written).
* `units`, `target`, `results[].expression`: the units as the name tables write them
  (`SYS/name^p`, separated by spaces; `°` for scale points).
* `si`: the quantity in SI units (with the implicit constants of SI set to 1).
* `results[].text`: the number as conv.cgi writes it, in the radix of the unit; `html` is
  conv.cgi's own cell; `value` is the number as a floating-point value.
* `read`: what conv.cgi would be given (radix `fr`, mantissa `fq`, exponent `fe`,
  logarithmic types `fl`, `tl`); the `.html` redirect uses it.

A unit:

```json
{ "type": "json", "kind": "unit",
  "unit": { "name": "harmon", "uri": "harmon", "label": "meter", "system": "UUS",
            "variant": "harmonic", "variants": ["harmonic"], "description": "harmonic meter",
            "si": 0.2723522059417337,
            "rows": [ { "dimension": "Length", "row": 0, "key": "harmon" } ] } }
```

## 4. Errors

A refused request answers `{ "error": { "code", "message", "position"?, "hint"? } }` with the
HTTP status below. `position` counts characters of the decoded request; `hint` is given only
when it is certain.

| code | status | meaning |
|---|---|---|
| `empty` | 400 | nothing requested |
| `syntax` | 400 | the request cannot be read (operators, `/`, powers, %-encoding) |
| `bad_value` | 400 | VALUE: a digit not of its radix, a missing exponent, two points |
| `bad_variant`, `variant_conflict` | 400 | a variant the unit does not have; two UUS variants in one quantity |
| `unknown_name`, `unknown_system` | 404 | no such unit or namespace |
| `ambiguous` | 409 | the units can be read two ways, or belong to two dimensions without a rule |
| `not_written` | 422 | no conv.rb unit is written so (or `°` where there is no scale) |
| `incompatible` | 422 | the target is in another dimension |
| `out_of_range` | 422 | no value (a level of a quantity that is not positive, an overflow) |

## 5. HTML

* `api.cgi?api=REQUEST.html` redirects (302) to conv.cgi with the same conversion
  (`m d fu fq fe fr fp fl tu tp tl tm c=Convert`).
* `js/index.html` takes the same conv.cgi parameters, and also `#REQUEST`.
* `js/api.html#REQUEST` shows the answer of any request, with each unit linked.

## 6. Differences from the draft of 2026-06-28

* NAMESPACE: SI, TGM → SI, TGM, IDUS, TONAL, TRAD, CGS, CONST. VARIANT is new.
* `°` (and `@`) as an operator of QUANTITY and before TARGET.
* `NAMESPACE/NAME` and `VARIANT/NAME` are rewritten to `NAME_NAMESPACE`, `NAME_VARIANT` first.
* Units may follow one another without a power where only one reading is possible.
* Extensions: `;` as the point; VALUE without `E`/`Z`.
* The default precision is conv.cgi's (8 digits).
