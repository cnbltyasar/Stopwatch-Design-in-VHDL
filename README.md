# Stopwatch-Design-in-VHDL
This project implements a digital stopwatch using VHDL. The design utilizes several VHDL components for debouncing push-buttons, counting time, and driving a seven-segment display. The stopwatch counts in hundredths of a second (salise), seconds, and minutes, and it displays the time on six seven-segment displays via a multiplexed anode control.

Table of Contents
Overview
Features
Design Components
Architecture
Simulation and Synthesis
Usage
File Structure
License
Overview
The VHDL stopwatch design uses the following key ideas:

Debouncing: Two debouncing components are used to stabilize the input signals for "start" and "reset".
Counters: Three counters are instantiated for salise (hundredths of a second), seconds, and minutes.
Seven-Segment Display: A seven-segment driver converts binary coded decimal (BCD) outputs to display patterns, and a multiplexing scheme cycles through each digit.
Multiplexed Anode Control: An additional process cycles the active anode to display the digits on a six-digit seven-segment display.
Features
Start/Stop Functionality: Toggle the stopwatch using a debounced start button.
Reset Capability: Reset the counters to zero using a debounced reset button.
Time Counting: Increments in hundredths of a second, with proper cascading to seconds and minutes.
Multiplexed Display Control: Drives a six-digit seven-segment display using an anode shifting process.
Design Components
Debounce Component

Purpose: Stabilizes the input from mechanical push-buttons (start and reset).
Generic Parameter: c_initval – initial value for the output.
Ports:
clk: Clock input.
signal_i: Raw button input.
signal_o: Debounced button output.
Counter Component

Purpose: Implements a BCD counter for a given digit (units and tens).
Generic Parameters:
birler_lim: Limit for the unit digit.
onlar_lim: Limit for the tens digit.
Ports:
clk: Clock input.
add: Increment control signal.
reset: Reset signal.
birler: BCD output for the units digit.
onlar: BCD output for the tens digit.
Sevensegment Component

Purpose: Converts a 4-bit BCD input into an 8-bit seven-segment display pattern.
Ports:
bcd: 4-bit BCD input.
sevenseg: 8-bit output for the seven-segment display (active low/high depending on implementation).
Architecture
The top-level entity (top) integrates the following:

Generic Parameter:
clkfreq: Clock frequency (default is 100 MHz).
Signals:
Internal signals manage the debounced inputs, counter outputs, and display driver signals.
Processes
Time Counting Process:

Handles the incrementation of hundredths (salise), seconds, and minutes.
Uses a counter that counts clock cycles corresponding to 1ms and 10ms intervals.
Checks the state of the continue signal (toggled by the start button) to run the counters.
Anode Multiplexing Process:

Cycles through the six digits by shifting the active anode bits.
Uses a timer (timer1ms) to change the active digit every 1ms, ensuring persistence of vision.
Seven-Segment Display Process:

Routes the BCD-to-seven-segment conversion outputs to the common display based on the current active anode.
Implements a priority check to display the corresponding digit.
Simulation and Synthesis
Simulation:
Use a VHDL simulator (such as ModelSim, Vivado Simulator, or GHDL) to simulate the design. Create a testbench that drives the clock, start, and reset inputs, and observe the outputs (counter values and display segments).

Synthesis:
The design can be synthesized for FPGAs. Make sure to configure the target device's clock frequency to match the clkfreq generic. The constraints file should properly assign the clock, button inputs, and seven-segment display outputs (anode and cathode pins).

Usage
Compile the VHDL files in your preferred synthesis tool or simulation environment.
Simulate the design using a testbench that applies the appropriate clock, start, and reset signals.
Synthesize and load the design onto your target FPGA board.
Connect the seven-segment displays and push-buttons according to your board’s constraints.
Operate the stopwatch using the start and reset buttons.
File Structure
bash
Kopyala
Stopwatch/
├── src/
│   ├── top.vhd            # Top-level entity integrating the design.
│   ├── debounce.vhd       # Debounce component.
│   ├── counter.vhd        # BCD counter component.
│   └── sevensegment.vhd   # Seven-segment display driver.
├── tb/
│   └── top_tb.vhd         # Testbench for simulation.
└── README.md              # This file.
