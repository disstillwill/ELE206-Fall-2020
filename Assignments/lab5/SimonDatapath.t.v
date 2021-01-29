//===============================================================================
// Testbench Module for Simon Datapath
//===============================================================================
`timescale 1ns/100ps

`include "SimonDatapath.v"

// Print an error message (MSG) if value ONE is not equal
// to value TWO.
`define ASSERT_EQ(ONE, TWO, MSG)               \
	begin                                      \
		if ((ONE) !== (TWO)) begin             \
			$display("\t[FAILURE]:%s", (MSG)); \
		end                                    \
	end #0

// Set the variable VAR to the value VALUE, printing a notification
// to the screen indicating the variable's update.
// The setting of the variable is preceeded and followed by
// a 1-timestep delay.
`define SET(VAR, VALUE) $display("Setting %s to %s...", "VAR", "VALUE"); #1; VAR = (VALUE); #1

// Cycle the clock up and then down, simulating
// a button press.
`define CLOCK $display("Pressing uclk..."); #1; clk = 1; #1; clk = 0; #1

`define INSERT(PTRN) $display("Inserting pattern..."); #1;\
				#1; first_ld = 0; \
				last_ld = 0; \
				pattern = PTRN; #1; \
				 #1; clk = 1; #1; clk = 0; #1;\
				#1; first_ld = 1; \
				last_ld = 1; #1; \
				 #1; clk = 1; #1; clk = 0; #1

