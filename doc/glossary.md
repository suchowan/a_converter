# Glossary — Universal Unit System (UUS) / Harmonic System

<p align="center">
  <a href="https://suchowan.seesaa.net/article/202602article_6_1.html">
    <img src="pic/VennUGE.png" width="90"
         title="The Overlap That Creates the Harmonic System (click to open blog post)"/>
  </a>
</p>

A reference glossary of units, prefixes, constants, and structural terms used
across [`revised.pdf`](revised.pdf), [`units.pdf`](units.pdf),
[`harmonic.pdf`](harmonic.pdf)(the *units* and *Clock_by_Rydberg* sheet of [`condensed.xlsx`](condensed.xlsx)), and the [`Eight Quartets`](Eight_Quartets.pdf) diagram.

**Notation:** A semicolon `;` is the duodecimal radix point; `↊` = ten, `↋` = eleven. 
A following `′` or `″` shifts the duodecimal radix point one or two dozenal places (1<font color='royalblue'>;′<sub>±</sub>h</font> = 10;⁻¹ harmon); 
see [myriad.pdf](myriad.pdf) for the general shift notation (`′ ″ ‴ , _` for 1, 2, 3, 4, 8 places). 
Decimal (SI) values use a period `.` as the radix point. 
The identifier of a Harmonic System unit is the **prefix** `±` (formerly the suffix `h`); it is rendered here as <font color='royalblue'><sub>±</sub></font> to keep it subscripted. 
SI equivalents are taken from `harmonic.pdf`. 

---

## How to Read This Glossary

- **Harmonic System** — The most important implementation of the Universal Unit System (UUS):  
  the layer designed so that key physical and astronomical constants approximate multiples/submultiples of integer powers of twelve.
- **Coexistence with SI** — UUS is designed to coexist with SI, not replace
  it; SI conversion factors are stable since the 2019 SI redefinition and
  unaffected by CODATA adjustments.
