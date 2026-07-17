## Build and Run

Inside any of the implementation folder,

```bash
verilator -Wall --binary --timing --top-module test test.sv ntt_top.sv butterfly.sv twiddle.sv

./obj_dir/Vtest
```
