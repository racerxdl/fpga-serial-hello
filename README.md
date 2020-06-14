FPGA Serial Hello World
=========================

All files are licensed in Apache except for `SerialRX.v` and `SerialTX.v` which are from FPGA4FUN.


This examples compiles a FPGA Core that prints out `Hello World\n` on serial port and blinks a led with fade-in.

This example is tuned to work on [Colorlight Hub 5a-75b v6.1](https://github.com/q3k/chubby75/blob/master/5a-75b/hardware_V6.1.md).

The LED is connected to onboard D2 LED (FPGA PIN U16), TXD to J4 Pin 1 (FPGA Pin N3), RXD to J4 Pin 2 (FPGA Pin N4), clk connected to onboard clock (FPGA PIN P3)

Running `make` will trigger the build of svf file using docker.

