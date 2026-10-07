# PCSA Academy • Class 11 Computer Science (STBB)
## Unit 1: Computer Systems, Digital Logic Design & Software Engineering
**Publication Quality:** Cambridge / Oxford Standard • STBB 2026 Official Verified Curriculum

---

## Section A: Discrete vs. Continuous Quantities

In physical reality and computational engineering, physical quantities are categorized into two fundamental types based on their mathematical continuity:

### 1. Continuous Quantities
- **Definition:** Physical phenomena that vary smoothly and continuously over a given range, taking an infinite number of possible intermediate values between any two points.
- **Analogy:** A **Ramp** or smooth incline, where elevation changes without step-like breaks.
- **Real-World Examples:** Ambient room temperature ($25.4^{\circ}\text{C}$), fluid pressure, human voice sound waves, speedometer velocity, and time.

### 2. Discrete Quantities
- **Definition:** Quantities that change in distinct, separate, non-continuous steps or counts, possessing countable specific values without fractional intermediate states.
- **Analogy:** A **Staircase**, where a person can stand on step 1 or step 2, but cannot stand on step 1.5.
- **Real-World Examples:** Number of students in a classroom, digital clock seconds display, flip-flop state, number of books on a shelf, and binary logic levels ($0$ or $1$).

```
        CONTINUOUS QUANTITY (RAMP)                  DISCRETE QUANTITY (STAIRCASE)
        
            /  (Infinite intermediate                 +--- Step 3
           /    values possible)                      |
          /                                     +-----+ Step 2
         /                                      |
        /                                 +-----+ Step 1
       /                                  |
      +----------------------------      +----------------------------
```

### Comparative Summary: Discrete vs. Continuous

| Feature / Criteria | Continuous Quantities (Analog) | Discrete Quantities (Digital) |
| :--- | :--- | :--- |
| **Mathematical Nature** | Infinite values within a continuous range | Finite, countable distinct states |
| **Physical Analogy** | Smooth Ramp | Stepped Staircase |
| **Signal Representation** | Continuous Sine Waves | Discrete Square Waves |
| **Noise Susceptibility** | High (degrades with physical interference) | Low (highly immune to electrical noise) |
| **Computational Device** | Mercury Thermometers, Mechanical Clocks | Digital Computers, Microprocessors, Microcontrollers |

---

## Section B: Digital Systems & Signals

A **Digital System** is an electronic system that processes, stores, and transmits discrete binary signals represented by binary digits ($0$ and $1$).

### Binary Representation & Voltage Levels
In CMOS digital integrated circuits, binary states correspond to physical electrical voltage thresholds:
- **Binary 0 (LOW / False):** Electrical ground potential ($0\text{V} - 0.8\text{V}$).
- **Binary 1 (HIGH / True):** Positive supply voltage ($2.4\text{V} - 5.0\text{V}$).

```
   ANALOG SIGNAL (SINE WAVE)                     DIGITAL SIGNAL (SQUARE WAVE)
   
     +5V +    .--.     .--.                        +5V +----+    +----+    +----+ (HIGH = 1)
         |   /    \   /    \                           |    |    |    |    |    |
      0V +--+------+--+------+-->               0V +----+----+----+----+----+----> (LOW = 0)
         | /        \/        \                            T1   T2   T3   T4
    -5V  +`          `         `
```

### Advantages of Digital Systems
1. **High Noise Immunity:** Small electrical disturbances (noise) do not alter the classification of a discrete HIGH or LOW voltage level.
2. **Exact Reproducibility:** Digital data can be duplicated and stored endlessly across flash memory or optical media with zero degradation.
3. **Programmability:** Digital hardware behavior can be dynamically altered using software without changing hardware wiring.

> [!NOTE]
> **Architecture Insight 1**  
> **Analog-to-Digital Conversion (ADC):**  
> Physical real-world input (microphone audio or camera light) passes through an ADC that performs **Sampling** (measuring voltage at discrete time intervals) and **Quantization** (converting amplitude into a binary bit string) to bridge physical reality with digital CPUs.

---

## Section C: Boolean Algebra & Logic Gates

Formulated by English mathematician **George Boole** in 1847, **Boolean Algebra** is a mathematical system operating on binary variables taking values $1$ (True) or $0$ (False).

### Boolean Operator Precedence
When evaluating complex Boolean expressions, operations must be evaluated in the following strict hierarchy:
1. **Parentheses `()`:** Expressions inside brackets are evaluated first.
2. **NOT Operation (`'` or `~`):** Logical negation.
3. **AND Operation (`·` or juxtaposition):** Logical conjunction.
4. **OR Operation (`+`):** Logical disjunction.

