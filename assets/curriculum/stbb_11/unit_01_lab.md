# PCSA Academy • Class 11 Computer Science (STBB)
## Unit 1: Practical Lab Sheet 1 — Circuit Simulation in Logisim Evolution
**Publication Quality:** Cambridge / Oxford Standard • STBB Board Practical Manual

---

## 1. Experiment Overview & Title

**Practical Experiment 01:** Designing, Simulating, and Verifying Logic Circuits and Truth Tables using **Logisim Evolution v3.9+**.

---

## 2. Objectives

By the completion of this practical exercise, the student will be able to:
1. Install and launch Logisim Evolution using a Java 21+ Runtime Environment.
2. Navigate the Logisim Evolution GUI (Explorer tree, Toolbar, Canvas, Attribute Table).
3. Construct basic logic gates (AND, OR, NOT) and compound Boolean logic circuits on the canvas.
4. Verify physical circuit operation against mathematical truth tables using the **Poke Tool (`☝`)**.
5. Interpret wire color codes (Bright Green, Dark Green, Blue, Grey, Red/Orange) during simulation.

---

## 3. Required Software & Hardware

- **Software:** Logisim Evolution v3.9+ (Open-source CAD CAD package).
- **Runtime:** Java Runtime Environment (JRE / JDK 21+).
- **Hardware:** Desktop PC / Laptop running Windows, Linux, or macOS.

---

## 4. Lab Safety & Software Setup Guidelines

1. Download and install OpenJDK 21 or Oracle JDK 21.
2. Launch `logisim-evolution.jar` or executable installer.
3. Ensure **Simulation Enabled** is checked under the **Simulate** menu (`Ctrl + E`).

---

## 5. Practical Tasks & Step-by-Step Procedure

### Task 1: Basic Gates Truth Table Verification
1. Drag an **Input Pin (`Square Pin`)** onto the canvas for Input $A$, and another for Input $B$.
2. Select the **AND Gate** from the Gates Explorer folder. Set `Data Bits = 1` and `Number of Inputs = 2` in the Attribute Table.
3. Connect Input $A$ and Input $B$ to the AND gate inputs using the **Wiring Tool**.
4. Connect the AND gate output pin to an **Output Pin (`Circle Pin`)** labelled $Y$.
5. Select the **Poke Tool (`☝`)** from the toolbar. Click Input $A$ and Input $B$ to toggle values ($0/1$) and verify the output $Y$ against the theoretical AND truth table.
6. Repeat the process for 2-input **OR Gate** and 1-input **NOT Gate**.

```
                           TASK 1: LOGISIM CIRCUIT LAYOUT
                           
       +---+                                 +-------+
  A ---| 0 |--------------------------------0| AND   |
       +---+                                 | Gate  |----0 Y (Output)
                                        +---0+-------+
       +---+                            |
  B ---| 0 |----------------------------+
       +---+
```

### Task 2: Compound Circuit Simulation ($Y = A \cdot B + C$)
1. Place 3 Input Pins labelled $A$, $B$, and $C$.
2. Connect Inputs $A$ and $B$ to a 2-input **AND Gate**.
3. Connect the output of the AND Gate and Input $C$ to a 2-input **OR Gate**.
4. Connect the output of the OR Gate to Output Pin $Y$.
5. Using the **Poke Tool**, cycle through all 8 binary combinations ($000_2$ to $111_2$) and record the resulting output states in your lab report.

```
                           TASK 2: COMPOUND LOGIC CIRCUIT
                           
       +---+                                 +-------+
  A ---| 0 |--------------------------------0| AND   |
       +---+                                 | Gate  |----+
                                        +---0+-------+    |    +-------+
       +---+                            |                 +---0| OR    |
  B ---| 0 |----------------------------+                      | Gate  |----0 Y
       +---+                                              +---0+-------+
                                                          |
       +---+                                              |
  C ---| 0 |----------------------------------------------+
       +---+
```

---

## 6. Observation & Verification Table

Record your experimental simulation outputs for $Y = A \cdot B + C$:

| Test No. | Input A | Input B | Input C | Intermediate ($A \cdot B$) | Simulation Output $Y = (A \cdot B) + C$ | Observed Wire Color (Output Y) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **1** | 0 | 0 | 0 | 0 | **0** | Dark Green (Logic 0) |
| **2** | 0 | 0 | 1 | 0 | **1** | Bright Green (Logic 1) |
| **3** | 0 | 1 | 0 | 0 | **0** | Dark Green (Logic 0) |
| **4** | 0 | 1 | 1 | 0 | **1** | Bright Green (Logic 1) |
| **5** | 1 | 0 | 0 | 0 | **0** | Dark Green (Logic 0) |
| **6** | 1 | 0 | 1 | 0 | **1** | Bright Green (Logic 1) |
| **7** | 1 | 1 | 0 | 1 | **1** | Bright Green (Logic 1) |
| **8** | 1 | 1 | 1 | 1 | **1** | Bright Green (Logic 1) |

---

## 7. Viva-Voce Questions & Model Answers

### Q1: What is the function of the Poke Tool (`☝`) in Logisim Evolution?
**Answer:** The Poke Tool is used during live simulation to click on input pins to toggle their state between Logic LOW ($0$) and Logic HIGH ($1$), or to inspect register states.

### Q2: During simulation, what does a blue wire indicate in Logisim?
**Answer:** A blue wire indicates an unconnected or high-impedance ($Z$) line where no signal source is connected to the wire.

### Q3: What does a red or orange wire indicate during circuit execution?
**Answer:** A red/orange wire indicates an electrical short circuit or conflict error where two opposing gates are trying to drive different logic values ($0$ and $1$) onto the same wire.

### Q4: How do you change a gate's input count in Logisim Evolution?
**Answer:** Select the gate on the canvas, locate the **Number of Inputs** field in the **Attribute Table** (bottom-left window), and enter the desired number of inputs (e.g., 2, 3, or 4).

### Q5: What is the Boolean expression implemented in Task 2 of this lab?
**Answer:** $Y = A \cdot B + C$, where inputs $A$ and $B$ are multiplied via an AND gate, and the result is OR-ed with input $C$.
