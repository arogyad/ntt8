## Overview

This project implements a simplified 8-point Number Theoretic Transforer (NTT) accelerator in SystemVerilog for ARCH Lab task. Here we map the Cooley-Tukey style NTT structure to a iterative hardware architecture using a butterfly unit and FSM-based control.

The project used \(n = 8\), \(q = 17\) and \($\omega = 9$\), which is consistent with the requirement of the tas.

## File Structure

- `main.sv`: This contains the top-level NTT accelerator module `ntt8_top`, which includes the following components:
  - `mem[0:7]` contains the coefficient.
  - `state_t` is the FSM control logic (`IDLE`, `RUN`, `FINISH`)
  - Stage and butterfly scheduling `stage`, `group`, `j` are used for stage and butterfly scheduling.

- `butterfly.sv`: This implements the butterfly unit and modular add, subtract and multiply.

- `twiddle.sv`: This implements ROM-style combinational logic that outputs precomputed twiddle factors.

- `test.sv`: This is the test suite which gets the input from `input.mem` and check with the expected output from `expected.mem`.

## How It Works

- On `start`, inputs are loaded into an `mem[0:7]` in bit‑reversed order to simplify address generation.
- The FSM iterates through three stages and updates pairs of memory locations using the butterfly and twiddle ROM.
- When all butterflies are done, results are copied to `out_data[0:7]` and `done` is asserted.

## Build and Run (Icarus Verilog)

```bash
iverilog -g2012 -o ntt8 main.sv butterfly.sv twiddle.sv test.sv

vvp ntt8
```

[EDIT: /ntt8_2 contains DIT and DIF parameterized version of NTT algorithm.]

## Reference

I found the following reading very helpful to understand NTT:

- This helped me understand the math behind the NTT.
  RareSkills, _The Zero Knowledge Book for Programmers_ – Module 5:  
   “Number Theoretic Transform (NTT) — The Fast Fourier Transform in Finite Fields”  
   https://rareskills.io/zk-book

- This article helped me understand the implementation details and the bit‑reversal process used to compute memory addresses in the iterative NTT. I also used this blog's implementation (`main.py`) to generate the expected values for testing.

  Higashi, _A Gentle Introduction of NTT – Part II_  
  https://higashi.blog/2023/06/23/ntt-02/
