# On Naming Conventions and Dimensional Integrity

### Why Naming All Derived Units Undermines Unit Systems

## 1. The Controversy

A proposal: Name all derived units systematically as:
**[System Name] + [Quantity Name] + "Unit"**

Examples:
- "Universal Length Unit"
- "Universal Time Unit"
- "Universal Velocity Unit"
- "Universal Force Unit"

This appears systematic, but introduces fundamental problems.

## 2. The Four Structural Critiques

### A. Obscured Dimensional Composition

**Problem:** When every derived quantity receives a distinct name, 
the dimensional structure becomes invisible.

**Example:**
- SI: velocity = m/s
  - Composition visible: length/time
  - Dimensional check: straightforward
  
- Concept-name approach: velocity = "Universal Velocity Unit"
  - Composition hidden
  - Dimensional check: requires memorization

**Impact:** Dimensional analysis as a verification tool is weakened.

### B. Cognitive Overload

**Problem:** Every quantity concept requires memorization of its 
unit name, with no structural relationships to aid memory.

Examples of units requiring distinct names:
- velocity, acceleration, jerk
- force, energy, power
- momentum, angular momentum
- torque, pressure, stress
- ...and hundreds more

**SI approach:** Minimal named units (~20 derived units with special names)
**Concept-name approach:** Unlimited proliferation

### C. Similar Names for Related Concepts

**Problem:** Related quantities have similar concept names, leading 
to similar unit names.

Example:
- velocity → "velocity unit"
- acceleration → "acceleration unit"  
- angular velocity → "angular velocity unit"
- angular acceleration → "angular acceleration unit"

Abbreviations become confusing.

**SI approach:** Structural composition creates natural distinctions:
- m/s, m/s², rad/s, rad/s²

### D. Ambiguity for Multiple Natural Units

**Problem:** Some quantities have multiple natural unit choices.

Example: Angular measure
- Full circle (360°)
- Radian (arc length / radius)

"Universal Angle Unit" → Which one?

**SI approach:** Distinct names (degree, radian, cycle) or 
structural notation.

## 3. The SI Principle: Quantity System Determines Unit System

From the **SI Brochure (Section 1.1)**:

> "To establish a unit system, it is necessary first to establish 
> a system of quantities, including a set of equations relating 
> those quantities... because the equations between quantities 
> determine the equations between units."  
> *—SI Brochure, 9th edition (2019, updated 2022)*[^si9]

This principle also appears in the **8th edition** with essentially the same wording.[^si8]

**Key insight:** Quantity relationships define unit relationships.

Example: Area = Length × Width

This equation determines that:
- Unit of area = (unit of length)²

The quantity relationship *creates* the unit structure.

### Coherent Unit Systems

A coherent system preserves these relationships without arbitrary 
numerical factors.

If we wrote: Area = 2 × Length × Width

The unit of area would be different (triangle-based rather than 
square-based).

**The quantity system's structure is encoded in the unit system's structure.**

## 4. The Harmonic Approach

The Harmonic System follows SI's principle:

**Minimal base units:**
- Length, Mass, Time, Impedance

**Derived units:**
- Expressed structurally (compositionally)
- Not given independent concept names
- Structure visible in nomenclature

**Selective naming:**
- Practical units may receive names for convenience
- But structural composition remains primary
- Names do not obscure dimensional relationships

## 5. Why This Issue Persists

**Engineers and experimentalists:**
- Use dimensional analysis daily
- Immediately see the cost of obscured structure

**Those with less calculation experience:**
- Prioritize naming intuition
- May not experience the practical burden

This is experiential, not intellectual.

---

## 6. Semantic Integration: When Unit Names *Are* Dimensional Analysis

A key feature of the Harmonic System—absent from both SI and 
concept-name approaches—is **Semantic Integration**:

> **Unit names function simultaneously as natural-language expressions  
> and as dimensional operators.**

### Illustrative Example: Structural Naming for Force

**Semantic level:**
- **[mass unit]** = base unit for mass
- **[acceleration unit]** = base unit for acceleration