module SimonDatapathTest;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	reg level = 0;
	reg [3:0] pattern = 4'b0000;
	
	// Input regs
	reg level_ld = 0;
	reg first_ld = 0;
	reg first_clr = 0;
	reg last_ld = 0;
	reg last_clr = 0;
	reg curr_ld = 0;
	reg curr_set = 0;
	reg show_input = 0;
	reg w_en = 0;

	// Output wires
	wire curr_eq_last;
	wire ptrn_eq_input;
	wire is_legal;
	wire curr_level;
	wire [3:0] pattern_leds;
	

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	integer idx;
	initial begin
		$dumpfile("SimonDatapathTest.vcd");
		$dumpvars;
		for (idx = 0; idx < 64; idx = idx + 1) begin
			$dumpvars(0, dpath.mem.mem[idx]);
		end
	end

	// Simon Control Module
	SimonDatapath dpath(
		.clk     (clk),
		.rst     (rst),
		.level   (level),
		.pattern (pattern),
		.level_ld (level_ld),
		.first_ld (first_ld), 
		.first_clr (first_clr),
		.last_ld (last_ld),
		.last_clr (last_clr),
		.curr_ld (curr_ld),
		.curr_set (curr_set),
		.show_input (show_input),
		.w_en (w_en),
		.curr_eq_last (curr_eq_last),
		.ptrn_eq_input (ptrn_eq_input),
		.is_legal (is_legal),	
		.pattern_leds (pattern_leds)
	);

	// Main Test Logic
	initial begin
		// Your Test Logic Here

		// Reset memory block
		$display("\nResetting memory block...");
		`SET(rst, 1);
		`CLOCK;
		`SET(rst, 0);

		// Mimic start state
		`SET(first_clr, 1);
		`SET(last_clr, 1);
		`SET(level_ld, 1);
		`CLOCK;
		`SET(first_clr, 0);
		`SET(last_clr, 0);
		`SET(level_ld, 0);
		
		// Mimic input state, write first pattern in memory
		$display("\nWriting first pattern in memory...");
		`SET(curr_set, 1);
		`SET(curr_ld, 1);
		`SET(w_en, 1);
		`SET(pattern, 4'b0001);
		`CLOCK;
		`SET(curr_set, 0);
		`SET(curr_ld, 0);
		$display("\ncurr_eq_last is %b", curr_eq_last);
		$display("\nPattern leds is %b and pattern is %b.", pattern_leds, pattern);
		`ASSERT_EQ(pattern, pattern_leds, "Pattern leds are not equal to the most recent pattern!");

		// Check detection of legal easy-mode patterns
		$display("\nChecking illegal pattern detection");
		`SET(pattern, 4'b0101); // illegal pattern 
		`ASSERT_EQ(is_legal, 0, "Illegal pattern not detected!");
		$display("\nChecking legal pattern detection");
		`SET(pattern, 4'b0001); // legal pattern 
		`ASSERT_EQ(is_legal, 1, "Illegal pattern not detected!");

		
		// Assert that newly stored pattern in memory equals current input
		$display("\nChecking if newly stored pattern equals input...");
		`SET(pattern, 4'b1010);
		`CLOCK;
		$display("\nPattern leds is %b and pattern is %b.", pattern_leds, pattern);
		`ASSERT_EQ(pattern, pattern_leds, "Pattern leds are not equal to the most recent pattern!");
		
		// Increment indices and loads the second new pattern
		$display("\nChecking if second stored pattern equals input...");
		`SET(first_ld, 1);
		`SET(last_ld, 1);
		`CLOCK;
		$display("\ncurr_eq_last is %b", curr_eq_last);
		`SET(first_ld, 0);
		`SET(last_ld, 0);
		`SET(curr_set, 1);
		`SET(curr_ld, 1);
		`SET(w_en, 1);
		`SET(pattern, 4'b0110);
		`CLOCK;
		`SET(curr_set, 0);
		`SET(w_en, 0);
		`CLOCK;
		`SET(curr_ld, 0);
		$display("\nPattern leds is %b and pattern is %b.", pattern_leds, pattern);
		`ASSERT_EQ(pattern, pattern_leds, "Pattern leds are not equal to the most recent pattern!");
		

		
		// Checks the two patterns stored in memory
		`SET(curr_set, 1);
		`SET(curr_ld, 1);
		
		`CLOCK;
		$display("\ncurr_eq_last is %b", curr_eq_last);
		$display("First pattern in memory is %b...", pattern_leds);
		`SET(curr_set, 0);
		`CLOCK;
		$display("\ncurr_eq_last is %b", curr_eq_last);
		$display("Second pattern in memory is %b...", pattern_leds);
		`SET(curr_ld, 0);

		$display("All tests passed!");

		// TODO: Test that level_reg is set correctly on resets
		// TODO: Test pattern equals input
		// TODO: Test show_input for high signal and low signal
		// TODO: Test wrap-around (loop to store 64 patterns in mem?)
		// TODO: Test DONE state wrap-around more

		// Reset memory block
		$display("\nResetting memory block...");
		`SET(rst, 1);
		`CLOCK;
		`SET(rst, 0);
		// Resetting the indices
		`SET(first_clr, 1);
		`SET(last_clr, 1);
		`CLOCK;
		`SET(first_clr, 0);
		`SET(last_clr, 0);
		`SET(curr_set, 1);
		`SET(curr_ld, 1);
		`SET(show_input, 0);
		`SET(w_en, 1);
		`CLOCK;
		`ASSERT_EQ(1'b1, curr_eq_last, "Current should be equal to last!");
		`SET(curr_set, 0);
		`SET(curr_ld, 0);

		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);
		`INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001); `INSERT(4'b0001);

		`SET(first_ld, 0);
		`SET(last_ld, 0);
		`SET(pattern, 4'b1111);
		`CLOCK;
		

		$display("\nPattern leds are %b.", pattern_leds);
		`ASSERT_EQ(1'b1, curr_eq_last, "Current should be equal to last!");
		`ASSERT_EQ(4'b1111, pattern_leds, "Wrap-around logic is incorrect!");

		`SET(curr_set, 1);
		`SET(curr_ld, 1);
		`SET(w_en, 0);
		`CLOCK;
		$display("\nPattern leds are %b.", pattern_leds);
		`ASSERT_EQ(1'b0, curr_eq_last, "Current should not be equal to last!");
		`ASSERT_EQ(4'b0001, pattern_leds, "Wrap-around logic is incorrect!");
		

		$finish;
	end

endmodule
