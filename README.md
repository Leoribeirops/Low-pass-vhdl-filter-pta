# VHDL Low-Pass Filter – Pan-Tompkins Algorithm

## Overview

This repository presents a **VHDL implementation of a low-pass filter**, corresponding to the **first stage of the Pan-Tompkins algorithm**, a classical and widely adopted method for **QRS complex detection** in electrocardiogram (ECG) signals.

The low-pass stage is designed to attenuate **high-frequency noise**, such as muscle artifacts and power-line interference, while preserving the relevant morphological characteristics of the ECG waveform.

---

## Mathematical Model

The discrete-time low-pass filter implemented in this project is defined by the following difference equation:

\[
y[n] = 2y[n-1] - y[n-2] + x[n] - 2x[n-6] + x[n-12]
\]

Where:
- \( x[n] \) represents the input ECG sample  
- \( y[n] \) represents the filtered output sample  

This formulation corresponds to the original Pan-Tompkins low-pass filter and is particularly suitable for **hardware implementation**, as it relies exclusively on additions, subtractions, and delay elements.

---

## Hardware Design Characteristics

- **Language**: VHDL  
- **Architecture**: Fully synchronous  
- **Arithmetic**: Fixed-point  
- **Filter type**: IIR with feedforward and feedback paths  
- **Delays**: Up to 12 input samples  
- **Optimization focus**:
  - Minimal hardware complexity
  - Efficient register reuse
  - Low-latency processing
  - Compatibility with FPGA and ASIC flows

---

## Project Structure

```text
.
├── LPF_biowear.vhd   # VHDL implementation of the low-pass 
└── README.md         # Project documentation
