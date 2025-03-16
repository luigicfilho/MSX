# MSX-ENGINE (Yamaha S3527)

> [!CAUTION] Disclaimer: 
> This implementation may not fully replicate full behavior of the original Yamaha S3527. If you want fully replication of the original Yamaha S3527, this implementation is available, contact me. Use at your own risk.

> [!CAUTION] 
> This not implement the Yamaha S3527. If you want this implementation, this IP is available, contact me.

This repository contains a Verilog implementation of the **Yamaha S3527**, a MSX-Engine used in MSX computers.

## Overview

The *Yamaha S3527* is a MSX-Engine combines the functions of many separate, older/simpler chips into one. This is done to reduce required circuit board space, power consumption, and (most importantly) production costs for complete systems. This Verilog implementation aims to replicate the functionality of the original Yamaha S3527, providing a synthesizable IP core for use in FPGA-based retro systems or other projects.

## Features

- **Standard MSX1 functions**: DRAM control, slot selection, joystick ports, cassette/printer interface etc.
- **PSG**: a Yamaha YM2149 PSG-sound chip, compatible with a General Instrument AY-3-8910
- **PPI**: parallel I/O chip: backward compatible with the Intel i8255

## Repository Structure
- /rtl - Verilog source files for the Yamaha S3527 core.
- /testbench - Testbench files for simulation. (soon)
- /docs - Documentation and references.(soon)
- /scripts - Scripts for simulation and synthesis.(soon)
- /examples - Example configurations and usage.(soon)

## Usage

### Simulation

To simulate the design, use your preferred Verilog simulator (e.g., ModelSim, Verilator, or Icarus Verilog). A testbench is provided in the `/testbench` directory to verify the functionality of the SCC.

```bash
# Example using Icarus Verilog
iverilog -o msxe -s msxe_tb rtl/*.v testbench/msxe_tb.v
vvp msxe
```

### Synthesis
The Verilog code is designed to be synthesizable for FPGA platforms. Use your preferred synthesis tool (e.g., Xilinx Vivado, Intel Quartus) to synthesize the design for your target hardware.


## References
- Yamaha S3527 Datasheet
- Yamaha S3527 Reverse Engineering

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License
This project is licensed under the Creative Commons
Attribution-NonCommercial-NoDerivatives 4.0 (CC-NC-ND) License.
