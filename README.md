# FIR Filter on Zybo FPGA

An FPGA implementation of a parameterisable FIR filter targeting the Digilent **Zybo Zynq-7000** development board. Implemented as a project for the Digital VLSI Systems Course in ECE NTUA.  
The design is packaged as a reusable Vivado IP core and integrated in a simple **Zynq Processing System + AXI-Lite** design.  
This repository contains **only the source files** needed to recreate the project; all tool-generated output is excluded via `.gitignore`.

---

## Table of Contents
1. [Features](#features)  
2. [Repository Layout](#repository-layout)  
3. [Prerequisites](#prerequisites)  
4. [Quick Start](#quick-start)  
5. [Regenerating the Vivado Project](#regenerating-the-vivado-project)  
6. [Programming the Zybo Board](#programming-the-zybo-board)  
7. [License](#license)  
---

## Features
* 8-tap FIR filter with configurable coefficients stored in ROM.  
* AXI-Lite slave interface for filter control and data I/O.  
* Self-contained IP core that can be reused in other designs.  
* Complete TCL-based build flow for reproducible builds.  
* Test-bench and behavioural simulation scripts.

## Repository Layout
```
FIR_FILTER/
├── ip_src/                                 # VHDL source files for the FIR IP
│   ├── myip.vhd                            # Top-level IP wrapper
│   ├── myip_slave_lite_v1_0_S00_AXI.vhd    # AXI4-Lite interface (myip (FIR) should output in reg1)
│   ├── fir_final.vhd                       # Main FIR filter entity - top level module
│   ├── control_unit.vhd                    # FIR control state machine
│   ├── mac.vhd                             # Multiply-accumulate unit
│   ├── mlab_ram.vhd                        # Shift register memory
│   ├── mlab_rom.vhd                        # Coefficient storage
│   ├── dff.vhd                             # Single bit D-flip-flop
│   └── dff8.vhd                            # 8-bit D-flip-flop
├── constraints/                            # Timing and pin constraints
│   └── zybo_pins.xdc                       # Clock constraints for Zybo
├── scripts/                                # TCL automation scripts
│   ├── package_myip.tcl                    # Packages IP from VHDL sources
│   └── recreate_project.tcl                # Master build script
├── tests/                                  # VHDL test benches
├── README.md                               # 📄 You are here
├── .gitignore                              # Ignore tool-generated files
└── LICENSE                                 # License
```

> **NOTE:** Generated directories such as `build/`, `ip_repo/`, etc. are **not** tracked. Re-running the TCL scripts will regenerate them.

## Prerequisites
* **Vivado 2024.2** (earlier/later versions will likely work but are untested).  
* A Digilent **Zybo** board.  

## Quick Start
```bash
# 1. Clone the repository
$ git clone https://github.com/geokoko/FIR_Filter.git
$ cd FIR_Filter

# 2. Run the complete automated build (packages IP, creates project with full block design, creates HDL wrapper)
$ vivado -mode batch -notrace -source scripts/recreate_project.tcl 

# 3. Open the generated project in Vivado GUI
$ vivado build/FIR_Zybo/FIR_Zybo.xpr &
```

- The script creates a complete Vivado project ready for synthesis/implementation/bitstream generation.
- The generated project will be in `build/FIR_Zybo/`

## Regenerating the Vivado Project
The repository uses a fully-scripted TCL flow that runs completely in batch mode:

```bash
# Create complete project (IP + block design + HDL wrapper)
$ vivado -mode batch -source scripts/recreate_project.tcl

# Package IP only
$ vivado -mode batch -source scripts/package_myip.tcl
```

This will automatically:
1. ✅ Package the VHDL sources into a reusable IP core (`myip`)
2. ✅ Create the `FIR_Zybo` project targeting the Zybo board
3. ✅ Create the `design_1` block diagram with Zynq PS + custom FIR IP
4. ✅ Add timing constraints and generate the HDL wrapper
5. ✅ Generate a complete Vivado project ready for synthesis/implementation/bitstream generation

**No GUI interaction required!** The entire process runs in batch mode.

## Programming the Zybo Board
After opening the project in Vivado:
1. Run synthesis: `launch_runs synth_1`
2. Run implementation: `launch_runs impl_1` 
3. Generate bitstream: `launch_runs impl_1 -to_step write_bitstream`
4. Program the board via Vivado Hardware Manager or export to Vitis

## License
This project is released under the **MIT License** — see the [LICENSE](LICENSE) file for details.