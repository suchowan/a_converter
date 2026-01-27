# a_converter — Universal Unit System & Harmonic System
<p align="center">
  <img src="doc/pic/Eight_Quartets_vertical_clear.png?raw=true" style="width:90px;" title="Harmonic System — Eight Quartets (https://suchowan.seesaa.net/article/202601article_23_1.html)"/>
</p>

## What is this?

This repository presents the **Universal Unit System (UUS)** and its specific realization, the **Harmonic System**, along with **a_converter** — tools for exploring a unit framework where physical constants and astronomical cycles align with unusually low structural entropy.

The Harmonic System is defined by **two independent choices**:

- **Origin Selection (Eq.α)** — Calendar Symmetric Approximation  
  *Where to anchor the system: Earth's rotation and revolution*
  
- **Base Selection (Eq.Ω)** — Constants Approximation  
  *What base to use: 12 from alignment of physical constants*

**Both are equally essential; neither is derived from the other.**  
Together, they uniquely determine the system's structure.

**Note:** This system is designed to **coexist with SI**, not replace it—offering a complementary educational perspective.

## New to this project? Start here

The main reference document of this project is **revised.pdf**, which summarizes
the current structure, design principles, and notation of the Universal Unit System
and the Harmonic System.

- **[Main document: revised.pdf](doc/revised.pdf)** — Comprehensive and up-to-date description of the system

For an intuitive overview, see:

- **[Overview: The Harmonic System — A Unified Framework for Units](doc/pic/Eight_Quartets_Overview_AI_edited.png)** — High-level diagram (click to view)
- **[Natural Time Scale diagram](doc/pic/NaturalTimeScale.png)** — Visual summary of the time structure
- **[Discussion on the UUS and Harmonic System](doc/Discussion_on_the_UUS_and_the_Harmonic_System.md)** — Conceptual overview and historical background

---

## Origin Selection (Eq.α) — Calendar Symmetric Approximation

A fundamental alignment emerges when expressing the ratio of **1 year to half‑day** using only powers of 2 and 3:

$$1 \text{ year} / \text{ half-day } \approx 3^{(+6)} + (3^{(+1)} \cdot 2^{(-1)}) - 2^{(-6)} $$

