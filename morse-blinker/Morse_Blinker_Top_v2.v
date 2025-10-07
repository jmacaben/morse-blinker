module Morse_Blinker_Top (
    input        i_Clk,        
    input        i_UART_RX,     
    output       o_UART_TX,     
    output       o_LED_1       
);

    // UART_RX wires
    wire       rx_dv;
    wire [7:0] rx_byte;

    // UART_TX wires
    wire       tx_done;
    reg        tx_dv;
    reg  [7:0] tx_byte;

    // Morse translation wires
    wire [4:0] morse_pattern;
    wire [2:0] morse_length;
    wire       morse_valid;

    // Morse signal generator wires
    reg        morse_start;
    wire       morse_done;

    UART_RX uart_rx_inst (
        .i_Clock(i_Clk),
        .i_RX_Serial(i_UART_RX),
        .o_RX_DV(rx_dv),
        .o_RX_Byte(rx_byte)
    );

    UART_TX uart_tx_inst (
        .i_Rst_L(1'b1),
        .i_Clock(i_Clk),
        .i_TX_DV(tx_dv),
        .i_TX_Byte(tx_byte),
        .o_TX_Active(),
        .o_TX_Serial(o_UART_TX),
        .o_TX_Done(tx_done)
    );

    ASCII_to_Morse ascii_to_morse_inst (
        .i_ASCII(current_char),
        .o_Morse_Pattern(morse_pattern),
        .o_Morse_Length(morse_length),
        .o_Valid(morse_valid)
    );

    Morse_to_Signal morse_to_signal_inst (
        .i_Clock(i_Clk),
        .i_Start(morse_start),
        .i_Morse_Pattern(morse_pattern),
        .i_Morse_Length(morse_length),
        .o_LED(o_LED_1),
        .o_Done(morse_done)
    );

    localparam UNIT_CYCLES = 6250000;
    localparam BUF_SIZE = 256;  // Max number of characters in a message

    reg [7:0] message_buffer [0:BUF_SIZE-1];    // Buffer to hold the characters of the message
    reg [7:0] write_pointer = 0;                // Points to where in the buffer to store the next char
    reg [7:0] read_pointer = 0;                 // Points to the next char to be processed   
    reg [7:0] current_char;

    reg [31:0] gap_counter = 0; // Counts clock cycles for gaps between letters/words

    // Control FSM states
    localparam IDLE    = 3'd0;      // Collect typed characters into message_buffer
    localparam CHECK_CHAR = 3'd1;   // Check the next character to process
    localparam START_CHAR = 3'd2;   // Start blinking for the current character
    localparam WAIT_CHAR  = 3'd3;   // Wait for blinking to finish
    localparam LETTER_GAP = 3'd4;   // Wait 3-unit gap between letters
    localparam WORD_GAP   = 3'd5;   // Wait 7-unit gap between words
    localparam DONE_MSG   = 3'd6;   // Done, reset buffer

    reg [2:0] state = IDLE;

    always @(posedge i_Clk) begin
        // Defaults (don't transmit, don't start)
        tx_dv       <= 1'b0;
        morse_start <= 1'b0;

        case(state)
            IDLE: begin
                if (rx_dv) begin        // If received a new byte...
                    tx_byte <= rx_byte; // Prepare echo byte
                    tx_dv   <= 1'b1;    // Trigger UART_TX

                    if (rx_byte == 8'h0D) begin // If Enter pressed (message end)...
                        read_pointer <= 0;      // Reset read_pointer to start processing
                        state  <= CHECK_CHAR;   // Transition to CHECK_CHAR
                    end else begin
                        message_buffer[write_pointer] <= rx_byte;   // Store char in buffer
                        write_pointer <= write_pointer + 1;         // Increment write_pointer
                    end
                end
                // Stay IDLE if no new byte
            end
            CHECK_CHAR: begin
                if (read_pointer < write_pointer) begin             // If more characters exist...
                    current_char <= message_buffer[read_pointer];   // Load the next character
                    if (message_buffer[read_pointer] == " ") begin  // If the next character is a space...
                        gap_counter <= 0;   // Reset gap counter
                        state <= WORD_GAP;  // Transition to WORD_GAP
                    end else begin
                        state <= START_CHAR;    // Transition to START_CHAR
                    end
                end else begin
                    state <= DONE_MSG;  // Transition to DONE_MSG
                end
            end
            START_CHAR: begin
                morse_start <= 1'b1;    // Start blinking current character
                state <= WAIT_CHAR;     // Transition to WAIT_CHAR
            end
            WAIT_CHAR: begin
                if (morse_done) begin       // When character blinking is done...
                    gap_counter <= 0;       // Reset gap counter
                    state <= LETTER_GAP;    // Transition to LETTER_GAP
                end
            end
            LETTER_GAP: begin
                if (gap_counter < (2*UNIT_CYCLES - 1)) begin    // If less than 3-unit gap...
                    gap_counter <= gap_counter + 1;             // Increment gap counter
                end else begin
                    gap_counter <= 0;                   // Reset gap counter
                    read_pointer <= read_pointer + 1;   // Move to next character
                    state <= CHECK_CHAR;                // Transition to CHECK_CHAR
                end
            end
            WORD_GAP: begin
                if (gap_counter < (7*UNIT_CYCLES - 1)) begin    // If less than 7-unit gap...
                    gap_counter <= gap_counter + 1;             // Increment gap counter
                end else begin
                    gap_counter <= 0;                   // Reset gap counter
                    read_pointer <= read_pointer + 1;   // Move to next character
                    state <= CHECK_CHAR;                // Transition to CHECK_CHAR
                end
            end
            DONE_MSG: begin
                write_pointer <= 0; // Reset write_pointer
                state <= IDLE;      // Transition back to IDLE
            end

            default: state <= IDLE;
        endcase
    end

endmodule
