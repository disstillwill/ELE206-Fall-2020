//==============================================================================
// Stoplight Module for Lab 4
//
// Note on lights:
// 	Each bit represents the on/off signal for a light.
// 	Bit | Light
// 	------------
// 	0   | Red
// 	1   | Yellow
// 	2   | Green
//==============================================================================

module Stoplight(
	input            clk,         // Clock signal
	input            rst,         // Reset signal for FSM
	input            car_present, // Is there a car on Prospect?
	output reg [2:0] light_pros,  // Prospect Avenue Light
	output reg [2:0] light_wash   // Washington Road Light
);

	// Declare Local Vars Here
	reg [4:0] state;
	reg [4:0] next_state;

	// Declare State Names Here
	localparam STATE_GREEN_1 = 4'd0;
	localparam STATE_GREEN_2 = 4'd1;
	localparam STATE_GREEN_3 = 4'd2;
	localparam STATE_GREEN_4 = 4'd3;


	localparam STATE_YELLOW_1 = 4'd4;

	localparam STATE_RED_1 = 4'd5;
	localparam STATE_RED_2 = 4'd6;
	localparam STATE_RED_3 = 4'd7;
	localparam STATE_RED_4 = 4'd8;


	localparam STATE_YELLOW_2 = 4'd9;

	// Light Colors
	localparam RED = 3'b001;
	localparam YLW = 3'b010;
	localparam GRN = 3'b100;

	// Output Combinational Logic
	always @( * ) begin
		light_pros = 3'b000;
		light_wash = 3'b000;

		// Write your output logic here
		if ( state == STATE_GREEN_1 || state == STATE_GREEN_2 || state == STATE_GREEN_3 || state == STATE_GREEN_4) begin
			light_pros = RED;
			light_wash = GRN;
		end

		else if (state == STATE_YELLOW_1) begin
			light_pros = RED;
			light_wash = YLW;
		end

		else if (state == STATE_RED_1 || state == STATE_RED_2 || state == STATE_RED_3 || state == STATE_RED_4) begin
			light_pros = GRN;
			light_wash = RED;
		end
		else if (state == STATE_YELLOW_2) begin
			light_pros = YLW;
			light_wash = RED;
		end
	end

	// Next State Combinational Logic
	always @( * ) begin
		// Write your Next State Logic Here
		next_state = state;
		if (state == STATE_GREEN_1) begin
			next_state = STATE_GREEN_2;
		end
		else if (state == STATE_GREEN_2) begin
			next_state = STATE_GREEN_3;
		end
		else if (state == STATE_GREEN_3) begin
			next_state = STATE_GREEN_4;
		end
		else if (!car_present && state == STATE_GREEN_4) begin
			next_state = STATE_GREEN_4;
		end
		else if (car_present && state == STATE_GREEN_4) begin
			next_state = STATE_YELLOW_1;
		end
		else if (state == STATE_YELLOW_1) begin
			next_state = STATE_RED_1;
		end
		else if (state == STATE_RED_1) begin
			next_state = STATE_RED_2;
		end
		else if (state == STATE_RED_2) begin
			next_state = STATE_RED_3;
		end
		else if (state == STATE_RED_3) begin
			next_state = STATE_RED_4;
		end
		else if (state == STATE_RED_4) begin
			next_state = STATE_YELLOW_2;
		end
		else if (state == STATE_YELLOW_2) begin
			next_state = STATE_GREEN_1;
		end

	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= STATE_GREEN_1;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end

endmodule