> [!IMPORTANT]
> **Exam Alert / Examiner Tip 1**  
> **Precedence Traps:** In the Boolean expression $Y = A + B \cdot C'$, evaluate $C'$ first, then $B \cdot C'$, and finally add $A$. Do NOT evaluate $(A + B)$ first!

### The 7 Primary Logic Gates

#### 1. AND Gate
- **Boolean Expression:** $Y = A \cdot B$
- **Operation:** Output $Y$ is HIGH ($1$) if and only if **all** inputs are HIGH ($1$).

```
  ASCII Symbol:                Truth Table:
   A ---\                      +---+---+-------+
         |---\                 | A | B | Y=A·B |
         |    )--- Y           +---+---+-------+
   B ---/---/                  | 0 | 0 |   0   |
                               | 0 | 1 |   0   |
                               | 1 | 0 |   0   |
                               | 1 | 1 |   1   |
                               +---+---+-------+
```

#### 2. OR Gate
- **Boolean Expression:** $Y = A + B$
- **Operation:** Output $Y$ is HIGH ($1$) if **at least one** input is HIGH ($1$).

```
  ASCII Symbol:                Truth Table:
   A ---\                      +---+---+-------+
         \---\                 | A | B | Y=A+B |
          )   )--- Y           +---+---+-------+
   B ---/---/                  | 0 | 0 |   0   |
                               | 0 | 1 |   1   |
                               | 1 | 0 |   1   |
                               | 1 | 1 |   1   |
                               +---+---+-------+
```

#### 3. NOT Gate (Inverter)
- **Boolean Expression:** $Y = A'$ (or $\bar{A}$)
- **Operation:** Inverts the input state ($0 \to 1$, $1 \to 0$).

```
  ASCII Symbol:                Truth Table:
   A ----|\o--- Y              +---+----+
         |/                    | A | Y=A'|
                               +---+----+
                               | 0 |  1 |
                               | 1 |  0 |
                               +---+----+
```

#### 4. NAND Gate (Universal Gate)
- **Boolean Expression:** $Y = (A \cdot B)'$
- **Operation:** Inverse of AND gate. Output $Y$ is LOW ($0$) only when all inputs are HIGH ($1$).

```
  ASCII Symbol:                Truth Table:
   A ---\                      +---+---+----------+
         |---\o--- Y           | A | B | Y=(A·B)' |
         |    )                +---+---+----------+
   B ---/---/                  | 0 | 0 |    1     |
                               | 0 | 1 |    1     |
                               | 1 | 0 |    1     |
                               | 1 | 1 |    0     |
                               +---+---+----------+
```

#### 5. NOR Gate (Universal Gate)
- **Boolean Expression:** $Y = (A + B)'$
- **Operation:** Inverse of OR gate. Output $Y$ is HIGH ($1$) only when all inputs are LOW ($0$).

```
  ASCII Symbol:                Truth Table:
   A ---\                      +---+---+----------+
         \---\o--- Y           | A | B | Y=(A+B)' |
          )   )                +---+---+----------+
   B ---/---/                  | 0 | 0 |    1     |
                               | 0 | 1 |    0     |
                               | 1 | 0 |    0     |
                               | 1 | 1 |    0     |
                               +---+---+----------+
```

#### 6. XOR Gate (Exclusive-OR)
- **Boolean Expression:** $Y = A \oplus B = A'B + AB'$
- **Operation:** Output $Y$ is HIGH ($1$) if inputs are **different**.

```
  ASCII Symbol:                Truth Table:
   A ---\)\                    +---+---+---------+
           )   )--- Y          | A | B | Y=A⊕B   |
   B ---/-/--/                 +---+---+---------+
                               | 0 | 0 |    0    |
                               | 0 | 1 |    1    |
                               | 1 | 0 |    1    |
                               | 1 | 1 |    0    |
                               +---+---+---------+
```

#### 7. XNOR Gate (Exclusive-NOR)
- **Boolean Expression:** $Y = (A \oplus B)' = AB + A'B'$
- **Operation:** Output $Y$ is HIGH ($1$) if inputs are **identical**.

```
  ASCII Symbol:                Truth Table:
   A ---\)\                    +---+---+---------+
           )   )o--- Y         | A | B | Y=(A⊕B)'|
   B ---/-/--/                 +---+---+---------+
                               | 0 | 0 |    1    |
                               | 0 | 1 |    0    |
                               | 1 | 0 |    0    |
                               | 1 | 1 |    1    |
                               +---+---+---------+
```

> [!IMPORTANT]
> **Exam Alert / Examiner Tip 2**  
> **Universal Gates:** NAND and NOR are called **Universal Gates** because any fundamental logic gate (AND, OR, NOT) or complex digital circuit (adders, multiplexers) can be constructed using *only* NAND or *only* NOR gates.

