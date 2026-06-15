# Glossary — Universal Unit System (UUS) / Harmonic System

A reference glossary of units, prefixes, constants, and structural terms used
across [`revised.pdf`](doc/revised.pdf), [`units.pdf`](doc/units.pdf),
[`harmonic.pdf`](doc/harmonic.pdf), and the
[`Eight Quartets`](doc/pic/Eight_Quartets_vertical_clear.png) diagram.

**Notation.** A semicolon `;` is the duodecimal radix point; `↊` = ten,
`↋` = eleven. SI values use a period `.` as the radix point. The identifier of
a Harmonic System unit is the **prefix** `±` (formerly the suffix `h`); it is
rendered here as <font color='royalblue'><sub>±</sub></font> to keep it
subscripted. SI equivalents are taken from the *Clock_by_Rydberg* sheet of
`harmonic.pdf`.

---

## 1. Base Units (natural)

| Symbol | Name | Quantity | SI equivalent | Notes | Wikipedia |
|--------|------|----------|---------------|-------|-----------|
| <font color='royalblue'>rad</font> | [radian](http://hosi.org/cgi-bin/conv.cgi?c=d&m=100f0&d=86&tu=1&tr=10&tm=off&tp=0&tl=0&fu=0&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert)| plane angle | same as SI | natural, coherent, core |  [radian](https://en.wikipedia.org/wiki/Radian) |
| <font color='royalblue'>neper</font> | [neper](http://hosi.org/cgi-bin/conv.cgi?c=fu&m=100f0&d=59&tu=1&tr=10&tm=off&tp=0&tl=0&fu=2&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert) | logarithm of Napier's constant | same as SI | natural, base | [neper](https://en.wikipedia.org/wiki/Neper) |
| <font color='royalblue'><sub>♮</sub>mol</font> | [natural mol](http://hosi.org/cgi-bin/conv.cgi?m=100c0&d=0&fq=1.0000000&frq=12&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | reciprocal Avogadro constant (<font color='royalblue'>N<sub>A</sub>⁻¹</font>) | mol / 602,214,076,000,000,000,000,000 | `♮` ≡ `3-`; substance must be specified | [Avogadro constant](https://en.wikipedia.org/wiki/Avogadro_constant) ⁻¹ |
| <font color='royalblue'><sub>♮</sub>Ω</font> (<font color='royalblue'>Z<sub>P</sub></font>) | [nohm](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | natural unit of impedance | 29.9792458 Ω | vacuum impedance | [Impedance of free space](https://en.wikipedia.org/wiki/Impedance_of_free_space) / [`Ω₂`](#5-derived-units--electromagnetic) |

## 2. Base Units (not natural)

| Symbol | Name | Quantity | SI equivalent |
|--------|------|----------|---------------|
| <font color='royalblue'><sub>±</sub>h</font> | [harmon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | length | 0.27235220594 m (272.352 mm) |
| <font color='royalblue'><sub>±</sub>n</font> | [nic](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | time | 0.39062511513 s (390.625 ms) |
| <font color='royalblue'><sub>±</sub>J</font> | [harmonic Joule](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | energy | 64.084556 mJ — overline <font color='royalblue'><sub>±</sub>J̅</font> = equivalent dose |
| <font color='royalblue'><sub>±</sub>K</font> | [harmonic Kelvin](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=1.0000000&frq=12&fe=0&fu=8&tu=9&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | temperature | 58.387542 μK (= 10;⁻⁴ °H) |

## 3. Derived Units — Geometrical

| Symbol | Name | Quantity | SI equivalent | Notes |
|--------|------|----------|---------------|-------|
| <font color='royalblue'>rad<sup>2</sup></font> | [steradian](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | solid angle | 1 sr | derived from `rad` (See [univunit-e.pdf](https://github.com/suchowan/a_converter/blob/master/doc/dozenal_com/univunit-e.pdf) p.11 eq.(19))|
| <font color='royalblue'><sub>±</sub>h<sup>2</sup></font> (<font color='royalblue'><sub>±</sub>q</font>) | [square harmon / harmonic square](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=4&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | area | 741.757241 cm²| `q` from Latin *quadrata* |
| <font color='royalblue'><sub>±</sub>h<sup>3</sup></font> (<font color='royalblue'><sub>±</sub>c</font>) | [cubic harmon / harmonic cube](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-1&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | volume  | 20.2019221 dm³ | ≈ 16/3 gallon (since 2/3 gallon ≈ (½ harmon)³); `c` from Latin *cubus* |

## 4. Derived Units — Dynamical

| Symbol | Name | Quantity | SI equivalent | Notes |
|--------|------|----------|---------------|-------|
| <font color='royalblue'><sub>±</sub>l</font> | [looloh](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | mass | 131.829289 g (harmonic gram, mass) | |
| <font color='royalblue'><sub>±</sub>W</font> | [harmonic Watt](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | power | 164.056415 mW | overline <font color='royalblue'><sub>±</sub>W̅</font> = luminous flux (effective Watt) |
| <font color='royalblue'><sub>±</sub>N</font> | [harmonic Newton](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=11&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | force | 235.300301 mN | |
| <font color='royalblue'><sub>±</sub>P</font> | [harmonic Pascal](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | pressure | 3.172201 Pa | overline <font color='royalblue'><sub>±</sub>P̅</font> = phon pressure (effective Pascal) |

## 5. Derived Units — Electromagnetic

| Symbol | Name | Quantity | SI equivalent | Notes |
|--------|------|----------|---------------|-------|
| <font color='royalblue'><sub>±</sub>C</font> | [harmonic / universal Coulomb](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric charge | 28.896578 mC | |
| <font color='royalblue'><sub>±</sub>A</font> | [harmonic Ampere](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric current | 73.975219 mA | voltage = <font color='royalblue'><sub>♮</sub>Ω</font><font color='royalblue'><sub>±</sub>A</font>, read "[nohm Ampere](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)" |
| <font color='royalblue'><sub>±</sub>E</font> | [harmonic Ørsted](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | field strength| 271.616 mA/m / Ω₂ | magnetic field strength = <font color='royalblue'><sub>♮</sub>Ω</font><font color='royalblue'><sub>±</sub>E</font> |
| <font color='royalblue'><sub>±</sub>T</font> | [harmonic Tesla](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=9&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | flux density | 11.678991 T / Z<sub>P</sub> | electric flux density = <font color='royalblue'>Ω<sub>2</sub><sub>±</sub>T</font> |

<p align="center">
  <a href="https://gist.github.com/suchowan/5c2f1ca3cfb79b3abb8ae40bbf3a2a5f#3-figure-1--symmetric-placement-of-electromagnetic-quantities">
    <img src="https://raw.githubusercontent.com/suchowan/notes/refs/heads/master/pic/Figure_1.png" width="400"
         title="Relationships among the dimensions of electromagnetic quantities"/>
  </a>
</p>

*Figure 1.* How the electromagnetic quantities relate through ×impedance
(<font color='royalblue'><sub>♮</sub>Ω</font>), ×solid angle(`Ω₂`), ×area, ×time, and ×length. The four base units
<font color='royalblue'><sub>±</sub>C</font>,
<font color='royalblue'><sub>±</sub>A</font>,
<font color='royalblue'><sub>±</sub>E</font>,
<font color='royalblue'><sub>±</sub>T</font> occupy four nodes of this lattice;
every other quantity follows by these operations.

The prefix `harmonic` (`±`) may be called `universal`, since the universal
unit equals the harmonic unit. When context makes the Harmonic System clear,
`±` need not be pronounced.

## 6. Defining Constants

| Symbol | Name | Quantity | SI equivalent | Constant | Wikipedia |
|--------|------|----------|---------------|----------|-----------|
| <font color='royalblue'>R<sub>∞</sub></font> | [Rydberg](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=87&fq=1.0000000000000&frq=10&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | wave number | 10973731.568157 Ω₁/m | the Rydberg constant | [Rydberg constant](https://en.wikipedia.org/wiki/Rydberg_constant) |
| <font color='royalblue'><sub>♮</sub>γ</font> (`c₀`) | [light](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=6&fq=1.00000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | velocity | 299792458 m/s | speed of light in vacuum | [Speed of light](https://en.wikipedia.org/wiki/Speed_of_light) |
| `ħ` | [quantum](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=25&fq=1.000000000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | action | 6.62607015×10<sup>−34</sup> J⋅s / 2π | quantum of action (reduced Planck constant) | [Planck constant](https://en.wikipedia.org/wiki/Planck_constant) |
| <font color='royalblue'>k<sub>B</sub></font> | [Boltzmann](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=5&fq=1.0000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | entropy | 1.380649×10<sup>−23</sup> J/K | the Boltzmann constant | [Boltzmann constant](https://en.wikipedia.org/wiki/Boltzmann_constant) |

## 7. Supplementary Constants

| Symbol | Name | SI equivalent | Constant | Wikipedia |
|--------|------|---------------|----------|-----------|
| `e` | [electron](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=10&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | 1.602176634×10<sup>−19</sup> C | elementary electric charge | [Elementary charge](https://en.wikipedia.org/wiki/Elementary_charge) |
| <font color='royalblue'><sub>±</sub>mol</font><sub>substance</sub> | [harmonic / universal mol](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=7&fq=1.0000000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 132.00762 mol | with substance name (ex. <font color='royalblue'><sub>±</sub>mol</font><sub>CO₂</sub>) | [Mole (unit)](https://en.wikipedia.org/wiki/Mole_(unit)) |
| <font color='royalblue'>Ω<sub>k</sub></font> | turn-class unit | — | total solid angle of a hypersphere (Ω₁=[cycle](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=86&fq=1.0000000&frq=12&fe=0&fu=3&tu=7&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert), Ω₂=[turn](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=3&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | — |
| <font color='royalblue'>℧<sub>k</sub></font> (<font color='royalblue'>f<sub>k</sub></font>) | figure | — | logarithm of an integer; f₁=[bit](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=10&fe=0&fu=4&tu=3&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert), f₄=nibble, f₈=byte, f_z=[figure](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (z = log12./log2). Alias `f` where `℧` unavailable | — |

## 8. Structural Constants

| Symbol | Name | Value / role |
|--------|------|--------------|
| `Ω₀` | — | total solid angle of a hypersphere, `Ω₀ = 2`; fermi component of the representational lattice (in `2^n × 12^m`, the `2` is `Ω₀`) |
| `Ω₁` | [cycle](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=86&fq=1.0000000&frq=12&fe=0&fu=3&tu=7&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | |
| `Ω₂` | [turn](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=3&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | pairs with <font color='royalblue'><sub>♮</sub>Ω</font> as `⟨♮Ω, Ω₂⟩` dual structure in EM quantities |
| `ω₁` | Primary Harmonic Ratio | `9/8` (= 90/80). Ratio between one harmonic meter and ... ; links day ↔ <font color='royalblue'><sub>±</sub>n</font>; a major second |
| `ω₂` | Fine Harmonic Ratio | `41/40` (= 82/80). Elementary charge / impedance-derived charge unit; appears in Earth's meridian and ice density; one comma-pair in 53-TET (Note 49) |

`(ω₁−1)/(ω₂−1) = 5` — corresponds to one black-key sub-division (5 commas) of
the 53-tone equal-tempered keyboard.

## 9. Minor / Major Prefixes

| Prefix | Symbol | Power | Notes |
|--------|--------|-------|-------|
| sub | `♭` | 10;⁻⁴ | `±` omitted when `sub` is present |
| atomic | `-` | 10;⁻⁸ | `±` omitted when `atomic` is present |
| dirac | `∜♯` | 10;¹ | only for Gravitic-with-Harmonic System |
| hyper | `♯` | 10;⁴ | `±` omitted when `hyper` is present |
| cosmic | `+` | 10;⁸ | `±` omitted when `cosmic` is present |

## 10. Power Prefixes

| Prefix | Power | Prefix | Power |
|--------|-------|--------|-------|
| di- (`2`) | 2nd | penta- (`5`) | 5th |
| ter- (`3`) | 3rd | hexa- (`6`) | 6th |
| tetra- (`4`) | 4th | hepta- (`7`) | 7th |

## 11. Earth-Local Units & Constants

| Symbol | Name | Definition |
|--------|------|------------|
| <font color='royalblue'>m<sub>E</sub></font> | Earth meridian ([meridian](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=0&fq=1.0000000&frq=12&fe=0&fu=13&tu=1&fp=0&tp=3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | meridian length of the Earth (≑ (ω₂/3) cosmic harmon / Ω₁) |
| <font color='royalblue'>s<sub>E</sub></font> | Earth solar ([solar](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=2&fq=1.0000000&frq=12&fe=0&fu=14&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | rotation period of the Earth (epoch: start of year 1900.) |
| <font color='royalblue'>g<sub>E</sub></font> | gee of Earth ([gee](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=18&fq=1.0000000&frq=12&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | gravitational acceleration of the Earth |
| <font color='royalblue'>T<sub>E</sub></font> | base point of degree H | Earth-local temperature scale = `118,2354; ±K` (≈ −74.36 °C, −101.85 °F); the only deliberately chosen component |
| `°H` | [degree H](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=0.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | difference of thermodynamic temperature from the base point; `0;°H` ↔ `118,2354; ±K` (T<sub>E</sub>), chosen so that `100;°H` matches the boiling point of water |

## 12. Calendar-Time Units

| Symbol | Name | Definition |
|--------|------|------------|
| `☼̃` | [year](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.00000000&frq=12&fe=0&fu=23&tu=13&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 365. 31./128. days |
| `☽̃` | month | 10;⁻¹ year |
| `°̃` | [day](pic/calendar_time_structure_nodus.png) | 1 Ω₁ |
| `′̃` | unitia | 10;⁻¹ day |
| `″̃` | ditia | 10;⁻² day |
| `‴̃` | [tertia](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=8&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ day |
| `☆̃` | [nodus](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁻⁷ (1/128.) day |
| `⌬̃` | [hexon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=24&tu=23&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁺⁶ years |
| `▽̃` | [ternon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=7&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ nodus |

## 13. Social Aliases

| Symbol | Name | Definition |
|--------|------|------------|
| `mon`<sub>country</sub> | mon | least-valued currency unit of a country/economic group (ex. 1$ = 84; mon<sub>us</sub>) |
| ;′<font color='royalblue'><sub>±</sub>h</font> | unínoh | 10;⁻¹ harmon = [2.2696 cm](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.89354 inch](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=25&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) |
| ;″<font color='royalblue'><sub>±</sub>l</font> | dinól | 10;⁻² looloh = [0.91548 gram](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.03229 ounce](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=10&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) |
| <font color='royalblue'><sub>-</sub>γ</font> | atol | 10;⁻⁸ c₀ = 1 harmon / nic = 2.509 997 km/h |

Aliases are *interfaces*, not weaknesses. Several social aliases, introduced
independently, necessarily derive their final letter from the corresponding
base unit name (−h from harmon, −l from looloh, −n from nodus) — a convergence
reflecting the system's structural constraints. The optional diacritical mark
“ ́” on unínoh/dinól indicates word stress.

## 14. Scaling & Hierarchy

The scaling factor **U = 12⁸** is not chosen for human convenience; it
**emerges** as a dimensionless ratio `u / M = 1;0009060E × 10;⁸` between the
nucleon rest energy and a typical chemical energy. At this scale:

| Scale | Quantity |
|-------|----------|
| `U⁻³` | rest mass of 1 nucleon |
| `U⁻¹` | rest energy of 1 nucleon (E = mc₀²) |
| `U⁻²` | typical chemical energy (= energy of 1 photon at peak visual sensitivity, 540 THz) |

---

## Structural Terms

- **Quartet structure** — the system organizes units into universal,
  Earth-local, and alias quartets (see the *Eight Quartets* diagram).
- **Harmonic System** — the layer designed so that key physical and
  astronomical constants approximate multiples/submultiples of integer powers
  of twelve.
- **Coexistence with SI** — UUS is designed to coexist with SI, not replace
  it; SI conversion factors are stable since the 2019 SI redefinition and
  unaffected by CODATA adjustments.

---

*Generated from the text layers of `revised.pdf`, `units.pdf`, and
`harmonic.pdf`. SI equivalents come from the Clock_by_Rydberg sheet
(`harmonic.pdf`). Because the unit values are regenerated on demand, the
source `units.pdf` deliberately omits them to reduce maintenance after CODATA
revisions. Cell-level deep links into specific PDF pages remain a target for
future refinement.*
