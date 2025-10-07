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

    // Control FSM states
    localparam IDLE        = 2'b00; // Wait to receive UART byte
    localparam TX_ECHO     = 2'b01; // Send received byte 
    localparam MORSE_START = 2'b10; // Signal to start Morse blinker
    localparam WAIT_MORSE  = 2'b11; // Wait for character finish blinking

    reg [1:0] state = IDLE; // Variable to hold FSM state

    always @(posedge i_Clk) begin
        // Defaults (don't transmit, don't start)
        tx_dv       <= 1'b0;
        morse_start <= 1'b0;

        case(state)
            IDLE: begin
                if (rx_dv) begin            // If received a new byte...
                    tx_byte <= rx_byte;     // Prepare echo byte
                    tx_dv   <= 1'b1;        // Trigger UART_TX
                    state   <= TX_ECHO;     // Transition to TX_ECHO
                end
                // Stay IDLE if no new byte
            end

            TX_ECHO: begin
                if (tx_done) begin              // When UART_TX done...
                    if (morse_valid) begin      // Check if byte has valid Morse code translation
                        morse_start <= 1'b1;    // Pulse start to Morse blinker
                        state <= MORSE_START;   // Transition to MORSE_START
                    end else begin
                        state <= IDLE;  // No Morse for invalid character
                    end
                end
            end

            MORSE_START: begin
                state <= WAIT_MORSE;    // Transition to WAIT_MORSE
                // This just ensures pulse is 1 clock
            end

            WAIT_MORSE: begin
                if (morse_done) begin   
                    state <= IDLE;  // Transition to IDLE
                end
            end

            default: state <= IDLE;
        endcase
    end

endmodule
