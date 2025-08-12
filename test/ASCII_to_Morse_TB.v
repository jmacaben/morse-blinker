`timescale 1ns/1ps

module ASCII_to_Morse_TB;

    // Testbench signals
    reg  [7:0] i_ASCII;
    wire [4:0] o_Morse_Pattern;
    wire [2:0] o_Morse_Length;
    wire       o_Valid;

    // Instantiate the module under test (MUT)
    ASCII_to_Morse uut (
        .i_ASCII(i_ASCII),
        .o_Morse_Pattern(o_Morse_Pattern),
        .o_Morse_Length(o_Morse_Length),
        .o_Valid(o_Valid)
    );

    initial begin
        // Monitor output
        $display("Time | ASCII | Char | Pattern | Length | Valid");
        $display("----------------------------------------------");
        $monitor("%4dns | 0x%h   |  %s    | %b   |   %0d    |   %b", 
                 $time, i_ASCII, i_ASCII, o_Morse_Pattern, o_Morse_Length, o_Valid);

        // Test different digits and letters, both upper and lowercase
        i_ASCII = "0"; #10;
        i_ASCII = "1"; #10;
        i_ASCII = "2"; #10;
        i_ASCII = "3"; #10;
        i_ASCII = "4"; #10;
        i_ASCII = "5"; #10;
        i_ASCII = "A"; #10;
        i_ASCII = "a"; #10;
        i_ASCII = "b"; #10;
        i_ASCII = "c"; #10;

        // Test an invalid input
        i_ASCII = "!"; #10;

        // Finish simulation
        $finish;
    end

endmodule
