
# The Binary Operator `°`

## Purpose

Several familiar unit expressions carry two pieces of information at once: the
size of one graduation, and the point from which the graduations are counted.
`°C` is not merely "one kelvin"; it also says that the value is measured from
the ice point. `dBm` states both a logarithmic step and a reference power.

The operator `°` makes this structure explicit while leaving the existing
notations intact.

## Canonical Form

```
scale interval ° base point
```

The left operand gives the size of one graduation; the right operand gives the
zero of the scale. A numeral, when present, precedes the whole expression, so
the interval stands adjacent to it: `20 K°melting point of water`.

Both operands are quantities. A unit is itself a quantity of the kind it
measures, so an operand may be a unit (`mW`), a named quantity (`melting point
of water`), or a numeral times a unit (`20 mW`); `dB°mW` and `dB°1 mW` are the
same expression. An operand that carries its own numeral may be enclosed in
parentheses to keep it apart from the leading numeral: `3 dB°(20 mW)`.

## Relation to Subtraction

`A °B` resembles `A − B`, but two abbreviation rules apply that subtraction
does not admit.

**Rule 1 — Omitted interval.** If the left operand is omitted, one unit of the
base point's own unit is taken as the interval.

**Rule 2 — Dimensional adjustment.** If the two operands differ in dimension,
an implicit operation is applied to the base point to bring it into the
dimension of the interval. The same operation is applied to the quantity being
expressed, so that the value counts graduations between the two. When an
existing notation is transcribed, the operation is the one fixed by that
notation's established convention; the full form writes it out.

These rules are what make `°` worth distinguishing from `−`.

## Examples

| Abbreviated | Full form | Rule |
|---|---|---|
| `°CE` | `year ° Common Era` | 1 |
| `°C` | `K ° melting point of water` | 1 |
| `dB°mW` | `deci log(10) ° log(mW)` | 2 |
| `°H` | `♯K ° `*T*<sub>E</sub> | 1 |

*T*<sub>E</sub> is the base Hyper Kelvin of the Earth. Although the symbol does
not contain an "H", it carries Hyper Kelvin as its concept — just as "melting point 
of water" contains no "C" yet carries kelvin as its graduation.

## Logarithmic Scales

Rule 2 does most of its work on logarithmic scales, and it is easy to misread
there. The points below keep apart what belongs to the interval and what belongs
to the base point.

### The interval is a pure logarithm

The units that can stand on the left are logarithms and nothing more:

| Unit | Value |
|---|---|
| neper | log e |
| bel | log 10 (deci log 10 = decibel) |
| bit | log 2 |

They carry no reference to any physical kind of quantity. Conversions among
them are ratios of logarithms only:

- 1 neper = log e = 0.434 294 bel = 4.342 94 dB
- 1 bit = log 2 = 0.301 030 bel = 3.010 30 dB

### The base point carries what is logarithmized

What differs from one application to another is the argument of the logarithm:
which ratio is taken. That information sits on the right of `°`, through the
implicit operation of Rule 2.

Existing notations differ in what they take the logarithm of, and this is a
matter of their convention, not of their units. In existing practice, the
decibel applied to a power is ten times the common logarithm of the ratio,
whereas the decibel applied to a voltage is twenty times it; the neper applied
to a voltage is the natural logarithm of the ratio, whereas the neper applied to
a power is half of it. Transcribed with `°`, each convention becomes an explicit
operation on the base point:

| Existing notation | Full form | Existing reading of the value |
|---|---|---|
| `dB°mW` (dBm) | `deci log(10) ° log(mW)` | 10 lg (*P*/1 mW) |
| `dB°W` (dBW) | `deci log(10) ° log(W)` | 10 lg (*P*/1 W) |
| `dB°V` (dBV) | `deci log(10) ° log(V²)` | 20 lg (*U*/1 V) |
| `dB°μV` (dBμV) | `deci log(10) ° log((μV)²)` | 20 lg (*U*/1 μV) |
| `Np°V` | `log e ° log(V)` | ln (*U*/1 V) |
| `Np°W` | `log e ° log(√W)` | ½ ln (*P*/1 W) |

In each row the interval is the same pure logarithm as in the table above. The
factor 2 or ½ appears only on the right.

Example: a voltage of 2 V, expressed in `dB°V`, is
log(4 V²) − log(V²) = log 4 = 6.02 × deci log 10, that is, 6.02 `dB°V`.
Expressed in `Np°V`, it is log(2 V) − log(V) = log 2 = 0.693 × log e, that is,
0.693 `Np°V`.

### The relation 1 B = (ln 10)/2 Np

ISO 80000-3 states 1 B = (ln 10)/2 Np. This is not a relation between units.
It holds because existing practice applies the neper to root-power ratios and
the bel to power ratios: the factor ½ records that difference of application.
Here the difference appears on the right of `°` — compare the rows `dB°V` and
`Np°V` above — and the units themselves remain log 10 and log e, with
1 B = ln 10 Np as logarithms.

Reading the ISO relation as an equation between the units, and carrying it to
the left of `°`, loses or doubles a factor 2.

### Changing the base point versus changing the interval

- Changing the base point shifts the zero of the scale: 1 mW is 0 `dB°mW` and
  −30 `dB°W`.
- Changing the interval rescales the graduations: a level of 1 `Np°V` is
  8.69 `dB°V`, because the two rows apply different operations on the right and
  their intervals differ by log e/deci log 10.
- Changing the unit inside the argument changes neither: a ratio taken in
  W/W or in mW/mW is the same ratio.

### Moving between a voltage base point and a power base point

Rewriting a `°V` value as a `°W` value is not a unit conversion. It requires
the physical relation between the two quantities in the system being measured
— for a resistive load, the resistance. With 1 V across 50 Ω as the reference
and 2 V across 100 Ω as the measured state, the voltage ratio is 2 and the
power ratio is also 2: the measured state is 6.02 `dB°(1 V)` but only
3.01 `dB°(20 mW)`. No rule of the
operator can supply that relation; it belongs to the physics, not to the
notation.

## Note on Usage

Common practice sometimes drops the `°` itself. This specification recommends
writing `°` explicitly.