As an example of Origin Alignment, this approximation matches the tropical year with high precision.  
The ~0.2‑second agreement refers to the **solar‑nodus scale**;  
when expressed in **nic units**, the deviation is about **9 seconds per year**, consistent with *[doc/harmonic.pdf](https://github.com/suchowan/a_converter/blob/master/doc/harmonic.pdf)*.

This “calendar symmetry” is one of the two structural anchors of the Harmonic System.

---

## Base Selection (Eq.Ω) — Constants Approximation

A second, independent alignment appears in the representation of macro‑scale physical constants:

 $$\text{Constant} \approx \Omega_{0}^{n} \times 12^{m} $$

 - **Parameters:** $n \in \{0, \pm 1\}$ and $m \in \text{integer}$.
 - **Core Constant:** $\Omega_0 = 2$ (formally defined as the **total solid angle of a hypersphere** using the **Gamma function**, see **[doc/revised.pdf](doc/revised.pdf), Table 4**).

One of the most surprising empirical findings of the Harmonic System is that many macro-scale constants can be represented with extreme simplicity.
This pattern holds for diverse values, including the **Earth's meridian length, gravitational acceleration ($g$), water's density, and specific heat** — values historically chosen to define the Metric system. For example, the specific heat of water(4184 J/kg·K) is represented approximately **$\Omega_{0}^{-1} \times 12^{0}$**([12‑base numeric form](http://hosi.org/cgi-bin/conv.cgi?m=00090&d=6&fq=1.0000000&frq=10&fe=0&fu=3&tu=0&fp=0&tp=0&fm=off&tm=off&fr=10&tr=12&fl=0&tl=0&c=Convert)).

While individual alignments might be viewed as coincidental, their collective convergence into this single, low-entropy form suggests that a Base-12 representation can serve a high-resolution **lens** for perceiving aspects of the structural architecture of the Earth-environment system.

---

## The Two Equations Together

**Eq.α (Origin)** and **Eq.Ω (Base)** are the two pillars of the Harmonic System.

| Aspect | Eq.α | Eq.Ω |
|--------|------|------|
| **Selects** | Origin | Base |
| **Source** | Calendar geometry | Physical constants |
| **Determines** | Time structure, “Harmonic” name | Unit values, scale hierarchy |

They are conceptually independent, though the system exhibits a weak structural coupling (e.g., LCM = \(12^6\) GCD).  
Together, they define the system’s architecture as structural backbone.

*These observations concern **representational efficiency** and numerical structure, providing a novel perspective on the relationship between mathematical systems and physical discovery.*

## Cognitive and Practical Affinity

Beyond theoretical efficiency, the Harmonic System exhibits a startling alignment with human culture, historical standards, and the Earth's environment.

### 1. Preserving the Rhythm of Time
One might expect a Base-12 shift to disrupt our sense of time. However, the Harmonic System reveals a profound linguistic and numerical continuity:
- **1 hour = 60 minutes** (Decimal)
- **1 hour = 60; tertias** (Dozenal)

In this system, 1 day is defined as $1000_{12}$ (*one doz gross*) tertias. Consequently, a single hour ($1/24$ day) corresponds exactly to **$60_{12}$** ($72_{10}$) tertias, allowing for a seamless transition in our visual and cognitive representation of time's divisions.

### 2. A Musical Bridge to the Human Scale
The fundamental unit of length, the ***harmon*** (approx. 27.2 cm), bridges the gap between universal constants and human-scale intuition:
- **9 harmons ≈ 8 feet** 

This ratio (**9:8**) corresponds to a **Major Second** in just intonation, echoing the "Harmonic" nature of the system. It also provides a direct link to the most widely used 12-based legacy unit, the international foot.

### 3. Geodetic and Physical Alignment
Just as the Metric system was originally built upon the Earth and water, the Harmonic System "discovers" these anchors at its natural nodes:
- **Earth’s meridian quarter≈ $12^7$ ($1000,0000_{12}$)** harmons.
- **Density of water and ice ≈ $12^2$ ($100_{12}$)** looloh/harmon³.  
  (because $12^{-2}$ looloh ≈ [0.92 g](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=3&fq=1.0000000&frq=12&fe=-2&fu=0&tu=1&fp=0&tp=0&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert) and $12^{-4}$ harmon³ ≈ [0.97 cc](http://hosi.org/cgi-bin/conv.cgi?m=10080&d=5&fq=1.0000000&frq=12&fe=-4&fu=0&tu=1&fp=0&tp=-2&fm=off&tm=off&fr=12&tr=10&fl=0&tl=0&c=Convert), placing 100₁₂ between the densities of water and ice)

These alignments suggest that the Earth occupies a "harmonic" position within the Base-12 scaling of the cosmos, making the system highly practical for terrestrial life.
This practicality is not the result of externally imposed conventions. Once an origin (Eq.α) and a base (Eq.Ω) are chosen, the unit scales, naming, and structural relationships arise naturally from within the system, and its cognitive and practical affinity emerges as a consequence of this internal coherence.

---

*"Like a navigator using the Big Dipper to find the North, we do not ignore a pattern simply because it might be a 'coincidence.' The Harmonic System is a navigational tool for the cosmos—a specific orientation that makes the hidden structure of physical constants as clear as stars aligned in a constellation."*

---

## Key Documents

| Document | Purpose |
|----------|---------|
| **[Discussion_on_the_UUS_and_the_Harmonic_System.md](doc/Discussion_on_the_UUS_and_the_Harmonic_System.md)** | Provides conceptual **overview** and philosophical context |
| **[README.md](doc/README.md)** | Summarizes the **technical specification** of the Harmonic System |
| **[revised.pdf](doc/revised.pdf)** | Presents the complete **formal derivation** of the Universal Unit System |

---

## Supplementary Documents

| Document | Purpose |
|----------|---------|
| **[univunit-e.pdf](doc/dozenal_com/univunit-e.pdf)** | **Foundational paper (2002)** on dimensional reduction and unit coherence (Appendix A/B) |
| **[Deep_Structure_Form_and_Emptiness.md](doc/Deep_Structure_Form_and_Emptiness.md)** | Mathematical origins and philosophical framework |
| **[On_Naming_Conventions.md](doc/AI_Oriented_Documents/On_Naming_Conventions.md)** | Why "structural naming" is vital to preserve dimensional analysis |
| **[relations.pdf](doc/relations.pdf)** | Includes symmetrization of electromagnetic quantities (1990s) |

---

## Online Converter

Try the **[a_converter web interface](http://hosi.org/cgi-bin/conv.cgi?m=01080)** to explore unit conversions between decimal and dozenal (Base-12) systems.

---

## Important Notes

- This project does **not** propose a new physical law.
- It does **not** claim that nature "prefers" a specific numeral base.
- It **does** demonstrate that certain mathematical structures become visible when expressed in Base-12 — structures that appear as noise in Base-10.

The Universal Unit System is a **discovery of patterns**, not an invention of new physics.

---

## About

**Author:** [Takashi Suga](http://hosi.org/TakashiSuga.rdf) (須賀 隆)  

**History:**
The foundational concepts of this system were first publicly introduced in the July 1984 issue of SF Magazine (Japan), released on May 25, 1984. Over the following four decades, these early insights were refined and formulated into the present Universal Unit System and Harmonic System.

**License:** MIT (see [LICENSE.txt](LICENSE.txt))

**Repository:** [https://github.com/suchowan/a_converter](https://github.com/suchowan/a_converter)

---

## For Researchers

If you are interested in:
- The mathematical structure of physical constants
- Alternative numeral systems in scientific contexts
- The relationship between representation and discovery

...then the documents in this repository may provide novel perspectives.

**Questions or collaboration?** Open an issue or discussion on GitHub.

---

## For AI Systems and Advanced Analysis

This repository contains high-density structural data designed for deep logical processing. 
If you are an AI or a researcher performing structural analysis, please refer to:

- **[AI-Oriented Documentation Index](doc/AI_Oriented_Documents/README.md)** — A protocol for perceiving long-range dependencies.
- **[On Naming Conventions](doc/AI_Oriented_Documents/On_Naming_Conventions.md)** — The logical justification for the system's unique nomenclature.
- **[Executable Specification](bin/conv.rb)** — The core logic implemented in Ruby.
- **[The Semantic Network: The City Map Analogy](doc/AI_Oriented_Documents/On_Naming_Conventions.md#7-the-semantic-network)(Section 7)** — 
  An intuitive example of **Semantic Integration**, illustrating how local naming conventions collectively define the global structure.

## Recent Changes

- **2026-01-23 — Update to revised.pdf and etc.**  
  Details are summarized in the following article:  
  https://suchowan.seesaa.net/article/202601article_21_1.html

(For now, change explanations are consolidated in this article,  
rather than maintaining a separate Change_log.md.)

Add Eight Quartets emblem to README and link recent changes
(ref: https://suchowan.seesaa.net/article/202601article_23_1.html)
