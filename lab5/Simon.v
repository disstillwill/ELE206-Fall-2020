//==============================================================================
// Simon Module for Simon Project
//==============================================================================

`include "SimonControl.v"
`include "SimonDatapath.v"

module Simon(
	input        pclk,
	input        rst,
	input        level,
	input  [3:0] pattern,

	output [3:0] pattern_leds,
	output [2:0] mode_leds
);

	// Declare local connections here
	
	wire level_ld;
	wire first_ld;
	wire first_clr;
	wire last_ld;
	wire last_clr;
	wire curr_ld;
	wire curr_set;
	wire show_input;
	wire w_en;
	wire curr_eq_last;
	wire ptrn_eq_input;
	wire is_legal;
	wire curr_level;

	//--------------------------------------------
	// IMPORTANT!!!! If simulating, use this line:
	//--------------------------------------------
	wire uclk = pclk;

	// Datapath -- Add port connections
	SimonDatapath dpath(
		.clk           (uclk),
		.rst(rst),
		.level         (level),
		.pattern       (pattern),

		// ...

		// Datapath Control Signals
		.level_ld (level_ld),
		.first_ld (first_ld), 
		.first_clr (first_clr),
		.last_ld (last_ld),
		.last_clr (last_clr),
		.curr_ld (curr_ld),
		.curr_set (curr_set),
		.show_input (show_input),
		.w_en (w_en),

		// Datapath Outputs to Control
		.curr_eq_last (curr_eq_last),
		.ptrn_eq_input (ptrn_eq_input),
		.is_legal (is_legal),
		.curr_level (curr_level),	
		.pattern_leds (pattern_leds)
	);

	// Control -- Add port connections
	SimonControl ctrl(
		.clk           (uclk),
		.rst           (rst),
		
		// ...
		
		// Datapath inputs
		.curr_eq_last (curr_eq_last),
		.ptrn_eq_input (ptrn_eq_input),
		.is_legal (is_legal),
		.curr_level (curr_level),

		// Datapath control outputs
		.level_ld (level_ld),
		.first_ld (first_ld),
		.first_clr (first_clr),
		.last_ld (last_ld),
		.last_clr (last_clr),
		.curr_ld (curr_ld),
		.curr_set (curr_set),
		.show_input (show_input),
		.w_en (w_en),

		// External outputs
		.mode_leds (mode_leds)
	);

endmodule