---

## Section D: Canonical Forms & Karnaugh Maps (K-Maps)

### 1. Canonical Forms
- **Minterm (Sum of Products - SOP):** A product (AND) term containing all variables in true or complemented form. A minterm evaluates to $1$ for a specific combination of inputs (e.g., $m_0 = A'B'C'$). SOP expressions sum these minterms: $Y = \sum m(0, 1, 3)$.
- **Maxterm (Product of Sums - POS):** A sum (OR) term containing all variables in true or complemented form. A maxterm evaluates to $0$ for a specific input combination (e.g., $M_0 = A + B + C$). POS expressions multiply maxterms: $Y = \prod M(2, 4, 6)$.

### 2. Karnaugh Map (K-Map) Principles
A **Karnaugh Map** is a graphical simplification method that minimizes Boolean functions without applying complex algebraic theorems.

#### Gray Code Ordering
Adjacent cells in a K-Map differ by **exactly one binary bit** (Gray Code: `00`, `01`, `11`, `10`). This adjacency allows grouping terms using the Boolean identity $X + X' = 1$.

```
                        3-VARIABLE K-MAP GRID
                        
                             BC
                      00    01    11    10
                    +-----+-----+-----+-----+
                0   | m0  | m1  | m3  | m2  |   (A = 0)
             A      +-----+-----+-----+-----+
                1   | m4  | m5  | m7  | m6  |   (A = 1)
                    +-----+-----+-----+-----+
```

#### Step-by-Step Minimization Rules
1. Map `1`s for all minterms present in the truth table or SOP expression.
2. Group adjacent `1`s into rectangluar groups of sizes equal to powers of two ($1, 2, 4, 8, 16$).
3. Form the largest possible groups (Octets > Quads > Pairs > Singletons).
4. Groups may wrap around outer grid edges (top-to-bottom and left-to-right).
5. Extract simplified terms by keeping variables that remain constant within a group and discarding variables that change state.

---

## Section E: Logisim Evolution Circuit Simulation Guide

**Logisim Evolution (v3.9+)** is an open-source educational graphical CAD software for designing and simulating digital logic circuits.

### System Requirements
- **Runtime:** Java Runtime Environment (JRE / JDK 21+).
- **Cross-Platform:** Runs on Windows, Linux, and macOS.

### GUI Walkthrough
- **Menu Bar:** File, Edit, Project, Simulate (Toggles tick clock and simulation state).
- **Toolbar:**
  - **Poke Tool (Hand Icon `☝`):** Toggles input pin values ($0 \leftrightarrow 1$) during live simulation.
  - **Select Tool (Arrow `↖`):** Moves components and selects wire traces.
  - **Wiring Tool (`+`):** Draws conductive connections between component pins.
- **Canvas:** Central grid area where components are dropped and wired.
- **Attribute Table:** Bottom-left window configuring component properties (e.g., Number of Inputs, Data Bits, Facing Direction).

```
                      LOGISIM EVOLUTION GUI LAYOUT
+-------------------------------------------------------------------------+
| File  Edit  Project  Simulate  Help                                      |
+-------------------------------------------------------------------------+
| [☝ Poke]  [↖ Select]  [+ Wire]  [A Text]  [INPUT Pin]  [OUTPUT Pin]     |
+-------------------+-----------------------------------------------------+
| EXPLORER TREE     | CANVAS GRID                                         |
|  v Wiring         |                                                     |
|  v Gates          |        +-------+                                    |
|    - AND Gate     |  A ---0| AND   |                                    |
|    - OR Gate      |        | Gate  |-----+                              |
|    - NOT Gate     |  B ---0+-------+     |     +-------+                |
|                   |                      +----0| OR    |                |
+-------------------+                            | Gate  |----0 Y (Output)|
| ATTRIBUTE TABLE   |                      C ---0+-------+                |
| Number Inputs: 2  |                                                     |
| Facing: East      |                                                     |
+-------------------+-----------------------------------------------------+
```

### Logisim Wire Color Code Standards

| Wire Color | Physical Simulation State | Meaning / Interpretation |
| :--- | :--- | :--- |
| **Bright Green** | **Logic HIGH (1)** | Active $5\text{V}$ voltage line. |
| **Dark Green** | **Logic LOW (0)** | Ground $0\text{V}$ line. |
| **Blue** | **Unconnected / Floating** | Input pin is unconnected or high-impedance ($Z$). |
| **Grey** | **Multi-bit Bus Wire** | Bundle carrying multiple signal lines. |
| **Red / Orange** | **Error State** | Electrical short circuit or conflicting gate outputs. |

---

## Section F: Software Engineering & SDLC

**Software Engineering** is a systematic, disciplined, and quantifiable approach to the development, operation, and maintenance of software systems.

### The 6 Core Phases of SDLC

```
  1. PLANNING & SRS  --->  2. SYSTEM DESIGN  --->  3. IMPLEMENTATION
  (Feasibility / Docs)      (HLD / LLD / ERD)       (Coding / Git)
                                                          |
                                                          v
  6. MAINTENANCE    <---  5. DEPLOYMENT    <---  4. TESTING
  (Corrective/Adapt)        (Direct/Parallel)      (Unit/UAT)
```

1. **Planning & Requirements Analysis:**
   - Conducts technical, economic, and operational feasibility studies.
   - Deliverable: **Software Requirements Specification (SRS)** document detailing functional and non-functional requirements.
2. **System Design:**
   - Converts requirements into software architecture.
   - High-Level Design (HLD) defines system architecture; Low-Level Design (LLD) defines database ERDs, class diagrams, and flowcharts.
3. **Implementation & Coding:**
   - Translates design specifications into executable code using languages (Python, Dart/Flutter, C++) managed by version control (Git).
4. **Testing & Quality Assurance:**
   - Validates software against SRS specifications to eliminate bugs and vulnerabilities.

### Testing Methodologies Comparison

| Parameter | Black Box Testing | White Box Testing |
| :--- | :--- | :--- |
| **Focus** | Functional testing against inputs/outputs | Code structure, path coverage, and logic branch testing |
| **Code Visibility** | Tester has **no knowledge** of internal source code | Tester has **full visibility** of internal source code |
| **Performed By** | Independent QA Testers & End Users (UAT) | Software Developers & System Architects |

5. **Deployment:** Releasing software to the production environment.
   - **Direct Deployment:** Immediate cutover from old system to new system. High risk.
   - **Phased Deployment:** Gradual module-by-module rollout.
   - **Pilot Deployment:** Released to a small target group before full-scale launch.
   - **Parallel Deployment:** Running old and new systems side-by-side simultaneously. Lowest risk.
6. **Maintenance:**
   - **Corrective:** Fixing discovered bugs and errors.
   - **Adaptive:** Updating software to run on new OS versions or hardware.
   - **Perfective:** Enhancing performance or adding new user features.
   - **Preventive:** Refactoring code to prevent future failures.

---

## Section G: Waterfall vs. Agile Case Studies

### Comparative Summary: Waterfall vs. Agile

| Feature | Waterfall Model | Agile Model (Scrum Framework) |
| :--- | :--- | :--- |
| **Approach** | Linear, sequential phase-by-phase | Iterative and incremental |
| **Flexibility** | Rigid; difficult to change past phases | High; adapts to changing requirements |
| **Customer Involvement**| Heavy at start (SRS) and final handover | Continuous involvement at every Sprint Review |
| **Deliverables** | Single final release at project end | Working software increments every 2–4 week Sprint |
| **Best Suited For** | Well-defined, stable requirement projects | Fast-paced, evolving modern web & mobile apps |

### Real-World Case Studies

#### Case Study 1: Al-Noor Library Management System (Waterfall Model)
- **Context:** An institutional desktop software for cataloging 50,000 library books, tracking issuing dates, and calculating late fines using Python, Tkinter, and SQLite.
- **Why Waterfall Was Chosen:** Requirements (book loan rules, fine rates, catalog attributes) were fixed, well-defined, and regulated by academic library policy.
- **Execution:** SRS created $\to$ DB schema designed $\to$ Code written $\to$ Tested $\to$ Deployed directly to library desktops.

#### Case Study 2: Al-Noor Student Mobile Application (Agile Scrum Model)
- **Context:** A cross-platform student portal built with Flutter and Firebase providing live exam countdowns, push notifications, and video streaming.
- **Why Agile Was Chosen:** Student feedback required rapid feature updates, UI tweaks, and continuous additions of new solved exercise modules.
- **Execution:** Worked in 2-week **Sprints**. User stories prioritized in the **Product Backlog** $\to$ Daily Standups $\to$ Working app build released to Play Store at the end of every sprint.

> [!NOTE]
> **Architecture Insight 2**  
> **Scrum Framework Terminology:**  
> - **Product Backlog:** Prioritized list of all desired features and user stories.
> - **Sprint (2–4 weeks):** Time-boxed iteration cycle yielding a working increment.
> - **Daily Standup (15 mins):** Daily alignment meeting answering: What did I do yesterday? What will I do today? What blockers exist?

> [!IMPORTANT]
> **Exam Alert / Examiner Tip 3**  
> **Deployment Method Risk:** Board questions often ask: *"Which deployment strategy carries the lowest operational risk?"* The answer is **Parallel Deployment**, because if the new software fails, the old system is still running live to prevent data loss or downtime.
