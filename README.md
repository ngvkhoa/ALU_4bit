# 4-Bit Discrete Logic ALU (Arithmetic Logic Unit)

A hardware-level implementation of a 4-bit **Arithmetic Logic Unit (ALU)** built purely from discrete **74HCxx series logic ICs**—without microcontrollers, FPGAs, or pre-packaged single-chip ALUs (such as the 74HC181).

This project demonstrates low-level digital logic design, two's complement arithmetic, bitwise logic operations, and hardware status flag conditioning.

## 📸 Circuit Schematics & Simulation

*Figure 1: Full schematic simulation in Proteus.*

> **Tip for GitHub**: Place your exported schematic inside an `images/` directory in your repository (`images/alu_schematic.png`), or drag-and-drop the image file directly into the GitHub web editor to host it automatically.

## 🚀 Key Features

* **Parallel Execution**: Both the arithmetic and bitwise logic blocks compute outputs concurrently from shared 4-bit inputs ($A$ and $B$).

* **Arithmetic Operations**:

  * **Addition**: $A + B$

  * **Subtraction**: $A - B = A + \overline{B} + 1$ (implemented via hardware two's complement).

* **Bitwise Logic Operations**:

  * $A \text{ AND } B$

  * $A \text{ OR } B$

  * $A \text{ XOR } B$

* **Intuitive Status Flag Conditioning (**$C_{out}$**)**:

  * A standard 4-bit adder produces $C_4 = 1$ on subtraction when $A \ge B$ (no borrow) and $C_4 = 0$ when $A < B$ (borrow).

  * An integrated XOR gate ($C_{out} = C_4 \oplus SUB$) automatically resolves this convention:

    * **Addition (**$SUB = 0$**):** $C_{out} = 1$ indicates arithmetic overflow (Carry).

    * **Subtraction (**$SUB = 1$**):** $C_{out} = 1$ indicates a negative result (Borrow). When $A = B$ (result $= 0000$), $C_{out}$ clears to `0`.

## 🧩 Bill of Materials (BOM)

| 

| **Component** | **Part Number** | **Quantity** | **Description** | 
| **4-Bit Binary Adder** | `74HC283` | 1 | High-speed 4-bit binary full adder | 
| **Quad 2-Input XOR** | `74HC86` | 2 | IC 1: Controllable bit-inverter; IC 2: Logic XOR & flag conditioning | 
| **Quad 2-Input AND** | `74HC08` | 1 | Bitwise AND operations | 
| **Quad 2-Input OR** | `74HC32` | 1 | Bitwise OR operations | 
| **DIP Switches** | 4-position / SPST | 2–3 | Inputs for Operand $A[3:0]$, $B[3:0]$, and mode select $SUB$ | 
| **Current Limiting Resistors** | 330 $\Omega$ (0.25W) | 17 | LED output protection | 
| **Pull-down Resistors** | 10 $\text{k}\Omega$ | 9 | Pull-down resistors to GND for DIP switches | 
| **Decoupling Capacitors** | 100 nF (0.1 $\mu\text{F}$) Ceramic | 5 | Power rail decoupling (1 per IC between VCC and GND) | 
| **LED Indicators** | 5mm (Red / Green / Yellow) | 17 | Visual output monitoring (16 data bits + 1 carry/borrow flag) | 

## 📐 Circuit Architecture & Pin Connections

### 1. Controlled Inverter & Arithmetic Unit

* **IC1 (`74HC86` - Bit Inverter):**

  * Gate 1: Pin 1 $\rightarrow B_0$, Pin 2 $\rightarrow SUB$ $\implies$ Output Pin 3 ($B_{\text{inv}0}$)

  * Gate 2: Pin 4 $\rightarrow B_1$, Pin 5 $\rightarrow SUB$ $\implies$ Output Pin 6 ($B_{\text{inv}1}$)

  * Gate 3: Pin 9 $\rightarrow B_2$, Pin 10 $\rightarrow SUB$ $\implies$ Output Pin 8 ($B_{\text{inv}2}$)

  * Gate 4: Pin 12 $\rightarrow B_3$, Pin 13 $\rightarrow SUB$ $\implies$ Output Pin 11 ($B_{\text{inv}3}$)

* **IC2 (`74HC283` - 4-Bit Binary Adder):**

  * Input $A$: Pin 5 ($A_1 \leftarrow A_0$), Pin 3 ($A_2 \leftarrow A_1$), Pin 14 ($A_3 \leftarrow A_2$), Pin 12 ($A_4 \leftarrow A_3$)

  * Input $B$: Pin 6 ($B_1 \leftarrow B_{\text{inv}0}$), Pin 2 ($B_2 \leftarrow B_{\text{inv}1}$), Pin 15 ($B_3 \leftarrow B_{\text{inv}2}$), Pin 11 ($B_4 \leftarrow B_{\text{inv}3}$)

  * Carry In ($C_0$): Pin 7 connected to signal line $SUB$.

  * Sum Outputs: Pin 4 ($\Sigma_1$), Pin 1 ($\Sigma_2$), Pin 13 ($\Sigma_3$), Pin 10 ($\Sigma_4$).

  * Carry Out ($C_4$): Pin 9.

### 2. Flag Conditioning ($C_{out}$)

* Route Pin 9 ($C_4$ of `74HC283`) and signal $SUB$ into a spare XOR gate on **IC3 (`74HC86`)**.

* The output of this XOR gate drives `LED_COUT` through a 330 $\Omega$ resistor.

### 3. Bitwise Logic Units

* **AND (`74HC08`):** Direct pairs $(A_0, B_0) \dots (A_3, B_3)$ into gates 1–4 $\implies$ Outputs on pins 3, 6, 8, 11.

* **OR (`74HC32`):** Direct pairs $(A_0, B_0) \dots (A_3, B_3)$ into gates 1–4 $\implies$ Outputs on pins 3, 6, 8, 11.

* **XOR (`74HC86` - IC3):** Remaining gates compute bitwise $A \oplus B \implies$ Outputs on pins 3, 6, 8, 11.

## 📊 Truth Table & Verification Vectors

| **Operation** | **Mode (SUB)** | **Input A** | **Input B** | **Output Display (Σ/Logic)** | **Flag (Cout​)** | **Behavior / Explanation** | 
| **Normal Addition** | `0` | `0101` (5) | `0011` (3) | `1000` (8) | `0` (OFF) | $5 + 3 = 8$, no carry generated | 
| **Overflow Addition** | `0` | `1111` (15) | `0001` (1) | `0000` (0) | `1` (ON) | Exceeds 4-bit limit ($16$), carry asserted | 
| **Equal Subtraction** | `1` | `0001` (1) | `0001` (1) | `0000` (0) | `0` (OFF) | $1 - 1 = 0$, result is non-negative, no borrow | 
| **Negative Subtraction** | `1` | `0010` (2) | `0101` (5) | `1101` (-3) | `1` (ON) | $2 - 5 = -3$ (two's complement `1101`), borrow asserted | 
| **Bitwise AND** | `X` | `1100` | `1010` | `1000` | — | Parallel bit-by-bit AND | 
| **Bitwise OR** | `X` | `1100` | `1010` | `1110` | — | Parallel bit-by-bit OR | 
| **Bitwise XOR** | `X` | `1100` | `1010` | `0110` | — | Parallel bit-by-bit XOR | 

## ⚠️ Hardware Assembly & Protection Guidelines

1. **Floating CMOS Inputs**: High-impedance CMOS gates must never remain floating. Connect a **10** $\text{k}\Omega$ **pull-down resistor** from each switch output pin to ground (`GND`) so the input transitions cleanly to logic `0` when the switch opens.

2. **Supply Voltage**: Power the circuit strictly with a regulated **+5V DC** supply. Voltages exceeding 6.0V DC will permanently damage 74HC series ICs.

3. **Decoupling Capacitors**: Place a **100 nF ceramic capacitor** across the $V_{CC}$ and $GND$ pins of each integrated circuit as close to the body as possible to mitigate switching transients.

4. **Active-High LED Wiring**:
   

   $$
   \text{IC Output Pin} \longrightarrow \text{Anode (+) [LED] Cathode (-)} \longrightarrow 330\,\Omega \text{ Resistor} \longrightarrow \text{GND}
   $$

## 📂 Repository File Structure

```
├── docs/
│   └── logic_diagram.pdf           # Gate-level wiring diagrams
├── images/
│   ├── alu_schematic.png           # Exported Proteus schematic
│   └── breadboard_prototype.jpg    # Physical hardware setup
├── simulation/
│   └── ALU_4bit_Proteus.pdsprj     # Proteus simulation project file
└── README.md                       # Project documentation

```

## 📄 License

This hardware project is open source and distributed under the [MIT License](LICENSE).