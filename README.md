# Morse Code Blinker
Built for the Nandland Go Board, this Verilog project takes ASCII characters received via UART and blinks their Morse code translation through an LED. 

## Project Overview
This design consists of several modules, along with their respective testbenches:
- **UART_RX[^*]**: Receives ASCII bytes from a serial terminal
- **UART_TX[^*]**: Echoes back received bytes for confirmation
- **ASCII_to_Morse**: Converts ASCII characters into a 5-bit Morse pattern
- **Morse_to_Signal**: Blinks an LED according to the Morse pattern using a clocked finite state machine.
  
The top-level module, **Morse_Blinker_Top**, connects these components to receive characters, translate them to Morse, and blink the LED.

## Setup
- **Device**: iCE40HX1K (Nandland Go Board)
- **Software**: Lattice iCEcube2 / Diamond Programmer
- **Serial Terminal**: Tera Term (for sending/receiving ASCII characters)

For simulation/testing, I tried out both **EDA Playground** and **Icarus Verilog + GTKWave** to gain experience with different Verilog simulation environments and waveform analysis.

## Future Work
- **Full Words/Sentences**: Extend the Morse blinker to handle entire words or sentences, like a text message.
- **Morse Code Input Translator**: Add a button-based input system where pressing short (dot) and long (dash) signals can be translated back into ASCII characters and displayed on a terminal.
- **Camera-Based Morse Receiver**: Develop a system where a camera captures LED flashes of Morse code and decodes them back into text.

[^*]: Files downloaded from http://www.nandland.com 
