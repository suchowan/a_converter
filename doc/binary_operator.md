
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

## Relation to Subtraction

`A °B` resembles `A − B`, but two abbreviation rules apply that subtraction
does not admit.

**Rule 1 — Omitted interval.** If the left operand is omitted, one unit of the
base point's own unit is taken as the interval.

**Rule 2 — Dimensional adjustment.** If the two operands differ in dimension,
an implicit operation is applied to the base point to bring it into the
dimension of the interval.

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

## Note on Usage

Common practice sometimes drops the `°` itself. This specification recommends
writing `°` explicitly.

