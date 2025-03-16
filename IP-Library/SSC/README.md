# Konami 2212P003 (SCC)

> [!CAUTION] Disclaimer: 
> This implementation may not fully replicate full behavior of the original Konami 2212P003. If you want fully replication of the original Konami 2212P003, this implementation is available, contact me. Use at your own risk.

> [!IMPORTANT] 
> This not implement the SCC+ or Konami SCC-I (2312P001). If you want this implementation, this IP is available, contact me.

This repository contains a Verilog implementation of the **Konami 2212P003 (Sound Creative Chip)**, a sound chip used in MSX computers and cartridges to provide advanced audio capabilities. The SCC is known for its wavetable synthesis, allowing for rich and dynamic sound generation.

## Overview

The *Konami SCC* is a sound chip that extends the audio capabilities of MSX systems by providing **five channels of wavetable synthesis**. Each channel can play custom waveforms, making it ideal for music and sound effects in games and demos. This Verilog implementation aims to replicate the functionality of the original SCC, providing a synthesizable IP core for use in FPGA-based retro systems or other projects.

## Features

- **Five Channels**: Five independent channels for wavetable synthesis.
- **Custom Waveforms**: Each channel can use a 32-byte custom waveform.
- **Volume Control**: Individual volume control for each channel.
- **Frequency Control**: Programmable frequency for precise pitch control.
- **Compatibility**: Designed to be compatible with MSX and other retro systems that use the SCC.
- **8K rom mapper**: 

## Repository Structure
- /rtl - Verilog source files for the SCC core.
- /testbench - Testbench files for simulation. (soon)
- /docs - Documentation and references.(soon)
- /scripts - Scripts for simulation and synthesis.(soon)
- /examples - Example configurations and usage.(soon)

## Usage

### Simulation

To simulate the design, use your preferred Verilog simulator (e.g., ModelSim, Verilator, or Icarus Verilog). A testbench is provided in the `/testbench` directory to verify the functionality of the SCC.

```bash
# Example using Icarus Verilog
iverilog -o scc_sim -s scc_tb rtl/*.v testbench/scc_tb.v
vvp scc_sim
```

### Synthesis
The Verilog code is designed to be synthesizable for FPGA platforms. Use your preferred synthesis tool (e.g., Xilinx Vivado, Intel Quartus) to synthesize the design for your target hardware.


## References
- Konami 2212P003 Datasheet
- Konami 2212P003 Technical Documentation
- SCC Sound Chip Reverse Engineering

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License
This project is licensed under the Creative Commons
Attribution-NonCommercial-NoDerivatives 4.0 (CC-NC-ND) License.
