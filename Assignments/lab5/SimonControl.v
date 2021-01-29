//==============================================================================
// Control Module for Simon Project
//==============================================================================

module SimonControl(
	// External Inputs
	input        clk,           // Clock
	input        rst,           // Reset

	// Datapath Inputs
	input		 curr_eq_last, 	//
	input		 ptrn_eq_input, //
	input		 is_legal,		//
	input		 curr_level,	//

	// Datapath Control Outputs
	output reg	 level_ld,		// Signal to load selected level on start
	output reg	 first_ld,		// 
	output reg	 first_clr,		//
	output reg	 last_ld,		//
	output reg	 last_clr,		//
	output reg	 curr_ld,		//
	output reg	 curr_set,		//
	output reg	 show_input,	//
	output reg	 w_en,

	// External Outputs
	output reg  [2:0] mode_leds	//
);

	// Declare Local Vars Here
	// reg [X:0] state;
	// reg [X:0] next_state;
	reg [2:0]	state;
	reg [2:0]	next_state;

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// Declare State Names Here
	//localparam STATE_ONE = 2'd0;
	localparam STATE_START = 3'd0;
	localparam STATE_INPUT = 3'd1;
	localparam STATE_PLAYBACK = 3'd2;
	localparam STATE_REPEAT = 3'd3;
	localparam STATE_DONE = 3'd4;

	// Output Combinational Logic
	always @( * ) begin
		
		// Set defaults
		mode_leds = 3'b000;
		w_en = 0;
		show_input = 0;
		level_ld = 0;
		// For first reg
		first_ld = 0;
		first_clr = 0;
		// For last reg
		last_ld = 0;
		last_clr = 0;
		// For current reg
		curr_set = 0;
		curr_ld = 0;
		
		// Write your output logic here
		if (state == STATE_INPUT) begin
			mode_leds = LED_MODE_INPUT;
			w_en = 1;
			show_input = 1;
			curr_set = 1;
			curr_ld = 1;
		end
		else if (state == STATE_PLAYBACK) begin
			mode_leds = LED_MODE_PLAYBACK;
			if (!curr_eq_last) begin
				curr_ld = 1;
			end
			else begin
				curr_set = 1;
				curr_ld = 1;
			end
		end
		else if (state == STATE_REPEAT) begin
			mode_leds = LED_MODE_REPEAT;
			show_input = 1;
			if (!ptrn_eq_input) begin
				curr_set = 1;
				curr_ld = 1;
			end
			else if (ptrn_eq_input && curr_eq_last) begin
				first_ld = 1;
				last_ld = 1;
			end
			else begin
				curr_ld = 1;
			end
		end
		else if (state == STATE_DONE) begin
			mode_leds = LED_MODE_DONE;
			curr_ld = 1;
		end

		if (rst) begin
			level_ld = 1;
			first_clr = 1;
			last_clr = 1;
		end
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;

		if (state == STATE_INPUT) begin
			// Easy mode and illegal input
			if (!curr_level && !is_legal) begin
				next_state = STATE_INPUT;
			end
			// Hard mode or both easy mode and legal input
			else begin
				next_state = STATE_PLAYBACK;
			end
		end
		else if (state == STATE_PLAYBACK) begin
			if (curr_eq_last) begin
				next_state = STATE_REPEAT;
			end
			else begin
				next_state = STATE_PLAYBACK;
			end
		end
		else if (state == STATE_REPEAT) begin
			if (!ptrn_eq_input) begin
				next_state = STATE_DONE;
			end
			else if (ptrn_eq_input && curr_eq_last) begin
				next_state = STATE_INPUT;
			end
			else begin
				next_state = STATE_REPEAT;
			end
		end
		else if (state == STATE_DONE) begin
			next_state = STATE_DONE;
		end
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= STATE_INPUT;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end

endmodule
