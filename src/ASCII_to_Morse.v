module ASCII_to_Morse(
    input      [7:0] i_ASCII,
    output reg [4:0] o_Morse_Pattern,
    output reg [2:0] o_Morse_Length,
    output reg       o_Valid
);

    reg [7:0] ASCII_lower;

    always @(*) begin
        
        // Convert uppercase 'A'-'Z' to lowercase 'a'-'z'
        if (i_ASCII >= 8'h41 && i_ASCII <= 8'h5A)
            ASCII_lower = i_ASCII + 8'd32;
        else
            ASCII_lower = i_ASCII;

        o_Morse_Pattern = 5'b00000;
        o_Morse_Length  = 3'd0;
        o_Valid         = 1'b0;

        case(ASCII_lower)
            // Numbers 0-9
            8'h30: begin // '0'
                o_Morse_Pattern = 5'b11111;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h31: begin // '1'
                o_Morse_Pattern = 5'b01111;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h32: begin // '2'
                o_Morse_Pattern = 5'b00111;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h33: begin // '3'
                o_Morse_Pattern = 5'b00011;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h34: begin // '4'
                o_Morse_Pattern = 5'b00001;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h35: begin // '5'
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h36: begin // '6'
                o_Morse_Pattern = 5'b10000;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h37: begin // '7'
                o_Morse_Pattern = 5'b11000;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h38: begin // '8'
                o_Morse_Pattern = 5'b11100;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            8'h39: begin // '9'
                o_Morse_Pattern = 5'b11110;
                o_Morse_Length  = 3'd5;
                o_Valid         = 1'b1;
            end
            
            // Letters a-z
            8'h61: begin //'a'
                o_Morse_Pattern = 5'b01000;
                o_Morse_Length  = 3'd2;
                o_Valid         = 1'b1;
            end
            8'h62: begin //'b'
                o_Morse_Pattern = 5'b10000;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h63: begin //'c'
                o_Morse_Pattern = 5'b10100;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h64: begin //'d'
                o_Morse_Pattern = 5'b10000;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h65: begin //'e'
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd1;
                o_Valid         = 1'b1;
            end
            8'h66: begin //'f'
                o_Morse_Pattern = 5'b00100;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h67: begin //'g'
                o_Morse_Pattern = 5'b11000;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h68: begin //'h'
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h69: begin //'i'
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd2;
                o_Valid         = 1'b1;
            end
            8'h6A: begin //'j'
                o_Morse_Pattern = 5'b01110;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h6B: begin //'k'
                o_Morse_Pattern = 5'b10100;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h6C: begin //'l'
                o_Morse_Pattern = 5'b01000;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h6D: begin //'m'
                o_Morse_Pattern = 5'b11000;
                o_Morse_Length  = 3'd2;
                o_Valid         = 1'b1;
            end
            8'h6E: begin //'n'
                o_Morse_Pattern = 5'b10000;
                o_Morse_Length  = 3'd2;
                o_Valid         = 1'b1;
            end
            8'h6F: begin //'o'
                o_Morse_Pattern = 5'b11100;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h70: begin //'p'
                o_Morse_Pattern = 5'b01100;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h71: begin //'q'
                o_Morse_Pattern = 5'b11010;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h72: begin //'r'
                o_Morse_Pattern = 5'b01000;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h73: begin //'s'
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h74: begin //'t'
                o_Morse_Pattern = 5'b10000;
                o_Morse_Length  = 3'd1;
                o_Valid         = 1'b1;
            end
            8'h75: begin //'u'
                o_Morse_Pattern = 5'b00100;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h76: begin //'v'
                o_Morse_Pattern = 5'b00010;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h77: begin //'w'
                o_Morse_Pattern = 5'b01100;
                o_Morse_Length  = 3'd3;
                o_Valid         = 1'b1;
            end
            8'h78: begin //'x'
                o_Morse_Pattern = 5'b10010;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h79: begin //'y'
                o_Morse_Pattern = 5'b10110;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end
            8'h7A: begin //'z'
                o_Morse_Pattern = 5'b11000;
                o_Morse_Length  = 3'd4;
                o_Valid         = 1'b1;
            end

            default: begin
                o_Morse_Pattern = 5'b00000;
                o_Morse_Length  = 3'd0;
                o_Valid         = 1'b0;
            end
        endcase
    end

endmodule
