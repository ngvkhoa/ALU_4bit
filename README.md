# 4-Bit Discrete Logic ALU (Arithmetic Logic Unit)

![CI Status](https://github.com/ngvkhoa/ALU_4bit/actions/workflows/verilog_ci.yml/badge.svg)

A hardware-level implementation and RTL verification of a **4-bit Arithmetic Logic Unit (ALU)** designed entirely using discrete **74HCxx series logic ICs** (74HC283, 74HC86, 74HC08, 74HC32) without integrated microcontrollers or FPGAs.

---

## 📸 Circuit Schematic & Waveform Verification

### Hardware Gate-Level Schematic
![4-Bit ALU Schematic](images/ALU_4bit.png)
*Figure 1: Full 4-bit ALU circuit schematic designed and simulated in Proteus.*

### RTL Simulation Waveform
![ALU Simulation Waveform](sim/waveform.png)
*Figure 2: Verilog simulation waveform generated via Icarus Verilog and visualized using GTKWave.*

### Finished PCB
![Finished PCB](images/ALU_4bit_1.png)
*Figure 3: Finished PCB*

---

## 🚀 Key Features

### 1. Concurrent Parallel Computation
The arithmetic and logic blocks process the shared 4-bit input vectors `A[3:0]` and `B[3:0]` simultaneously without clock latency:
* **Arithmetic Operations:**
  * Addition: `A + B`
  * Subtraction (Two's complement): `A - B = A + (~B) + 1`
* **Bitwise Logic Operations:**
  * `A AND B` (IC 74HC08)
  * `A OR B` (IC 74HC32)
  * `A XOR B` (IC 74HC86)

### 2. Normalized Carry / Borrow Flag Conditioning
The raw carry-out (`C4`) of the binary adder (74HC283) behaves inversely during two's complement subtraction (`C4 = 1` when $A \ge B$, `C4 = 0` when $A < B$). A dedicated XOR conditioning gate standardizes this into an intuitive borrow/carry flag:

$$\text{Cout} = C_4 \oplus \text{SUB}$$

| Operation | SUB | Cout = 0 | Cout = 1 |
| :--- | :---: | :--- | :--- |
| **Addition** | `0` | No carry overflow | Carry-out occurred |
| **Subtraction** | `1` | No borrow ($A \ge B$, e.g., $1 - 1 = 0$) | Underflow / Borrow needed ($A < B$) |

---

## 💻 System Verilog HDL Architecture

The hardware architecture is organized into dedicated directories:
* `rtl/ALU_4bit.sv`: Structural Verilog model reflecting discrete IC wiring.
* `sim/tb_ALU_4bit.sv`: Automated self-checking testbench.

```system verilog
module ALU_4bit (
    input logic [3:0] A,
    input logic [3:0] B,
    input logic       SUB,
    
    output logic [3:0] ARITH_out,
    output logic       C_out,

    output logic [3:0] AND_out,
    output logic [3:0] OR_out,
    output logic [3:0] XOR_out
);

    logic [3:0] B_inv;
    logic       C4;
    
    always_comb begin
        B_inv = B ^ {4{SUB}};
        {C4, ARITH_out} = A + B_inv + SUB;
        C_out = C4 ^ SUB;
        
        AND_out = A & B;
        OR_out = A | B;
        XOR_out = A ^ B;
    end

endmodule

```

---

## 🧩 Bill of Materials (BOM)

| Component | Part Number | Quantity | Description |
| --- | --- | --- | --- |
| 4-Bit Binary Adder | 74HC283 | 1 | 4-bit full adder arithmetic core |
| Quad 2-Input XOR | 74HC86 | 2 | Controlled inverter & bitwise XOR |
| Quad 2-Input AND | 74HC08 | 1 | Bitwise AND unit |
| Quad 2-Input OR | 74HC32 | 1 | Bitwise OR unit |
| 4-Position DIP Switch | SPST | 2 | Input registers for `A[3:0]` and `B[3:0]` |
| SPST Switch | SPST | 1 | Arithmetic mode control (`SUB`) |
| Current-Limiting Resistor | 330 Ω, 0.25 W | 17 | Active-high LED protection |
| Pull-Down Resistor | 10 kΩ, 0.25 W | 9 | Input stabilization to GND |
| Decoupling Capacitor | 100 nF Ceramic | 5 | VCC-GND supply rail transient filter |
| LED Indicator | 5 mm Diffused | 17 | 16 function outputs + 1 status flag |
