module Morse_to_Signal #(
    parameter UNIT_CYCLES = 6250000  // Base duration of 250 ms (one Morse 'unit' or dot length) at 25 MHz clock
)(
    input        i_Clock,
    input        i_Start,
    input  [4:0] i_Morse_Pattern,
    input  [2:0] i_Morse_Length,
    output reg   o_LED,              // Output register controlling the LED state (on/off)
    output reg   o_Done
);

    // Creating type to represent states of FSM
    typedef enum reg [1:0] {
        IDLE      = 2'b00,  // Waiting for start signal
        ON_STATE  = 2'b01,
        OFF_STATE = 2'b10,
        DONE      = 2'b11
    } state_t;

    reg [1:0] state = IDLE;     // Variable to hold FSM state
    reg [22:0] cycle_count = 0; // Large enough to count UNIT_CYCLES
    reg [2:0] symbol_index = 0; // Index for current Morse symbol
    reg [2:0] on_duration = 0;  // Duration for which LED is ON
    reg [2:0] off_duration = 0; // Duration for which LED is OFF

    // Wire to get the current symbol, starting at MSB
    wire current_bit = i_Morse_Pattern[4 - symbol_index];

    always @(posedge i_Clock) begin
        case(state)
            // Waiting for start command and resetting internal counters
            IDLE: begin
                o_LED <= 0;
                o_Done <= 0;
                cycle_count <= 0;
                symbol_index <= 0;

                if (i_Start && i_Morse_Length > 0) begin
                    on_duration <= (current_bit == 1'b0) ? 1 : 3;   // Dots = 1 unit; Dashes = 3 units
                    off_duration <= 1;                              // Space between symbols is always 1 unit
                    state <= ON_STATE;                              // Transition to ON_STATE to turn LED on
                    cycle_count <= 0;
                    o_LED <= 1;                                     // Turn LED ON
                end
            end

            ON_STATE: begin
                if (cycle_count < on_duration * UNIT_CYCLES - 1) begin  // Check how many clock cycles have passed until ON duration is met
                    cycle_count <= cycle_count + 1;
                    o_LED <= 1;                                         // Keep LED ON
                end else begin
                    cycle_count <= 0;
                    o_LED <= 0;                                         // Turn LED OFF
                    state <= OFF_STATE;                                 // Transition to OFF_STATE
                end
            end

            OFF_STATE: begin
                if (cycle_count < off_duration * UNIT_CYCLES - 1) begin  // Check how many clock cycles have passed until OFF duration is met
                    cycle_count <= cycle_count + 1;
                    o_LED <= 0;                                         // Keep LED OFF
                end else begin
                    cycle_count <= 0;
                    symbol_index <= symbol_index + 1;                   // Move on to next Morse symbol

                    if (symbol_index + 1 < i_Morse_Length) begin        // Check if next symbol exists

                        // Set next ON duration (dot = 1 unit, dash = 3 units)
                        on_duration <= (i_Morse_Pattern[4 - (symbol_index + 1)] == 1'b0) ? 1 : 3;
                        off_duration <= 1;  // Space between symbols still 1 unit
                        o_LED <= 1;         // Turn LED ON
                        state <= ON_STATE;  // Transition back to ON_STATE

                    end else begin
                        state <= DONE;  // Transition to DONE state
                        o_LED <= 0;     // Turn LED OFF
                        o_Done <= 1;    // Signal that processing is done
                    end
                end
            end

            DONE: begin
                o_LED <= 0;             // Turn LED OFF
                if (!i_Start) begin     // Wait for start signal to go low
                    o_Done <= 0;        // Clear done signal
                    state <= IDLE;      // Transition back to IDLE state
                end
            end

        endcase
    end

endmodule

