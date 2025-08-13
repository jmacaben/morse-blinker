`timescale 1ns / 1ps

module tb_morse_to_signal();

    reg clk = 0;
    reg start = 0;
    reg [4:0] morse_pattern;
    reg [2:0] morse_length;
    wire led;
    wire done;

    // Instantiate DUT
    Morse_to_Signal #(
        .UNIT_CYCLES(10)  // Smaller number for fast sim
    ) uut (
        .i_Clock(clk),
        .i_Start(start),
        .i_Morse_Pattern(morse_pattern),
        .i_Morse_Length(morse_length),
        .o_LED(led),
        .o_Done(done)
    );

    // Clock generation: 50MHz equivalent
    always #10 clk = ~clk;  // i.e. wait 10 ns, then flip the clock signal

    // For waveform dump
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_morse_to_signal);
    end

    // Task to send one character
    task send_char(input [4:0] pattern, input [2:0] length, input [8*8:1] char_name);
    begin
        $display("\nTesting character: %s", char_name); // Display which character is being tested to the console for clarity
        morse_pattern = pattern;
        morse_length = length;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done);
        #50; // Small delay (50 time units) to separate transmissions cleanly in time
    end
    endtask

    // Simulation sequence
    initial begin
        // Testing letter F: ..-.
        send_char(5'b00100, 3'd4, "F");

        $display("Simulation finished.");
        #100;
        $stop;
    end

endmodule