- **Quartet structure** — the system organizes units into universal,
  Earth local, and alias quartets ([*Eight Quartets diagram*](https://raw.githubusercontent.com/suchowan/a_converter/master/doc/Eight_Quartets.pdf)). See also [Three‑Dimensional Arrangement of the Quartets](https://suchowan.seesaa.net/article/202601article_23_1.html).
- **Names are conveniences, not boundaries** — a table entry with a special name 
  (e.g. <font color='royalblue'><sub>±</sub>N</font>) marks a combination the system found useful enough to name.  
  Any other combination of base/derived units remains valid (especially [§3](#3-derived-units--geometrical), e.g. <font color='royalblue'>rad/<sub>±</sub>n</font>); 
  absence of a name is not absence of permission.  
See also [The Semantic Network](AI_Oriented_Documents/On_Naming_Conventions.md#7-the-semantic-network) and [Constellation Model and UUS](AI_Oriented_Documents/Constellation_Model_and_UUS.md).

---

## Related Resources

- [README.md](../README.md) — a concise introduction to UUS / the Harmonic System for first-time readers.
- [doc/README.md](README.md) — a summary of `revised.pdf`, told as a human-readable story with abundant diagrams.
- [doc/Discussion on the UUS and the Harmonic System](Discussion_on_the_UUS_and_the_Harmonic_System.md) — a discursive overview of the system's design principles, structure, historical development, and relationship to SI, TGM, and Planck units.
- Blog — English posts (those paired with a Japanese version): [suchowan.seesaa.net](https://suchowan.seesaa.net/search?keyword=%3EJapanese%3C) — design rationale and topical essays.

---

## 1. Base Units (natural)

<p align="center"><em>Universal, Coherent, Base Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes | Wikipedia |
|--------|------|----------|------------|---------------|-------|-----------|
| <font color='royalblue'>rad</font> | [radian](http://hosi.org/cgi-bin/conv.cgi?c=d&m=100f0&d=86&tu=1&tr=10&tm=off&tp=0&tl=0&fu=0&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert)| plane angle | (2/π) arc sin(1) | same as SI | See [univunit-e.pdf](dozenal_com/univunit-e.pdf) pp.16-19 A.2,A.3.<br/>`Ω₁`(cycle) = 2π `rad`,<br/>`Ω₂`(turn) = 4π `sr` = 4π `rad²` |  [radian](https://en.wikipedia.org/wiki/Radian) |
| <font color='royalblue'>neper</font> | [neper](http://hosi.org/cgi-bin/conv.cgi?c=fu&m=100f0&d=59&tu=1&tr=10&tm=off&tp=0&tl=0&fu=2&fr=12&fm=off&fp=0&fl=0&fq=1.0000000&fe=0&c=Convert) | information and logarithmic quantity | logarithm of Napier's constant | not part of SI | See the note for rad above.<br/>In the context of particle decay:<br/>- mean lifetime = physical time / neper<br/>- half-life = physical time / [bit](#7-supplementary-constants)<br/>These are two expressions of a **single** concept: the slowness of decay.| [neper](https://en.wikipedia.org/wiki/Neper) |
| <font color='royalblue'><sub>♮</sub>mol</font> | [natural mol](http://hosi.org/cgi-bin/conv.cgi?m=100c0&d=0&fq=1.0000000&frq=12&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | count (amount of substance and events) | reciprocal Avogadro constant (<font color='royalblue'>N<sub>A</sub>⁻¹</font>) | mol / 6.02214076×10<sup>23</sup> (exact) | When combined with `mol`, `♮` ≡ `3-`; substance must be specified.<br/>As a pure count of entities, it **also** measures events: e.g. activity (SI becquerel:[Bq](http://hosi.org/cgi-bin/conv.cgi?m=100e0&d=0&fq=1.0000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) corresponds to <font color='royalblue'><sub>♮</sub>mol/<sub>±</sub>n</font> (decays per nic). | [Avogadro constant](https://en.wikipedia.org/wiki/Avogadro_constant) ⁻¹ |
| <font color='royalblue'><sub>♮</sub>Ω</font> (<font color='royalblue'>Z<sub>P</sub></font>) | [nohm](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | impedance | natural unit of impedance | 29.9792458 Ω (measured in SI as α) | vacuum impedance; <font color='royalblue'>αℏ/e<sup>2</sup></font> | [Fine-structure constant](https://en.wikipedia.org/wiki/Fine-structure_constant)(α), [Impedance of free space](https://en.wikipedia.org/wiki/Impedance_of_free_space) × [`rad²`](#5-derived-units--electromagnetic) |

## 2. Base Units (not natural)

<p align="center"><em>Universal, Coherent, Base Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent |
|--------|------|----------|------------|---------------|
| <font color='royalblue'><sub>±</sub>h</font> | [harmon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | length | 100,1700; <font color='royalblue'>Ω<sub>1</sub> / R<sub>∞</sub> </font> | 0.27235220594 m (272.352 mm, ≈ 8 / 9 foot) |
| <font color='royalblue'><sub>±</sub>n</font> | [nic](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | physical time | 10;<sup>+8</sup> <font color='royalblue'><sub>±</sub>h / c<sub>0</sub></font> | 0.39062511513 s (390.625 ms, ≈ 25. / 64. s) |
| <font color='royalblue'><sub>±</sub>J</font> | [harmonic Joule](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=2&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | energy | 10;<sup>+26;</sup> <font color='royalblue'>ℏ / <sub>±</sub>n</font> | 64.084556 mJ — overline <font color='royalblue'><sub>±</sub>J̅</font> : equivalent dose (effective Joule) |
| <font color='royalblue'><sub>±</sub>K</font> | [harmonic Kelvin](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=1.0000000&frq=12&fe=0&fu=8&tu=9&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | thermo-dynamic temperature | 10;<sup>-20;</sup> <font color='royalblue'><sub>±</sub>J / K<sub>B</sub></font> | 58.387542 μK (= <font color='royalblue'>10;⁻⁴ [°H](#12-earth-local-units--constants)</font>) |

By successively applying the [defining constants](#6-defining-constants), these base units are defined sequentially in the order <font color='royalblue'><sub>±</sub>h</font> → <font color='royalblue'><sub>±</sub>n</font> → <font color='royalblue'><sub>±</sub>J</font> → <font color='royalblue'><sub>±</sub>K</font>.  
See also the relationships between all units with special names in [relations.pdf](relations.pdf).

## 3. Derived Units — Geometrical

<p align="center"><em>Universal, Derived Category</em></p>

| Prefix | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| - | [*steradian*](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | solid angle | <font color='royalblue'>rad<sup>2</sup></font> | 1 sr | derived from `rad` (See [univunit-e.pdf](dozenal_com/univunit-e.pdf) p.11 eq.(19)) |
| - | [*cycle / nic*](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=24&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | frequency and revolution | <font color='royalblue'>Ω<sub>1</sub>/<sub>±</sub>n</font> | 2.56000 Hz | not coherent |
| <font color='royalblue'><sub>±</sub>q</font> | [*harmonic square*](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=4&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | area | square harmon (<font color='royalblue'><sub>±</sub>h<sup>2</sup></font>) | 741.757241 cm²| `q` from Latin *quadrata* |
| <font color='royalblue'><sub>±</sub>c</font> | [*harmonic cube*](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-1&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | volume | cubic harmon ( <font color='royalblue'><sub>±</sub>h<sup>3</sup></font>) | 20.2019221 dm³ | ≈ 16/3 gallon (since 2/3 gallon ≈ <font color='royalblue'>(½ <sub>±</sub>h)³</font>);<br/>`c` from Latin *cubus* |

*Note on Prefix:* In <font color='royalblue'><sub>±</sub>c</font> or <font color='royalblue'><sub>±</sub>q</font>, the "c" (cubic) and "q" (quadrata) function as dimensional prefixes modifying the base harmon unit, rather than standalone unit symbols.

The order of “square/cube,” “[minor/major](#10-minor--major-prefixes),” and “[power prefixes](#11-power-prefixes)” determines the exponent of the units. Example : <font color='royalblue'>sub cube</font>(<font color='royalblue'><sub>♭</sub>c</font>) ≈ [0.97 cm³](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=-4&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)

---

## 4. Derived Units — Dynamical

<p align="center"><em>Universal, Coherent, Derived Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| <font color='royalblue'><sub>±</sub>l</font> (<font color='royalblue'><sub>±</sub>ℓ</font>) | [looloh](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | mass | <font color='royalblue'><sub>±</sub>J /(<sub>±</sub>h/<sub>±</sub>n)<sup>2</sup></font> | 131.829289 g | ≈ 100;<sup>10;</sup> atomic mass unit ― see also the atomic mass table in [atomic.pdf](atomic.pdf).<br/>Water or ice H<sub>2</sub>O mass filling a cube of <font color='royalblue'>[(½ harmon)³](pic/Cube.png)</font> ≈ 1 <font color='royalblue'><sub>±</sub>mol</font> - approximately 100; <font color='royalblue'><sub>±</sub>l</font> / 2<sup>3</sup> (molecular weight of water 18 = 100; / 2<sup>3</sup>), adding 1 <font color='royalblue'><sub>±</sub>J</font> of heat to 1 <font color='royalblue'><sub>±</sub>l</font> of water raises its temperature by 2 <font color='royalblue'><sub>±</sub>K</font> ([specific heat of water](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=6&fq=1.0000000&frq=10&fe=0&fu=4&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) ≈ 0;6045 <font color='royalblue'><sub>±</sub>J/<sub>±</sub>l<sub>±</sub>K</font>, `revised.pdf` Note 53; cf. the [thermodynamic calorie](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=6&fq=1.0000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert)) |
| <font color='royalblue'><sub>±</sub>W</font> | [harmonic Watt](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=10&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | power | <font color='royalblue'><sub>±</sub>J /<sub>±</sub>n</font> | 164.056415 mW | overline <font color='royalblue'><sub>±</sub>W̅</font> ≈115.667212 lumen : luminous flux (effective Watt) |
| <font color='royalblue'><sub>±</sub>N</font> | [harmonic Newton](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=11&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | force | <font color='royalblue'><sub>±</sub>J /<sub>±</sub>h</font> | 235.300301 mN | In practice, gram-force is sometimes used as a force unit instead of the Newton. In parallel, Earth's gravitational force corresponding to one looloh of mass can be expressed as the looloh [gee](#12-earth-local-units--constants) (of Earth) ― <font color='royalblue'><sub>±</sub>l g<sub>E</sub></font>.<br/>Two examples of ["atomic"/"cosmic" prefixes](#10-minor--major-prefixes) in force:<br/>- the [Coulomb repulsion](pic/Force-comparison-2.png) between two 1 <font color='royalblue'><sub>±</sub>C</font> charges 1 <font color='royalblue'><sub>±</sub>h</font> apart is exactly 1 <font color='royalblue'><sub>+</sub>N</font> (cosmic Newton);<br/>- the [gravitational attraction](pic/Force-comparison-1.png) between 7 <font color='royalblue'><sub>±</sub>l</font> and 5 <font color='royalblue'><sub>±</sub>l</font> masses 1 <font color='royalblue'><sub>±</sub>h</font> apart is approximately 1 <font color='royalblue'><sub>-</sub>N</font> (atomic Newton). |
| <font color='royalblue'><sub>±</sub>P</font> | [harmonic Pascal](http://hosi.org/cgi-bin/conv.cgi?m=100a0&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | pressure | <font color='royalblue'><sub>±</sub>N /<sub>±</sub>h<sup>2</sup></font> | 3.172201 Pa | overline <font color='royalblue'><sub>±</sub>P̅</font> : phon pressure (effective Pascal)<br/>At the thermodynamic temperature of the triple point of water (273.16 K), the pressure at which the ideal-gas molar volume becomes exactly 100;<font color='royalblue'><sub>±</sub>h<sup>3</sup>/<sub>±</sub>mol</font> is 1;6975 <font color='royalblue'><sub>♯</sub>P</font> (103061.2 Pa, 47./30. <font color='royalblue'><sub>♯</sub>P</font>), `revised.pdf` Note 52 |

## 5. Derived Units — Electromagnetic

<p align="center"><em>Universal, Coherent, Derived Category</em></p>

| Symbol | Name | Quantity | Definition | SI equivalent | Notes |
|--------|------|----------|------------|---------------|-------|
| <font color='royalblue'><sub>±</sub>C</font> | [harmonic / universal Coulomb](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric charge | <font color='royalblue'>(<sub>±</sub>J <sub>±</sub>n / <sub>♮</sub>Ω)<sup>1/2</sup></font> | 28.896578 mC | The prefix `harmonic` (`±`) may be called `universal`, since the universal unit equals the harmonic unit |
| <font color='royalblue'><sub>±</sub>A</font> | [harmonic Ampere](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=3&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric current | <font color='royalblue'><sub>±</sub>C /<sub>±</sub>n</font> | 73.975219 mA | electric potential : <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>A</font>, read "nohm Ampere" (voltage)<br/> magnetic potential : <font color='royalblue'>Ω<sub>2・±</sub>A</font>[,](#10-minor--major-prefixes) read "turn Ampere" |
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

The following units do not have special names, 
but they are listed here to explicitly indicate their SI equivalents.  
The <font color='royalblue'><sub>♮</sub>Ω</font>-<font color='royalblue'>Ω<sub>2</sub></font> pair eliminates the need to give special names to these quantities.

| Name | Quantity | Definition | SI equivalent | Name | Quantity | Definition | SI equivalent |
|------|----------|------------|---------------|------|----------|------------|---------------|
| [*nohm Ampere*](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric potential(voltage) | <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>A</font> | 2.217721 V | [*nic / nohm*](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=12&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | capacitance | <font color='royalblue'><sub>±</sub>n/<sub>♮</sub>Ω</font> | 13.029851 mF |
| [*nohm Ørsted*](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=5&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | electric field strength | <font color='royalblue'><sub>♮</sub>Ω<sub>±</sub>E</font> | 8.142843 V/m | [*nic nohm*](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=14&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | inductance | <font color='royalblue'><sub>±</sub>n<sub>♮</sub>Ω</font> | 11.710646 H |

## 6. Defining Constants

<p align="center"><em>Universal Category</em></p>

| Symbol | Name | Quantity | SI equivalent | Constant | Wikipedia |
|--------|------|----------|---------------|----------|-----------|
| <font color='royalblue'>R<sub>∞</sub></font> | [Rydberg](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=87&fq=1.0000000000000&frq=10&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | wave number | 10,973,731.568157 Ω₁/m | the Rydberg constant | [Rydberg constant](https://en.wikipedia.org/wiki/Rydberg_constant) |
| <font color='royalblue'><sub>♮</sub>γ</font> (`c₀`) | [light](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=6&fq=1.00000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | velocity | 299,792,458 m/s (exact) | speed of light in vacuum | [Speed of light](https://en.wikipedia.org/wiki/Speed_of_light) |
| `ħ` | [quantum](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=25&fq=1.000000000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | action | 6.62607015×10<sup>−34</sup> J⋅s / 2π (exact) | quantum of action (reduced Planck constant) | [Planck constant](https://en.wikipedia.org/wiki/Planck_constant) |
| <font color='royalblue'>k<sub>B</sub></font> | [Boltzmann](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=5&fq=1.0000000&frq=10&fe=0&fu=4&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | entropy | 1.380649×10<sup>−23</sup> J/K (exact) | the Boltzmann constant | [Boltzmann constant](https://en.wikipedia.org/wiki/Boltzmann_constant) |

In the Harmonic System, the values of the Bohr radius (a<sub>B</sub>), the charge (e) and mass (m<sub>e</sub>) of the electron can be determined by measuring only the fine-structure constant ([α](#8-structural-constants)). In contrast to the SI system, <font color='royalblue'><sub>♮</sub>Ω</font> is the defined quantity, while e is the measured quantity.
- a<sub>B</sub> = α<font color='royalblue'>Ω<sub>1</sub></font> / 4π<font color='royalblue'>R<sub>∞</sub></font> (factor ≈ 12.<sup>-3</sup>) ≈ <font color='royalblue'>1;′<sub>-</sub>h</font>
- e = (α<font color='royalblue'>ℏ/<sub>♮</sub>Ω</font>)<sup>1/2</sup> (factor ≈ 12.<sup>-1</sup>) ≈ <font color='royalblue'>1;<sub>2-</sub>C</font>
- m<sub>e</sub> = 4π<font color='royalblue'>R<sub>∞</sub>ℏ</font> / α<sup>2</sup><font color='royalblue'>Ω<sub>1</sub>c<sub>0</sub></font> (factor ≈ 12.<sup>-5</sup>) ≈ <font color='royalblue'>1;‴<sub>3-</sub>l</font>

## 7. Supplementary Constants

<p align="center"><em>Universal Category</em></p>

| Symbol | Name | SI equivalent | Constant | Wikipedia |
|--------|------|---------------|----------|-----------|
| `e` | [electron](http://hosi.org/cgi-bin/conv.cgi?m=100b0&d=0&fq=1.0000000&frq=10&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) | 1.602176634×10<sup>−19</sup> C (exact) | elementary electric charge | [Elementary charge](https://en.wikipedia.org/wiki/Elementary_charge) |
| <font color='royalblue'><sub>±</sub>mol</font><sub>substance</sub> | [harmonic / universal mol](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=7&fq=1.0000000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 132.00762 mol | with substance name (ex. <font color='royalblue'><sub>±</sub>mol</font><sub>CO₂</sub>) | [Mole (unit)](https://en.wikipedia.org/wiki/Mole_(unit)) |
| <font color='royalblue'>Ω<sub>k</sub></font> | [total solid angle of a hypersphere](#details-on-the-total-solid-angle-of-a-hypersphere) | — | <font color='royalblue'>Ω<sub>k-1</sub></font> = (2π<sup>k/2</sup> / Γ(k/2)) <font color='royalblue'>rad<sup>k-1</sup></font> | [Unit sphere](https://en.wikipedia.org/wiki/Unit_sphere#Volume_and_area) |
| <font color='royalblue'>℧<sub>k</sub></font> (<font color='royalblue'>f<sub>k</sub></font>) | figure | — | logarithm of an integer<br/><font color='royalblue'>℧<sub>k</sub></font> = log (2<sup>k</sup>) = k · log 2;<br/><font color='royalblue'>℧₁</font>=[bit](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=10&fe=0&fu=4&tu=3&fp=0&tp=0&fm=off&tm=off&fr=10&tr=10&fl=0&tl=0&c=Convert) ≈ 3 dB, <font color='royalblue'>℧<sub>4</sub></font>=nibble, <font color='royalblue'>℧<sub>8</sub></font>=byte,<br/><font color='royalblue'>℧<sub>z</sub></font>=[figure](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=59&fq=1.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (z = log12./log 2).<br/>Alias `f` where <font color='royalblue'>℧</font> unavailable | — |

℧ (without subscript) denotes ℧<sub>1</sub> = log 2 (bit) — the working unit elected for the baseless logarithm ([univunit-e.pdf](dozenal_com/univunit-e.pdf) App. A.2), the suffix '1' being the omitted default, as is customary elsewhere in this notation. Since ℧<sub>k</sub> = k · log 2 is linear in k, subscripts compose algebraically with the exponent of 2: e.g. the base-3 digit is ℧<sub>z-2</sub> (z = log 12./log 2, as above), because subscript arithmetic and the arithmetic of the baseless logarithm's exponent coincide.

See also the physical, material, and astronomical constants in [tables.pdf](tables.pdf).

---

## 8. Structural Constants

### Structural Constants Characterizing UUS / Harmonic System

These are all pure numbers characterizing UUS / Harmonic System.

| Symbol | Name | Value / role |
|--------|------|--------------|
| `ω₀` | *Trivial Harmonic Ratio* | `1/1` — too trivial to have a use, but paradoxically, it could be said to appear throughout UUS / Harmonic System; a **perfect unison**  (`revised.pdf` Note 20) |
| `ω₁` | *(Primary) Harmonic Ratio* | `9/8` (= 90/80). Ratio between the [international foot](../README.md#2-a-musical-bridge-to-the-human-scale) and 1 <font color='royalblue'><sub>±</sub>h</font> ; links 10;<sup>5</sup><font color='royalblue'><sub>±</sub>n</font> ↔ day ; a **major second**  — the origin of the name "Harmonic System" |
| `ω₂` | *Fine Harmonic Ratio* | `41/40` (= 82/80). Elementary charge / impedance-derived charge unit (12α<sup>1/2</sup>=41.00378/40.);<br/>appears in [Earth's meridian and ice density](../README.md#notes); one comma-pair in [53-TET](https://en.wikipedia.org/wiki/53_equal_temperament) (`revised.pdf` Note 50) |
| `α` | [*Fine Structure Constant*](https://en.wikipedia.org/wiki/Fine-structure_constant) | <font color='royalblue'><sub>♮</sub>Ωe<sup>2</sup>/ℏ</font> =  0.0072973525643 ≈ 1/137.035999177 (measured in both SI and Harmonic System) |

`(ω₁−1)/(ω₂−1) = 5` — corresponds to two black-key sub-division (5 commas) of
the 53-tone equal-tempered keyboard.  

### Details on the total solid angle of a hypersphere

From the [Supplementary Constants](#7-supplementary-constants) section, broken down by prefix k.

| Symbol | Name | Quantity | Value / role |
|--------|------|----------|--------------|
| `Ω₀` | — | pure number | total solid angle of a hypersphere, `Ω₀ = 2`; fermi component of the [Eq.Ω](../README.md#base-selection-eq%CF%89--constants-approximation) (in `2^n × 12^m`, the `2` is `Ω₀`)<br/>See also [essay: why AI resonates with Ω₀ = 2](AI_Oriented_Documents/AI_Resonance_with_Omega0_An_Essay.md). |
| `Ω₁` | [*cycle*](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=86&fq=1.0000000&frq=12&fe=0&fu=3&tu=7&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | plane angle | `Ω₁` = 2π `rad` ― a full rotation in 2D |
| `Ω₂` | [*turn*](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=85&fq=1.0000000&frq=12&fe=0&fu=3&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | solid angle | `Ω₂` = 4π `sr` = 4π `rad²` ― a full rotation in 3D ([sweeping all 3D directions](https://gist.github.com/suchowan/5c2f1ca3cfb79b3abb8ae40bbf3a2a5f#4-figure-2--geometric-interpretation-of-magnetic-potential))<br/>pairs with <font color='royalblue'><sub>♮</sub>Ω</font> as `⟨♮Ω, Ω₂⟩` dual structure in the electromagnetic quantities |

## 9. Scaling & Hierarchy

The scaling factor **U = 12⁸**(10;<sup>8</sup>) is not chosen for human convenience; it
**emerges** as a dimensionless ratio `u / M = 1;0009060↋ × 10;⁸` ( `revised.pdf`, p.23 Eq.(17;)) 
between the nucleon rest energy and a typical chemical energy. At this scale:

| Scale | Quantity |
|-------|----------|
| [<font color='royalblue'>U<sup>+2</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=2&fq=0.501002&frq=10&fe=0&fu=25&tu=0&fp=0&tp=0&fm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) | half the age of the solar system |
| [<font color='royalblue'>U<sup>+1</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=0&fq=3.0000000&frq=12&fe=0&fu=13&tu=0&fp=0&tp=0&fm=off&tm=off&fr=12&tr=12&fl=0&tl=0&c=Convert) | [Light](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=6&fq=1.0000000&frq=10&fe=0&fu=4&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) travels 3 times meridian length of the Earth in 1 nic |
| <font color='royalblue'>U<sup>0</sup></font> |human scale |
| <font color='royalblue'>U<sup>-1</sup></font> | rest energy of 1 nucleon (E = mc₀²) |
| [<font color='royalblue'>U<sup>-2</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=9&fq=1.0000000&frq=10&fe=0&fu=15&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) | typical chemical energy (= energy of 1 photon at peak visual sensitivity, 540 THz); also matches the [electron charge](http://hosi.org/cgi-bin/conv.cgi?m=110b0&d=0&fq=1.0000000&frq=10&fe=0&fu=6&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) in this scale's units |
| [<font color='royalblue'>U<sup>-3</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=3&fq=1.0000000&frq=10&fe=0&fu=6&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) | rest mass of 1 nucleon |
| [<font color='royalblue'>U<sup>-4</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=0&fq=0.5000000&frq=10&fe=0&fu=6&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) | half the Planck length |
| [<font color='royalblue'>U<sup>-5</sup></font>](http://hosi.org/cgi-bin/conv.cgi?m=11080&d=2&fq=0.5000000&frq=10&fe=0&fu=28&tu=0&fp=0&tp=0&fm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) | half the Planck time |

See also Wikipedia Talk '[Planck_units](https://en.wikipedia.org/wiki/Talk:Planck_units/Archive_3#Other_possible_normalizations)'([archive](https://web.archive.org/web/20250128231044/https://en.wikipedia.org/wiki/Talk:Planck_units/Archive_3#Other_possible_normalizations)) and blog post '[The Scaling Factor U (= 12^8)](https://suchowan.seesaa.net/article/202605article_29_1.html)'.

## 10. Minor / Major Prefixes

When several prefixes combine, they are read — and written as a subscript — in the order 
`(cosmic | atomic)` then `(hyper | dirac | sub)`, optionally preceded by a [power prefix](#11-power-prefixes). 
The subscript mirrors this reading order.

Example from `revised.pdf` Table 7:  
- Tera Byte : cosmic hyper bit ( 1;<sub>+♯</sub>℧<sub>1</sub> ), because 2<sup>43.</sup> ≈ 12.<sup>12.</sup>

| Prefix | Symbol | Power | Notes |
|--------|--------|-------|-------|
| cosmic | `+` | 10;⁺⁸ | `±` omitted when `cosmic` is present |
| hyper | `♯` | 10;⁺⁴ | `±` omitted when `hyper` is present |
| *dirac* | `∜♯` | 10;⁺¹ | only for [Gravitic System](gravitic.pdf), see also [dirac.md](dirac.md) |
| sub | `♭` | 10;⁻⁴ | `±` omitted when `sub` is present |
| atomic | `-` | 10;⁻⁸ | `±` omitted when `atomic` is present |

See also blog post '[The Day Musical Symbols Fell Naturally into Place](https://suchowan.seesaa.net/article/202601article_10_1.html)'.

The interpunct '・' may be inserted at any junction where subscript boundaries could blur 
(e.g. [Ω<sub>2・±</sub>A](#5-derived-units--electromagnetic), or between a numeral and a prefixed unit); 
it carries only its ordinary multiplicative meaning and is never required; when both neighbors are subscripts, 
the interpunct is set as a subscript as well (a separator shares the typographic level of what it separates).

## 11. Power Prefixes

Power prefixes, which represent powers of 12<sup>8</sup>(=[U](#9-scaling--hierarchy)), are used in combination with terms such as “atomic” and “cosmic.”

Example from `revised.pdf` Table 7:  
- the age of the universe : 6; di-cosmic nic ( 6;<sub>2+</sub>n )
- the Planck length : 2; tetra-atomic harmon ( 2;<sub>4-</sub>h )

|  Power | Prefix |
|--------|--------|
| 0th | do not use 'cosmic/atomic' itself |
| 1st | omit the prefix and use 'cosmic/atomic' on its own |
| 2nd | di- (`2`) |
| 3rd | ter- (`3`) |
| 4th | tetra- (`4`) |
| 5th | penta- (`5`) |
| 6th | hexa- (`6`) |
| 7th | hepta- (`7`) |

The following diagram summarizes the duodecimal myriad naming system used for pure numbers.

<p align="center">
    <img src="pic/myriad.png" width="600"
         title="the duodecimal myriad system for pure numbers"/>
</p>

 See also blog post '[Design Principles and Unique Implementation](https://suchowan.seesaa.net/article/202605article_11_1.html)'.

---

## 12. Earth Local Units & Constants

<p align="center"><em>Earth Local Category</em></p>

| Symbol | Name | Definition |
|--------|------|------------|
| <font color='royalblue'>m<sub>E</sub></font> | Earth meridian ([meridian](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=0&fq=1.0000000&frq=12&fe=0&fu=13&tu=1&fp=0&tp=3&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | meridian length of the Earth (≑ (ω₂/3) <font color='royalblue'><sub>+</sub>h / Ω₁</font>);<br/>Since one sub cycle (<font color='royalblue'><sub>♭</sub>Ω<sub>1</sub></font>) is 150/144 minutes (plane angle), 1 [meridian sub cycle](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=0&fq=1.0000000&frq=12&fe=0&fu=13&tu=30&fp=-4&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (<font color='royalblue'>m<sub>E♭</sub>Ω<sub>1</sub></font>) ≈ 1.041 nautical mile — see also [Case Study](Deep_Structure_Form_and_Emptiness.md#53-case-study-bridging-angular-and-linear-measure) |
| <font color='royalblue'>s<sub>E</sub></font> | Earth solar ([solar](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=2&fq=1.0000000&frq=12&fe=0&fu=14&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | rotation period of the Earth (24×60×60 s / <font color='royalblue'>Ω₁</font> at the SI-second epoch: start of 1900);<br/>Multiplying the units in “[Calendar Time Units](#13-calendar-time-units)” (unit dimension: plane angle ) by <font color='royalblue'>s<sub>E</sub></font> (unit dimension: physical time / plane angle ) yields the corresponding physical time  — see also [Case Study](Deep_Structure_Form_and_Emptiness.md#54-case-study-light-solar-tertia) |
| <font color='royalblue'>g<sub>E</sub></font> | gee of Earth ([gee](http://hosi.org/cgi-bin/conv.cgi?m=100f0&d=18&fq=1.0000000&frq=12&fe=0&fu=5&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)) | gravitational acceleration of the Earth;<br/>Earth's gravitational force corresponding to one looloh of mass can be expressed as the [looloh](#4-derived-units--dynamical) gee (of Earth) ― <font color='royalblue'><sub>±</sub>l g<sub>E</sub></font>, see also [Case Study](Deep_Structure_Form_and_Emptiness.md#52-case-study-looloh-gee) |
| <font color='royalblue'>T<sub>E</sub></font> | base point of degree H | Earth-local temperature scale = `118,2354; ±K` (≈ −74.36 °C, −101.85 °F); the only deliberately chosen component |
| `°H` | [*degree H*](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=0.0000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | difference of thermodynamic temperature from the base point; `0;°H` ↔ `118,2354; ±K` (<font color='royalblue'>T<sub>E</sub></font>), chosen so that `100;°H` matches the boiling point of water, and approximately `61;°H` ↔ 14.°C, `78;°H` ↔ 37.°C, an interval of 1 `°H` = 10;<sup>+4</sup><font color='royalblue'><sub>±</sub>K</font> ≈ 1.210724 °C ≈ 2.179303 °F<br/>- value of °C ≈ value of `°H` ×(1↋;/17;) - 62;44<br/>- value of `°H` ≈ value of °C ×(17;/1↋;) + 51;50<br/>Example (near room temperature): 18. °C ≈ 64. °F ≈ 64; `°H` (more strictly: [18.000 °C](http://hosi.org/cgi-bin/conv.cgi?m=10090&d=0&fq=18.0000000&frq=10&fe=0&fu=1&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert) = 64.400 °F ≈ 64;351 `°H`) |

The gravitational radius of the Earth, <font color='royalblue'>r<sub>E</sub></font>, is not an independent constant; rather, <font color='royalblue'>r<sub>E</sub> = g<sub>E</sub> (m<sub>E</sub> rad / c<sub>0</sub>)<sup>2</sup></font>.

## 13. Calendar Time Units

<p align="center"><em>Earth Local Category</em></p>

The symmetrical equation [Eq.α](../README.md#origin-selection-eq%CE%B1--calendar-symmetric-approximation) (year / half-day ≈ 3⁺⁶ + 3⁺¹×2⁻¹ − 2⁻⁶) 
yields the GCD and LCM of the year and the half-day as nodus and hexon respectively.  
The Earth-Local Calendar Time System is built from these units.

| Symbol | Name | Definition | Notes | Figure |
|--------|------|------------|-------|--------|
| `⌬̃` | [hexon](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=24&tu=23&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁺⁶ years | [LCM](https://en.wikipedia.org/wiki/Least_common_multiple) of year and half-day<br/> ≈ 10;<sup>+6</sup> nodus | |
| `☼̃` | [year](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.00000000&frq=12&fe=0&fu=23&tu=13&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 365. 31./128. days | 365. days 5 h 48. m 45. s | |
| `☽̃` | └*month* | 10;⁻¹ year | |  |
| `°̃` | day | 1 <font color='royalblue'>Ω₁</font> | | [The calendar time unit structure around day (hexon-ternon)](pic/calendar_time_structure_nodus.png) |
| `′̃` | ├*unitia* | 10;⁻¹ day | | [27-hour clock (unitia notation)](27-hours.pdf) |
| `″̃` | ├*ditia* | 10;⁻² day | |  |
| `‴̃` | └[*tertia*](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=8&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ day | | |
| `▽̃` | ┌[*ternon*](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=7&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 10;⁻³ nodus | also 2⁻⁷ (1/128.) tertia<br/>If [coordinated](https://en.wikipedia.org/wiki/Coordinated_Universal_Time), 1 solar ternon = 1 nic |  |
| `☆̃` | [nodus](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=2&fq=1.0000000&frq=12&fe=0&fu=6&tu=1&fp=0&tp=0&fm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) | 2⁻⁷ (1/128.) day | [GCD](https://en.wikipedia.org/wiki/Greatest_common_divisor) of year and half-day | [The natural time scale ladder(the age of the universe - the Planck time)](pic/NaturalTimeScale.png) - see also [blog post](https://suchowan.seesaa.net/article/202501article_17_3.html)|

The four units listed in [`Eight_Quartets.pdf`](Eight_Quartets.pdf) — with the Name in roman — were chosen so that no two share a ratio that is a power of 12 (cf. **Calendar Time**: nodus, day, year, hexon).  
See also Chinese-character aliases for East Asian communities proposed in [this post](https://suchowan.seesaa.net/article/202501article_25.html).

## 14. Social Aliases

| Symbol / Notation | Name | Definition |
|--------|------|------------|
| <font color='royalblue'>mon<sub>country</sub></font> | mon | least-valued currency unit of a country/economic group (ex. 1$ = 84; <font color='royalblue'>mon<sub>us</sub></font>, 84<sub>12</sub>=100<sub>10</sub>) |
| ;′<font color='royalblue'><sub>±</sub>h</font> | unínoh | 10;⁻¹ harmon = [2.2696 cm](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.89354 inch](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=0&fq=0%3B10000000&frq=12&fe=0&fu=0&tu=25&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) (≈ 8/9 inch) |
| ;″<font color='royalblue'><sub>±</sub>l</font> | dinól | 10;⁻² looloh = [0.03229 ounce](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=10&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [0.91548 gram](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=0%3B010000000&frq=12&fe=0&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert)  (≈ 11/12 gram) |
| <font color='royalblue'><sub>-</sub>γ</font> | atol | 10;⁻⁸ c₀ = 1 harmon / nic = [2.51000 km/h](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=12&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) = [1.55964 mile/h](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=6&fq=1.0000000&frq=12&fe=0&fu=0&tu=22&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) |

Aliases are *interfaces*, not weaknesses. Several social aliases, introduced
independently, necessarily derive their final letter from the corresponding
base unit name (−h from harmon, −l from looloh, −n from nodus) — a convergence
reflecting the system's structural constraints. The optional diacritical mark
“ ́” on unínoh/dinól indicates word stress.

See also the relationship between other legacy units and Harmonic System units in [legacy_units.pdf](legacy_units.pdf).

## 15. Alternative Muse & Goddess Names

Alternative proposal replacing unit names with the names of a dozen Muses or Goddesses that share the same initials (`revised.pdf` Note 47).

| Unit | Alternate | Unit | Alternate | Unit | Alternate | Unit | Alternate |
|------|-----------|------|-----------|------|-----------|------|-----------|
| [Ampere](#5-derived-units--electromagnetic) | → [Aoide](https://en.wikipedia.org/wiki/Aoide) | [*Boltzmann*](#6-defining-constants) | → [Bia](https://en.wikipedia.org/wiki/Bia_(mythology)) | [Coulomb](#5-derived-units--electromagnetic) | → [Clio](https://en.wikipedia.org/wiki/Clio) | [*dirac*](#10-minor--major-prefixes) | → [diana](https://en.wikipedia.org/wiki/Diana_(mythology)) |
| [Ørsted](#5-derived-units--electromagnetic) | → [Erato](https://en.wikipedia.org/wiki/Erato) | [Joule](#2-base-units-not-natural) | → [Juno](https://en.wikipedia.org/wiki/Juno_(mythology)) | [Kelvin](#2-base-units-not-natural) | → [Kalliope](https://en.wikipedia.org/wiki/Calliope) | [*neper*](#1-base-units-natural) | → [nephe](https://en.wikipedia.org/wiki/Nephele) |
| [Newton](#4-derived-units--dynamical) | → [Nete](https://en.wikipedia.org/wiki/Nete_(mythology)) | [Pascal](#4-derived-units--dynamical) | → [Polym](https://en.wikipedia.org/wiki/Polyhymnia) | [Tesla](#5-derived-units--electromagnetic) | → [Thalia](https://en.wikipedia.org/wiki/Thalia_(Muse)) | [Watt](#4-derived-units--dynamical) | → [Walku](https://en.wikipedia.org/wiki/Valkyrie) |

*Italics*: Terms that are **not** adapted from existing metric unit names

---

*Generated from the text layers of `revised.pdf`, `units.pdf`, and `harmonic.pdf`.
SI equivalents come from `harmonic.pdf`. Because the unit values are regenerated on demand, 
the source `units.pdf` deliberately omits them to reduce maintenance after CODATA revisions. 
Cell-level deep links into specific PDF pages remain a target for future refinement.*

---

<p align="center">
  Official entry: <a href="http://dozenal.com">http://dozenal.com</a>
</p>

