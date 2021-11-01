# VitisHLS-Vivado-IP-Example
Simple project to explore generating IP starting with Vitis HLS and migrating to Vivado for simulation. 

Xilinx Tool Versions:
Vitis HLS 2021.1
Vivado 2021.1

Step 1: Vitis IP Generation
Follow "Getting Started with Vivado High-Level Synthesis" video tutorial to generate an IP core for the "coding_loop_pipeline: HLS example via Solution->Export RTL
https://www.xilinx.com/video/hardware/getting-started-with-vivado-high-level-synthesis.html

The output of this tutorial will be a zipped copy of the Vivado IP saved at a location you specify. (20211101-loop_pipeline.zip is included in repo as an example). Unzip this package somewhere in your project folder for use in the next step.

Step 2: Vivado Project Setup
  a) Open loop_pipeline_test.xpr project.
  b) Open IP Catalog in FlowNavigator-Project Manager
  c) In the IP Catalog tab that opens, right click on “Vivado Repository” and select "Add repository..."
  d) Select the folder containing the IP generated in Step 1. 
  e) Under the new “User Repository” section that appears, under “VITIS HLS IP” double click the “Loop_pipeline” IP that you’ve just added
  f) In the Customize IP window that opens select “OK”
  g) In the Generate Output Products window that opens select “Generate”

Step3: Vivado Simulation
  a) Under FlowNavigator-Simulation click “Run Simulation -> Run Behavioral Simulation”
  b) Wait a while… if it hangs on the elaborate stage after a minute or two, cancel and try again. 
  c) Run sim for 5us and results should look something like the included screenshot (20211101-HLS-RTL-Sim-Example.PNG)
  d) When done goes high just after 4us the signal output_sum = 0xed8

Useful References:
UG 871 - Vivado High Level Synthesis Tutorial
UG 1399 - Vitis HLS User Guide
