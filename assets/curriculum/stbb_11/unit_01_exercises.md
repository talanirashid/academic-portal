# PCSA Academy • Class 11 Computer Science (STBB)
## Unit 1: Solved Board Exercises & Model Solutions
**Publication Quality:** Standard Model Answers Aligned with Sindh Textbook Board Marking Schemes

---

## Part A: Conceptual Short Answer Questions (10 Questions)

### Q1: Differentiate between continuous and discrete quantities with real-life examples.
- **Continuous Quantities:**
  - Smooth, uninterrupted values that can take an infinite number of intermediate states within a range.
  - *Real-life Example:* Room temperature ($26.35^{\circ}\text{C}$), human height, and automobile speed.
- **Discrete Quantities:**
  - Distinct, separate, countable values with no fractional intermediate states.
  - *Real-life Example:* Number of students in a classroom (e.g., 35 students), score in a quiz, and digital clock digits.

---

### Q2: Why are digital signals preferred over analog signals in modern computing?
- **High Noise Immunity:** Small electrical fluctuations do not corrupt distinct HIGH ($1$) or LOW ($0$) threshold levels.
- **Zero Loss Replication:** Digital data can be stored, transmitted, and copied endlessly with absolute fidelity.
- **Programmable Processing:** Digital signals can be manipulated using software logic without altering physical hardware circuits.

---

