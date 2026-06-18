# Glossary — Universal Unit System (UUS) / Harmonic System

<p align="center">
  <a href="https://suchowan.seesaa.net/article/202602article_6_1.html">
    <img src="pic/VennUGE.png" width="90"
         title="The Overlap That Creates the Harmonic System (click to open blog post)"/>
  </a>
</p>

A reference glossary of units, prefixes, constants, and structural terms used
across [`revised.pdf`](revised.pdf), [`units.pdf`](units.pdf),
[`harmonic.pdf`](harmonic.pdf), and the
[`Eight Quartets`](Eight_Quartets.pdf) diagram.

**Notation:** A semicolon `;` is the duodecimal radix point; `↊` = ten, `↋` = eleven. 
A following `′` or `″` shifts the duodecimal radix point one or two dozenal places (1<font color='royalblue'>;′<sub>±</sub>h</font> = 10;⁻¹ harmon); 
see [myriad.pdf](myriad.pdf) for the general shift notation (`′ ″ ‴ , _` for 1, 2, 3, 4, 8 places). 
Decimal (SI) values use a period `.` as the radix point. 
The identifier of a Harmonic System unit is the **prefix** `±` (formerly the suffix `h`); it is rendered here as <font color='royalblue'><sub>±</sub></font> to keep it subscripted. 
SI equivalents are taken from the *Clock_by_Rydberg* sheet of [`condensed.xlsx`](condensed.xlsx). 

---

## Related Resources

