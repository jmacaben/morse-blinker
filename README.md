# Morse Code Translator
Built for the Nandland Go Board, this project converts ASCII characters received via UART into Morse code and blinks them on an LED. Additionally, it now includes a Python-based decoder that captures the blinking LED with a webcam and translates the Morse code back into text.

## Project Overview
This design consists of several Verilog modules, along with their respective testbenches:
- **UART_RX[^*]**: Receives ASCII bytes from a serial terminal
- **UART_TX[^*]**: Echoes back received bytes for confirmation
- **ASCII_to_Morse**: Converts ASCII characters into a 5-bit Morse pattern
- **Morse_to_Signal**: Blinks an LED according to the Morse pattern using a clocked finite state machine.
The top-level module, **Morse_Blinker_Top**, connects these components to receive characters, translate them to Morse, and blink the LED.

This project also includes a camera-based Morse code receiver. Using OpenCV, **morse_decoder.py** can read the LED blinking from the FPGA and translates it back into text, displaying both the current signal (dots/dashes) and the decoded message in real time.

## FPGA Setup
- **Device**: iCE40HX1K (Nandland Go Board)
- **Software**: Lattice iCEcube2 / Diamond Programmer
- **Serial Terminal**: Tera Term (for sending/receiving ASCII characters)

For simulation/testing, I tried out both **EDA Playground** and **Icarus Verilog + GTKWave** to gain experience with different Verilog simulation environments and waveform analysis.

## Future Work
- **Morse Code Input Translator**: Add a button-based input system where pressing short (dot) and long (dash) signals can be translated back into ASCII characters and displayed on a terminal.

[^*]: Files downloaded from http://www.nandland.com 
