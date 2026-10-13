# Name tables for the unit converter

These CSV files are maintained by hand. They give every unit of conv.rb a URI name
and write every conv.rb row as an expression of those names. They were frozen on
2026-10-12 from the generated drafts; from now on the files here are the source,
and nothing regenerates them.

Files are UTF-8 with BOM and CRLF, so they open directly in Excel.

| file | columns | one row per |
|---|---|---|
| `names_<system>.csv` | name, [variants], texts, description, note | unit of that system |
| `entries.csv` | dimension, key, expression, note | conv.rb row |
| `implicit.csv` | dimension, implicit, note | dimension whose SI unit silently sets a constant to 1 |
| `variant_names.csv` | name, variant, unit, description, note | name a UUS unit has in one variant only (harmon, nic, looloh, loolou) |

* **name**: the URI names of the unit, `a | b`; the first one is used in expressions.
  Systems: UUS (no prefix in a URI), SI, TGM, IDUS, TONAL, TRAD, CGS, CONST.
* **variants** (UUS only): `harmonic universal GCD`, and/or `gravitic`.
* **texts**: the conv.rb texts the unit stands for, `a | b`.
* **key**: the conv.rb text of the row, exactly as in conv.rb.
* **expression**: names multiplied with spaces, `SYS/name^p` (no `SYS/` = UUS,
  `gravitic/name` = the gravitic variant); `a = b` when the same value has two
  readings; `°X` on a scale dimension (thermodynamic temperature and the
  logarithmic dimensions), the point whose reference is X.
* **implicit**: cycle (Hz counts cycles), naturalMol (Bq counts entities), turn
  (rationalized electromagnetic units set the full solid angle to 1). SI-style
  rows of the dimension leave the constant out; a row whose expression names an
  angle or an amount carries it explicitly.

## Generating and checking

    ruby gen_units.rb -o units.json conv.rb

`gen_units.rb` evaluates conv.rb, checks these tables against the values it gets,
and writes units.json only if everything agrees (otherwise it lists the problems and
leaves units.json as it was). The checks: every conv.rb row has exactly one entry,
names are unique within a system, every name in an expression exists, `°` appears
exactly on the scale dimensions, and every expression has the value conv.rb gives
its row in every variant. `--verbose` also lists the names that occur only inside
compound units, with the value inferred for each.

    ruby check_tables.rb units.json tables

runs the same checks against an existing units.json without regenerating it.

In units.json the tables appear as `expression` on every unit row, `scale` and
`implicit` on the dimensions, and a top-level `names` index: name as written in an
expression (`meter`, `SI/meter`, `gravitic/meter`, and every alias) -> system, label
(the name expressions use), description, variants (UUS), value (SI value, by variant
where it differs) and `row` (the conv.rb row that is this unit alone, if any).