**Dimensional analysis:**

$$\text{[mass unit]} \times \text{[acceleration unit]} = [M] \times [LT^{-2}] = [MLT^{-2}] = \text{force}$$

The unit name encodes the dimensional formula.

**Concrete implementation:**  
In the Harmonic System, one such construction is *looloh gee*:
- **looloh** = mass unit
- **gee** = acceleration unit (specifically, standard gravitational acceleration)

*Note: While pedagogically effective, this particular example uses 
an Earth-local constant. For examples involving only universal 
constants and geometric necessity, see 
[Deep_Structure_Form_and_Emptiness.md](../Deep_Structure_Form_and_Emptiness.md), Section 5.3.*

### Why This Approach Matters

- No memorization of abstract labels like "force unit"
- No opaque eponyms like "newton" that hide structure
- No tautological concept names
- **The dimensional structure is visible in the name itself**

### Comparison

| Approach | Example | Structural Transparency | Learning Burden |
|---------|---------|-------------------------|-----------------|
| **Concept-name** | "force unit" | ❌ Hidden | High (memorize all) |
| **SI eponym** | "newton" | ❌ Obscured | Medium (memorize ~20) |
| **Harmonic structural** | compositional | ✅ Explicit | Low (learn base + rules) |

### The Core Principle

Semantic Integration preserves the **two-layer architecture**  
(quantity system → unit system) while making the dimensional 
mapping transparent through nomenclature.

It is the opposite of naming every derived unit:  
**It reduces the number of independent names while increasing 
structural clarity.**

---

## 7. The Semantic Network

The author's 2012 blog post offers a profound analogy:

> "If you describe the location of a convenience store by saying 
> it's next to the post office, and the post office is next to 
> the convenience store, that's circular and unhelpful.
>
> But if you describe many facilities' relationships—hospital, 
> city hall, school—a map of the city emerges.
>
> **Individual relationships accumulate to define meaning (semantics).**"

*Note: This quote is translated from the author's 2012 Japanese 
blog post "[コヒレント(その1)](https://suchowan.seesaa.net/article/201207article_17.html)" 
(Coherent Unit Systems, Part 1).*

**The core insight:** Just as describing many facilities' locations 
creates a city map, individual quantity relationships (F=ma, E=Fd, 
P=E/t...) accumulate to define the meaning of each unit.

The original post discusses how the SI principle—"equations between 
quantities determine equations between units" (SI Brochure, Section 1.1)—
creates semantic meaning through the accumulation of structural relationships.

*(A complete English translation of this foundational blog post is planned 
for future inclusion in this repository.)*

---

This is precisely how unit systems work:
- Individual quantity relationships (F = ma, E = Fd, P = E/t...)
- Accumulate to define the meaning of each unit
- The structure IS the semantics

Naming every derived quantity obscures this semantic network.

## Conclusion

The proposal to name all derived units systematically:
- Obscures dimensional composition
- Creates cognitive overload
- Generates ambiguity
- Violates the principle that quantity relationships determine 
  unit relationships

**The Harmonic System preserves structural visibility while 
maintaining clarity—following SI's foundational principle.**

## References

- **Author's Blog Posts:**
  - [May 2020: Critique of Concept-Based Naming](https://suchowan.seesaa.net/article/202005article_5_1.html)
  - [January 2015: Early Discussion](https://suchowan.seesaa.net/article/201501article_4_1.html)
  - [July 2012: Coherent Unit Systems, Part 1](https://suchowan.seesaa.net/article/201207article_17.html)

- **Related Documentation:**
  - [Deep_Structure_Form_and_Emptiness.md](../Deep_Structure_Form_and_Emptiness.md) (Section 5: Semantic Integration)
  - [Attention.md](Attention.md) (Perceiving hidden structure)

---

***As one AI collaborator noted: "Now is not the time to persuade—it is time to quietly demonstrate a working system." This document serves as that demonstration.***

[^si9]: SI Brochure, 9th edition (2019, updated 2022), Section 1.1.  
[^si8]: SI Brochure, 8th edition (2006), Section 1.1.