- [README.md](../README.md) — a concise introduction to UUS / the Harmonic System for first-time readers.
- [doc/README.md](README.md) — a summary of `revised.pdf`, told as a human-readable story with abundant diagrams.
- Blog — English posts (those paired with a Japanese version): [suchowan.seesaa.net](https://suchowan.seesaa.net/search?keyword=%3EJapanese%3C) — design rationale and topical essays.

---

## Structural Terms

- **Harmonic System** — the layer designed so that key physical and
  astronomical constants approximate multiples/submultiples of integer powers
  of twelve.
- **Coexistence with SI** — UUS is designed to coexist with SI, not replace
  it; SI conversion factors are stable since the 2019 SI redefinition and
  unaffected by CODATA adjustments.
- **[Quartet structure](https://suchowan.seesaa.net/article/202601article_23_1.html)** — the system organizes units into universal,
  Earth local, and alias quartets (see the *Eight Quartets* diagram).

---

## 1. Base Units (natural)

<p align="center"><em>Universal, Coherent, Base Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes | Wikipedia |
|--------|------|----------|------------|---------------|-------|-----------|
| <font color='royalblue'>rad</font> | [radian](http://hosi.org/cgi-bin/conv.cgi?c=d&m=100f0&d=86&tu=1&tr=10&tm=off&tp=0&tl=0&fu=0&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert)| plane angle | (2/π) arc sin(1) | same as SI<br/>`Ω₁`(cycle) = 2π `rad`,<br/>`Ω₂`(turn) = 4π `sr` = 4π `rad²` | See [univunit-e.pdf](dozenal_com/univunit-e.pdf) pp.16-17 A.2 ‘Mathematical’ Units|  [radian](https://en.wikipedia.org/wiki/Radian) |
| <font color='royalblue'>neper</font> | [neper](http://hosi.org/cgi-bin/conv.cgi?c=fu&m=100f0&d=59&tu=1&tr=10&tm=off&tp=0&tl=0&fu=2&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert) | information and logarithmic quantity | logarithm of Napier's constant | not part of SI | See the note for rad above | [neper](https://en.wikipedia.org/wiki/Neper) |
| <font color='royalblue'><sub>♮</sub>mol</font> | [natural mol](http://hosi.org/cgi-bin/conv.cgi?m=100c0&d=0&fq=1.0000000&frq=12&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | amount of substance | reciprocal Avogadro constant (<font color='royalblue'>N<sub>A</sub>⁻¹</font>) | mol / 602,214,076,000,000,000,000,000 (exact) | When combined with `mol`, `♮` ≡ `3-`; substance must be specified | [Avogadro constant](https://en.wikipedia.org/wiki/Avogadro_constant) ⁻¹ |
| <font color='royalblue'><sub>♮</sub>Ω</font> (<font color='royalblue'>Z<sub>P</sub></font>) | [nohm](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | impedance | natural unit of impedance | 29.9792458 Ω (measured in SI)| vacuum impedance; <font color='royalblue'>αℏ/e<sup>2</sup></font> | [Fine-structure constant](https://en.wikipedia.org/wiki/Fine-structure_constant)(α), [Impedance of free space](https://en.wikipedia.org/wiki/Impedance_of_free_space) × [`rad²`](#5-derived-units--electromagnetic) |

## 2. Base Units (not natural)

<p align="center"><em>Universal, Coherent, Base Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent |
|--------|------|----------|------------|---------------|
| <font color='royalblue'><sub>±</sub>h</font> | [harmon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | length | 100,1700; <font color='royalblue'>Ω<sub>1</sub> / R<sub>∞</sub> </font> | 0.27235220594 m (272.352 mm) |
| <font color='royalblue'><sub>±</sub>n</font> | [nic](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | physical time | 10;<sup>+8</sup> <font color='royalblue'><sub>±</sub>h / c<sub>0</sub></font> | 0.39062511513 s (390.625 ms) |
| <font color='royalblue'><sub>±</sub>J</font> | [harmonic Joule](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | energy | 10;<sup>+26;</sup> <font color='royalblue'>ℏ / <sub>±</sub>n</font> | 64.084556 mJ — overline <font color='royalblue'><sub>±</sub>J̅</font> : equivalent dose (effective Joule) |
| <font color='royalblue'><sub>±</sub>K</font> | [harmonic Kelvin](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=1.0000000&frq=12&fe=0&fu=8&tu=9&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | thermo-dynamic temperature | 10;<sup>-20;</sup> <font color='royalblue'><sub>±</sub>J / K<sub>B</sub></font> | 58.387542 μK (= <font color='royalblue'>10;⁻⁴ °H</font>) |

By successively applying the [defining constants](#6-defining-constants), these base units are defined sequentially in the order <font color='royalblue'><sub>±</sub>h</font> → <font color='royalblue'><sub>±</sub>n</font> → <font color='royalblue'><sub>±</sub>J</font> → <font color='royalblue'><sub>±</sub>K</font>.  
See also the relationships between all units with specific names in [relations.pdf](relations.pdf).

## 3. Derived Units — Geometrical

<p align="center"><em>Universal, Coherent, Derived Category</em></p>

| Prefix | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| - | [steradian](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | solid angle | <font color='royalblue'>rad<sup>2</sup></font> | 1 sr | derived from `rad` (See [univunit-e.pdf](dozenal_com/univunit-e.pdf) p.11 eq.(19))|
| <font color='royalblue'><sub>±</sub>q</font> | [harmonic square](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=4&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | area | square harmon (<font color='royalblue'><sub>±</sub>h<sup>2</sup></font>) | 741.757241 cm²| `q` from Latin *quadrata* |
| <font color='royalblue'><sub>±</sub>c</font> | [harmonic cube](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-1&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | volume | cubic harmon ( <font color='royalblue'><sub>±</sub>h<sup>3</sup></font>) | 20.2019221 dm³ | ≈ 16/3 gallon (since 2/3 gallon ≈ <font color='royalblue'>(½ <sub>±</sub>h)³</font>);<br/>`c` from Latin *cubus* |

The order of “square/cube,” “[minor/major](#9-minor--major-prefixes),” and “[power prefixes](#10-power-prefixes)” determines the exponent of the units. Example : <font color='royalblue'>sub cube</font>(<font color='royalblue'><sub>♭</sub>c</font>) ≈ [0.97 cm³](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=-4&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)

## 4. Derived Units — Dynamical

<p align="center"><em>Universal, Coherent, Derived Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| <font color='royalblue'><sub>±</sub>l</font> | [looloh](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | mass | <font color='royalblue'><sub>±</sub>J /(<sub>±</sub>h/<sub>±</sub>n)<sup>2</sup></font> | 131.829289 g | ≈ 100;<sup>10;</sup> atomic mass unit ― Water or ice H<sub>2</sub>O mass filling a cube of <font color='royalblue'>[(½ harmon)³](pic/Cube.png)</font><br/>See also the atomic mass table in [atomic.pdf](atomic.pdf). |
| <font color='royalblue'><sub>±</sub>W</font> | [harmonic Watt](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | power | <font color='royalblue'><sub>±</sub>J /<sub>±</sub>n</font> | 164.056415 mW | overline <font color='royalblue'><sub>±</sub>W̅</font> ≈115.667212 lumen : luminous flux (effective Watt) |
| <font color='royalblue'><sub>±</sub>N</font> | [harmonic Newton](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=11&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | force | <font color='royalblue'><sub>±</sub>J /<sub>±</sub>h</font> | 235.300301 mN | In practice, gram-force is sometimes used as a force unit instead of the Newton. In parallel, Earth's gravitational force corresponding to one looloh of mass can be expressed as the looloh [gee](#11-earth-local-units--constants) (of Earth) ― <font color='royalblue'><sub>±</sub>l g<sub>E</sub></font> |
| <font color='royalblue'><sub>±</sub>P</font> | [harmonic Pascal](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | pressure | <font color='royalblue'><sub>±</sub>N /<sub>±</sub>h<sup>2</sup></font> | 3.172201 Pa | overline <font color='royalblue'><sub>±</sub>P̅</font> : phon pressure (effective Pascal) |

## 5. Derived Units — Electromagnetic

<p align="center"><em>Universal, Coherent, Derived Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| <font color='royalblue'><sub>±</sub>C</font> | [harmonic / universal Coulomb](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric charge | <font color='royalblue'>(<sub>±</sub>J <sub>±</sub>n / <sub>♮</sub>Ω)<sup>1/2</sup></font>| 28.896578 mC | The prefix `harmonic` (`±`) may be called `universal`, since the universal unit equals the harmonic unit |
| <font color='royalblue'><sub>±</sub>A</font> | [harmonic Ampere](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric current | <font color='royalblue'><sub>±</sub>C /<sub>±</sub>n</font> | 73.975219 mA | electric potential : <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>A</font>, read "[nohm Ampere](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)" (voltage)<br/> magnetic potential : <font color='royalblue'>Ω<sub>2・±</sub>A</font>, read "turn Ampere" |
| <font color='royalblue'><sub>±</sub>E</font> | [harmonic Ørsted](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | field strength | <font color='royalblue'><sub>±</sub>A /<sub>±</sub>h</font> | 271.616 mA/m | electric field strength : <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>E</font><br/>magnetic field strength : <font color='royalblue'>Ω<sub>2・±</sub>E</font> |
| <font color='royalblue'><sub>±</sub>T</font> | [harmonic Tesla](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=9&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | flux density | <font color='royalblue'><sub>±</sub>C /<sub>±</sub>h<sup>2</sup></font> | 11.678991 T / Z<sub>P</sub> | magnetic flux density : <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>T</font><br/>electric flux density : <font color='royalblue'>Ω<sub>2・±</sub>T</font> |

<p align="center">
  <a href="https://gist.github.com/suchowan/5c2f1ca3cfb79b3abb8ae40bbf3a2a5f#3-figure-1--symmetric-placement-of-electromagnetic-quantities">
    <img src="https://raw.githubusercontent.com/suchowan/notes/refs/heads/master/pic/Figure_1.png" width="400"
         title="Relationships among the dimensions of electromagnetic quantities"/>
  </a>
</p>

*Figure 1.* How the electromagnetic quantities relate through ×impedance
(<font color='royalblue'><sub>♮</sub>Ω</font>), ×solid angle(`Ω₂`), ×area, ×time, and ×length. The four named derived units
<font color='royalblue'><sub>±</sub>C</font>,
<font color='royalblue'><sub>±</sub>A</font>,
<font color='royalblue'><sub>±</sub>E</font>,
<font color='royalblue'><sub>±</sub>T</font> occupy four center nodes of this lattice;
every other quantity follows by these operations. 
When context makes the Harmonic System clear, `±` need not be pronounced.

## 6. Defining Constants

<p align="center"><em>Universal Category</em></p>

| Symbol | Name | Quantity | SI equivalent | Constant | Wikipedia |
|--------|------|----------|---------------|----------|-----------|
| <font color='royalblue'>R<sub>∞</sub></font> | [Rydberg](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=87&fq=1.0000000000000&frq=10&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | wave number | 10,973,731.568157 Ω₁/m | the Rydberg constant | [Rydberg constant](https://en.wikipedia.org/wiki/Rydberg_constant) |
| <font color='royalblue'><sub>♮</sub>γ</font> (`c₀`) | [light](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=6&fq=1.00000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | velocity | 299,792,458 m/s (exact) | speed of light in vacuum | [Speed of light](https://en.wikipedia.org/wiki/Speed_of_light) |
| `ħ` | [quantum](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=25&fq=1.000000000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | action | 6.62607015×10<sup>−34</sup> J⋅s / 2π (exact) | quantum of action (reduced Planck constant) | [Planck constant](https://en.wikipedia.org/wiki/Planck_constant) |
| <font color='royalblue'>k<sub>B</sub></font> | [Boltzmann](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=5&fq=1.0000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | entropy | 1.380649×10<sup>−23</sup> J/K (exact) | the Boltzmann constant | [Boltzmann constant](https://en.wikipedia.org/wiki/Boltzmann_constant) |

In the Harmonic System, the values of the Bohr radius (a<sub>B</sub>), the charge (e) and mass (m<sub>e</sub>) of the electron can be determined by measuring only the fine-structure constant (α). In contrast to the SI system, <font color='royalblue'><sub>♮</sub>Ω</font> is the defined quantity, while e is the measured quantity.
- a<sub>B</sub> = α<font color='royalblue'>Ω<sub>1</sub></font> / 4π<font color='royalblue'>R<sub>∞</sub></font> (factor ≈ 12.<sup>-3</sup>)
- e = (α<font color='royalblue'>ℏ/<sub>♮</sub>Ω</font>)<sup>1/2</sup> (factor ≈ 12.<sup>-1</sup>)
- m<sub>e</sub> = 4π<font color='royalblue'>R<sub>∞</sub>ℏ</font> / α<sup>2</sup><font color='royalblue'>Ω<sub>1</sub>c<sub>0</sub></font> (factor ≈ 12.<sup>-5</sup>)

## 7. Supplementary Constants

<p align="center"><em>Universal Category</em></p>

| Symbol | Name | SI equivalent | Constant | Wikipedia |
|--------|------|---------------|----------|-----------|
| `e` | [electron](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=10&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | 1.602176634×10<sup>−19</sup> C (exact) | elementary electric charge | [Elementary charge](https://en.wikipedia.org/wiki/Elementary_charge) |
| <font color='royalblue'><sub>±</sub>mol</font><sub>substance</sub> | [harmonic / universal mol](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=7&fq=1.0000000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 132.00762 mol | with substance name (ex. <font color='royalblue'><sub>±</sub>mol</font><sub>CO₂</sub>) | [Mole (unit)](https://en.wikipedia.org/wiki/Mole_(unit)) |
| <font color='royalblue'>Ω<sub>k</sub></font> | total solid angle of a hypersphere | — | <font color='royalblue'>Ω<sub>k-1</sub></font> = (2π<sup>k/2</sup> / Γ(k/2)) <font color='royalblue'>rad<sup>k-1</sup></font> | [Unit sphere](https://en.wikipedia.org/wiki/Unit_sphere#Volume_and_area) |
| <font color='royalblue'>℧<sub>k</sub></font> (<font color='royalblue'>f<sub>k</sub></font>) | figure | — | logarithm of an integer;<br/><font color='royalblue'>f₁</font>=[bit](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=10&fe=0&fu=4&tu=3&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) ≈ 3 dB, <font color='royalblue'>f₄</font>=nibble, <font color='royalblue'>f₈</font>=byte,<br/><font color='royalblue'>f<sub>z</sub></font>=[figure](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (z = log12./log2),<br/><font color='royalblue'>f<sub>z-2</sub></font> can represent ternary digit.<br/>Alias `f` where `℧` unavailable | — |

See also the physical, material, and astronomical constants in [tables.pdf](tables.pdf).

## 8. Structural Constants

| Symbol | Name | Value / role |
|--------|------|--------------|
| `Ω₀` | — | total solid angle of a hypersphere, `Ω₀ = 2`; fermi component of the [Eq.Ω](../README.md#base-selection-eq%CF%89--constants-approximation) (in `2^n × 12^m`, the `2` is `Ω₀`) |
| `Ω₁` | [cycle](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=86&fq=1.0000000&frq=12&fe=0&fu=3&tu=7&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | `Ω₁` = 2π `rad` |
| `Ω₂` | [turn](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=3&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | `Ω₂` = 4π `sr` = 4π `rad²`<br/>pairs with <font color='royalblue'><sub>♮</sub>Ω</font> as `⟨♮Ω, Ω₂⟩` dual structure in the electromagnetic quantities |
| `ω₁` | Primary Harmonic Ratio | `9/8` (= 90/80). Ratio between one harmonic meter and ... ; links day ↔ <font color='royalblue'><sub>±</sub>n</font>; a major second |
| `ω₂` | Fine Harmonic Ratio | `41/40` (= 82/80). Elementary charge / impedance-derived charge unit; appears in Earth's meridian and ice density; one comma-pair in [53-TET](https://en.wikipedia.org/wiki/53_equal_temperament) (`revised.pdf` Note 49) |

`(ω₁−1)/(ω₂−1) = 5` — corresponds to one black-key sub-division (5 commas) of
the 53-tone equal-tempered keyboard.

## 9. Minor / Major Prefixes

| Prefix | Symbol | Power | Notes |
|--------|--------|-------|-------|
| sub | `♭` | 10;⁻⁴ | `±` omitted when `sub` is present |
| atomic | `-` | 10;⁻⁸ | `±` omitted when `atomic` is present |
| dirac | `∜♯` | 10;⁺¹ | only for [Gravitic System](gravitic.pdf) |
| hyper | `♯` | 10;⁺⁴ | `±` omitted when `hyper` is present |
| cosmic | `+` | 10;⁺⁸ | `±` omitted when `cosmic` is present |

See also blog post '[The Day Musical Symbols Fell Naturally into Place](https://suchowan.seesaa.net/article/202601article_10_1.html)'.

## 10. Power Prefixes

Power prefixes, which represent powers of 12<sup>8</sup>(=[U](#15-scaling--hierarchy)), are used in combination with terms such as “atomic” and “cosmic.”

Example from `revised.pdf` Table 7:  
- the age of the universe : 6; di-cosmic nic ( 6;<sub>2+</sub>n )
- the Planck length : 2; tetra-atomic harmon ( 2;<sub>4-</sub>h )

| Prefix | Power | Prefix | Power |
|--------|-------|--------|-------|
| di- (`2`) | 2nd | penta- (`5`) | 5th |
| ter- (`3`) | 3rd | hexa- (`6`) | 6th |
| tetra- (`4`) | 4th | hepta- (`7`) | 7th |

See also the duodecimal myriad system for pure numbers in [myriad.pdf](myriad.pdf) and blog post '[Design Principles and Unique Implementation](https://suchowan.seesaa.net/article/202605article_11_1.html)'.

## 11. Earth Local Units & Constants

<p align="center"><em>Earth Local Category</em></p>

| Symbol | Name | Definition |
|--------|------|------------|
| <font color='royalblue'>m<sub>E</sub></font> | Earth meridian ([meridian](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=0&fq=1.0000000&frq=12&fe=0&fu=13&tu=1&fp=0&tp=3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | meridian length of the Earth (≑ (ω₂/3) <font color='royalblue'><sub>+</sub>h / Ω₁</font>);<br/>Since one sub cycle (<font color='royalblue'><sub>♭</sub>Ω<sub>1</sub></font>) is 150/144 minutes (plane angle), 1 [meridian sub cycle](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=0&fq=1.0000000&frq=12&fe=0&fu=13&tu=30&fp=-4&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (<font color='royalblue'>m<sub>E♭</sub>Ω<sub>1</sub></font>) ≈ 1.041 metric nautical mile |
| <font color='royalblue'>s<sub>E</sub></font> | Earth solar ([solar](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=2&fq=1.0000000&frq=12&fe=0&fu=14&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | rotation period of the Earth (epoch for SI second: start of year 1900.);<br/>Multiplying the units in “[Calendar Time Units](#12-calendar-time-units)”(unit dimension: plane angle ) by <font color='royalblue'>s<sub>E</sub></font> (unit dimension: physical time  / plane angle ) yields the corresponding physical time |
| <font color='royalblue'>g<sub>E</sub></font> | gee of Earth ([gee](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=18&fq=1.0000000&frq=12&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | gravitational acceleration of the Earth;<br/>Earth's gravitational force corresponding to one looloh of mass can be expressed as the [looloh](#4-derived-units--dynamical) gee (of Earth) ― <font color='royalblue'><sub>±</sub>l g<sub>E</sub></font>, see also [Deep_Structure_Form_and_Emptiness.md](Deep_Structure_Form_and_Emptiness.md#52-case-study-looloh-gee) |
| <font color='royalblue'>T<sub>E</sub></font> | base point of degree H | Earth-local temperature scale = `118,2354; ±K` (≈ −74.36 °C, −101.85 °F); the only deliberately chosen component |
| `°H` | [degree H](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=0.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | difference of thermodynamic temperature from the base point; `0;°H` ↔ `118,2354; ±K` (<font color='royalblue'>T<sub>E</sub></font>), chosen so that `100;°H` matches the boiling point of water, and approximately `61;°H` ↔ 14.°C, `78;°H` ↔ 37.°C<br/>- value of °C ≈ value of `°H` ×(1E;/17;) - 62;44<br/>- value of `°H` ≈ value of °C ×(17;/1E;) + 51;50 |

The gravitational radius of the Earth, <font color='royalblue'>r<sub>E</sub></font>, is not an independent constant; rather, <font color='royalblue'>r<sub>E</sub> = g<sub>E</sub> (m<sub>E</sub> rad / c<sub>0</sub>)<sup>2</sup></font>.

## 12. Calendar Time Units

<p align="center"><em>Earth Local Category</em></p>

| Symbol | Name | Definition |   Figure   |
|--------|------|------------|------------|
| `☼̃` | [year](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.00000000&frq=12&fe=0&fu=23&tu=13&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 365. 31./128. days |  |
| `☽̃` | month | 10;⁻¹ year |  |
| `°̃` | day | 1 Ω₁ | [The calendar time unit structure around day (hexon-ternon)](pic/calendar_time_structure_nodus.png) |
| `′̃` | unitia | 10;⁻¹ day | [27-hour clock (unitia notation)](27-hours.pdf) |
| `″̃` | ditia | 10;⁻² day |  |
| `‴̃` | [tertia](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=8&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ day |  |
| `☆̃` | [nodus](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁻⁷ (1/128.) day | [The natural time scale ladder(the age of the universe - the Planck time)](pic/NaturalTimeScale.png) - see also [blog post](https://suchowan.seesaa.net/article/202501article_17_3.html)|
| `⌬̃` | [hexon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=24&tu=23&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁺⁶ years |  |
| `▽̃` | [ternon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=7&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ nodus |  |

## 13. Social Aliases

| Symbol / Notation | Name | Definition |
|--------|------|------------|
| <font color='royalblue'>mon<sub>country</sub></font> | mon | least-valued currency unit of a country/economic group (ex. 1$ = 84; <font color='royalblue'>mon<sub>us</sub></font>) |
| ;′<font color='royalblue'><sub>±</sub>h</font> | unínoh | 10;⁻¹ harmon = [2.2696 cm](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.89354 inch](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=25&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (≈ 8/9 inch) |
| ;″<font color='royalblue'><sub>±</sub>l</font> | dinól | 10;⁻² looloh = [0.03229 ounce](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=10&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.91548 gram](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)  (≈ 11/12 gram) |
| <font color='royalblue'><sub>-</sub>γ</font> | atol | 10;⁻⁸ c₀ = 1 harmon / nic = 2.509 997 km/h |

Aliases are *interfaces*, not weaknesses. Several social aliases, introduced
independently, necessarily derive their final letter from the corresponding
base unit name (−h from harmon, −l from looloh, −n from nodus) — a convergence
reflecting the system's structural constraints. The optional diacritical mark
“ ́” on unínoh/dinól indicates word stress.

See also the relationship between other legacy units and Harmonic System units in [legacy_units.pdf](legacy_units.pdf).

## 14. Alternative Muse & Goddess Names

Alternative proposal replacing unit names with the names of Muses or Goddesses that share the same initials (`revised.pdf` Note 46).

| Unit | Alternate | Unit | Alternate | Unit | Alternate | Unit | Alternate |
|------|-----------|------|-----------|------|-----------|------|-----------|
| [Ampere](#5-derived-units--electromagnetic) | → [Aoide](https://en.wikipedia.org/wiki/Aoide) | [Boltzmann](https://github.com/suchowan/a_converter/blob/master/doc/glossary.md#6-defining-constants) | → [Bia](https://en.wikipedia.org/wiki/Bia_(mythology)) | [Coulomb](#5-derived-units--electromagnetic) | → [Clio](https://en.wikipedia.org/wiki/Clio) | [dirac](#9-minor--major-prefixes) | → [diana](https://en.wikipedia.org/wiki/Diana_(mythology)) |
| [Ørsted](#5-derived-units--electromagnetic) | → [Erato](https://en.wikipedia.org/wiki/Erato) | [Joule](#2-base-units-not-natural) | → [Juno](https://en.wikipedia.org/wiki/Juno_(mythology)) | [Kelvin](#2-base-units-not-natural) | → [Kalliope](https://en.wikipedia.org/wiki/Calliope) | [neper](#1-base-units-natural) | → [nephe](https://en.wikipedia.org/wiki/Nephele) |
| [Newton](#4-derived-units--dynamical) | → [Nete](https://en.wikipedia.org/wiki/Nete_(mythology)) | [Pascal](#4-derived-units--dynamical) | → [Polym](https://en.wikipedia.org/wiki/Polyhymnia) | [Tesla](#5-derived-units--electromagnetic) | → [Thalia](https://en.wikipedia.org/wiki/Thalia_(Muse)) | [Watt](#4-derived-units--dynamical) | → [Walku](https://en.wikipedia.org/wiki/Valkyrie) |

## 15. Scaling & Hierarchy

The scaling factor **U = 12⁸**(10;<sup>8</sup>) is not chosen for human convenience; it
**emerges** as a dimensionless ratio `u / M = 1;0009060E × 10;⁸` ( `revised.pdf`, p.23 Eq.(17;)) 
between the nucleon rest energy and a typical chemical energy. At this scale:

| Scale | Quantity |
|-------|----------|
| `U⁻³` | rest mass of 1 nucleon |
| `U⁻¹` | rest energy of 1 nucleon (E = mc₀²) |
| `U⁻²` | typical chemical energy (= energy of 1 photon at peak visual sensitivity, 540 THz) |

See also Wikipedia Talk '[Planck_units](https://web.archive.org/web/20250128231044/https:/en.wikipedia.org/wiki/Talk:Planck_units/Archive_3#Other_possible_normalizations)' and blog post '[The Scaling Factor U (= 12^8)](https://suchowan.seesaa.net/article/202605article_29_1.html)'.

---

*Generated from the text layers of `revised.pdf`, `units.pdf`, and
`harmonic.pdf`. SI equivalents come from the Clock_by_Rydberg sheet
(`harmonic.pdf`). Because the unit values are regenerated on demand, the
source `units.pdf` deliberately omits them to reduce maintenance after CODATA
revisions. Cell-level deep links into specific PDF pages remain a target for
future refinement.*