### Q3: Prove why NAND and NOR gates are called "Universal Gates".
- **Definition:** A Universal Gate can construct all basic logic operations (AND, OR, NOT) without requiring any other gate type.
- **NAND Proof:**
  - $\text{NOT}(A) = (A \cdot A)'$
  - $\text{AND}(A, B) = ((A \cdot B)')'$
  - $\text{OR}(A, B) = (A' \cdot B')'$
- **NOR Proof:**
  - $\text{NOT}(A) = (A + A)'$
  - $\text{OR}(A, B) = ((A + B)')'$
  - $\text{AND}(A, B) = (A' + B')'$

---

### Q4: Explain the difference between XOR and XNOR using their truth tables and logic symbols.
- **XOR Gate (Exclusive-OR):**
  - *Boolean Expression:* $Y = A \oplus B = A'B + AB'$
  - *Output Behavior:* Output is HIGH ($1$) when inputs are **different**.
- **XNOR Gate (Exclusive-NOR):**
  - *Boolean Expression:* $Y = (A \oplus B)' = AB + A'B'$
  - *Output Behavior:* Output is HIGH ($1$) when inputs are **identical**.

```
  XOR GATE:                             XNOR GATE:
  A ---\)\                              A ---\)\
          )   )--- Y (Diff inputs = 1)          )   )o--- Y (Same inputs = 1)
  B ---/-/--/                           B ---/-/--/
```

---

### Q5: What is the Gray code sequence in a 3-variable K-Map, and why is it used instead of standard binary?
- **Gray Code Sequence:** `00 -> 01 -> 11 -> 10` along adjacent K-Map columns.
- **Single-Bit Change Rule:** Adjacent Gray code values differ by **exactly one bit**.
- **Boolean Simplification Advantage:** Ensures adjacent grid cells satisfy adjacency ($X + X' = 1$), allowing algebraic term elimination when grouping 1s.

---

### Q6: In Logisim Evolution, what do blue, grey, and orange wire colors indicate during simulation?
- **Blue Wire:** Floating / Unconnected wire carrying an unknown or high-impedance state ($Z$).
- **Grey Wire:** Multi-bit bus line bundling multiple signal wires together.
- **Orange / Red Wire:** Conflict / Error state caused by electrical short circuits or multiple gates driving opposing logic levels ($0$ and $1$) onto the same line.

---

### Q7: Differentiate between Black Box Testing and White Box Testing.
- **Black Box Testing:**
  - Evaluates software functionality purely against SRS input/output specifications.
  - Performed by QA testers and end-users without access to internal source code.
- **White Box Testing:**
  - Evaluates internal code execution paths, logic branches, and code security.
  - Performed by software developers using source code inspection.

---

### Q8: List and briefly describe the four types of software maintenance.
1. **Corrective Maintenance:** Fixing bugs, crashes, and logic errors discovered after release.
2. **Adaptive Maintenance:** Modifying software to maintain compatibility with new OS releases or hardware upgrades.
3. **Perfective Maintenance:** Enhancing performance, UI responsiveness, or adding requested new features.
4. **Preventive Maintenance:** Refactoring code and updating documentation to prevent future bugs.

---

### Q9: Why was the Waterfall model selected for the Al-Noor Library Management System instead of Agile?
- **Stable Requirements:** Library rules, book issuing policies, and late fine calculation formulas were fixed and well-defined.
- **Low Change Probability:** Institutional desktop software requires no frequent feature additions after installation.
- **Predictable Milestones:** Clear sequential phases allowed institutional management to approve progress step-by-step.

---

### Q10: Define a Sprint, User Story, and Product Backlog in the Agile Scrum framework.
- **Sprint:** A time-boxed iteration cycle (typically 2–4 weeks) resulting in a working, testable software build increment.
- **User Story:** A short, plain-language description of a desired feature written from the end-user's perspective (*"As a student, I want to view my date sheet so that I can plan my study schedule"*).
- **Product Backlog:** An ordered, prioritized master list of all features, user stories, and bug fixes required for the software project.

---

## Part B: Comprehensive Long Answer Board Questions (3 Questions)

### Question 1: Karnaugh Map (K-Map) Theory & Simplification. Explain the purpose and rules of K-Maps. Provide step-by-step grouping and minimization for: $Y = A'B'C' + A'BC' + A'B'C + A'BC + ABC$.

#### Introduction & Purpose
A Karnaugh Map (K-Map) is a systematic graphical technique used to minimize Boolean algebra expressions into simplified Sum-Of-Products (SOP) forms without tedious algebraic theorems.

#### K-Map Minimization Rules
1. Adjacent cells must differ by only one variable bit using **Gray Code** sequence (`00, 01, 11, 10`).
2. Group adjacent `1`s into rectangular blocks of size $2^n$ ($1, 2, 4, 8, 16$).
3. Form the largest possible groups (Octet > Quad > Pair > Singleton) to maximize variable elimination.
4. Cells wrap around outer grid edges (leftmost column joins rightmost column).

#### Step-by-Step Problem Solution
Given Boolean Expression: $Y = A'B'C' + A'BC' + A'B'C + A'BC + ABC$
Corresponding Minterms: $m(0, 2, 1, 3, 7)$ which equates to $\sum m(0, 1, 2, 3, 7)$.

#### K-Map Grid Mapping

```
                        BC
                 00    01    11    10
               +-----+-----+-----+-----+
           0   |  1  |  1  |  1  |  1  |   <-- Quad 1 (m0, m1, m3, m2)
        A      +-----+-----+-----+-----+
           1   |  0  |  0  |  1  |  0  |   <-- Pair 1 with m3 (m3, m7)
               +-----+-----+-----+-----+
```

#### Group Extraction & Simplification

1. **Group 1 (Quad covering $m_0, m_1, m_2, m_3$):**
   - Covers all cells where $A = 0$.
   - Variables $B$ and $C$ change across $00, 01, 11, 10$ and are eliminated.
   - **Term 1 = $A'$**

2. **Group 2 (Pair covering $m_3, m_7$):**
   - $A$ changes from $0$ to $1$ $\implies A$ is eliminated.
   - $B = 1$ and $C = 1$ remain constant.
   - **Term 2 = $BC$**

#### Final Minimization Result
$$Y = A' + BC$$

---

### Question 2: The 6 Phases of the Software Development Life Cycle (SDLC). Provide a detailed breakdown of activities, deliverables, testing methodologies, and deployment strategies.

#### Introduction
The Software Development Life Cycle (SDLC) is a structured framework that defines the sequential and iterative phases involved in building high-quality software systems.

```
  +-------------------+       +-------------------+       +-------------------+
  | 1. PLANNING & SRS | ----> | 2. SYSTEM DESIGN  | ----> | 3. IMPLEMENTATION |
  | (Feasibility)     |       | (HLD / LLD / ERD) |       | (Coding / Git)    |
  +-------------------+       +-------------------+       +-------------------+
                                                                    |
                                                                    v
  +-------------------+       +-------------------+       +-------------------+
  | 6. MAINTENANCE    | <---- | 5. DEPLOYMENT     | <---- | 4. TESTING        |
  | (Corrective/Adapt)|       | (Direct/Parallel) |       | (Unit / UAT)      |
  +-------------------+       +-------------------+       +-------------------+
```

#### Phase Breakdown & Deliverables

1. **Planning & Requirements Analysis:**
   - Evaluates technical, financial, and operational feasibility.
   - **Deliverable:** **Software Requirements Specification (SRS)** document.
2. **System Design:**
   - Architecting system structure into High-Level Design (HLD) and Low-Level Design (LLD).
   - **Deliverables:** Entity-Relationship Diagrams (ERDs), Data Flow Diagrams (DFDs), and UI mockups.
3. **Implementation & Coding:**
   - Programmers write source code adhering to coding standards and version control (Git).
   - **Deliverable:** Executable source code modules.
4. **Testing & Quality Assurance:**
   - Validates code against SRS requirements using Unit, Integration, System, and User Acceptance Testing (UAT).
   - **Deliverables:** Test Cases & Bug Reports.
5. **Deployment:**
   - Releasing tested software to production servers.
   - **Deployment Strategies:**
     - *Direct:* Immediate replacement (High risk).
     - *Parallel:* Running old and new systems together (Lowest risk).
     - *Phased:* Gradual feature-by-feature rollout.
     - *Pilot:* Tested by a small subset of users before full rollout.
6. **Maintenance:**
   - Ongoing support categorized into **Corrective**, **Adaptive**, **Perfective**, and **Preventive**.

---

### Question 3: Comparative Analysis of Software Methodologies: Waterfall vs. Agile. Evaluate flexibility, risk, customer involvement, and project suitability using textbook case studies.

#### Introduction
Software methodologies dictate how SDLC phases are executed. The **Waterfall Model** follows a linear, sequential flow, whereas the **Agile Model** utilizes iterative, incremental cycles.

#### Comprehensive Comparison Matrix

| Criteria | Waterfall Model | Agile Model (Scrum) |
| :--- | :--- | :--- |
| **Workflow Structure** | Linear and sequential | Iterative Sprints (2–4 weeks) |
| **Requirement Flexibility**| Low (SRS locked in Phase 1) | High (Product Backlog refined continuously) |
| **Customer Involvement**| Initial requirement gathering & final delivery | Continuous feedback at every Sprint Review |
| **Risk Management** | High risk (testing occurs late in project) | Low risk (working software built every sprint) |
| **Deliverable Cycle** | Single final release at project completion | Incremental working software every 2–4 weeks |

#### Case Study Evaluations

##### Case Study 1: Al-Noor Library Management System (Waterfall Model)
- **Context:** Python/SQLite desktop application developed for managing 50,000 library books and late fee calculations.
- **Why Waterfall Suited This Project:** Library policies, loan durations, and fine structures were fixed by institutional rules. Requirements were completely stable and required no changing software iterations.

##### Case Study 2: Al-Noor Student Mobile Application (Agile Scrum Model)
- **Context:** Cross-platform Flutter/Firebase mobile portal delivering live exam countdowns and lesson streaming.
- **Why Agile Suited This Project:** Student feedback required rapid additions of new quiz modules and UI enhancements. 2-week Sprints enabled continuous Play Store deployment of new features.
