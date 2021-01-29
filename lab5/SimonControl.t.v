//===============================================================================
// Testbench Module for Simon Controller
//===============================================================================
`timescale 1ns/100ps

`include "SimonControl.v"

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

module SimonControlTest;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	
	reg curr_eq_last = 0;
	reg ptrn_eq_input = 0;
	reg is_legal = 0;
	reg curr_level = 0;

	wire level_ld;
	wire first_ld;
	wire first_clr;
	wire last_ld;
	wire last_clr;
	wire curr_ld;
	wire curr_set;
	wire show_input;
	wire w_en;

	wire [2:0] mode_leds;


	// LED Light Parameters
	localparam LED_MODE_DEFAULT  = 3'b000;
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	initial begin
		$dumpfile("SimonControlTest.vcd");
		$dumpvars;
	end

	// Simon Control Module
	SimonControl ctrl(
		.clk (clk),
		.rst (rst),

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

	// Main Test Logic
	initial begin
		// Reset the game
		$display("Resetting controller...");
		`SET(rst, 1);
		`CLOCK;
		`SET(rst, 0);

		// Your Test Logic Here

		// Check correct output in Start state
		$display("Checking correct Start state output...");
		`ASSERT_EQ(mode_leds, LED_MODE_DEFAULT, "Incorrect mode LEDs START!");
		`ASSERT_EQ(level_ld, 1, "Failure line 103!");
		`ASSERT_EQ(first_clr, 1, "Failure line 104!");
		`ASSERT_EQ(last_clr, 1, "Failure line 105");

		// Transition to Input state
		$display("Transitioning from Start to Input...");
		`CLOCK;
		$display("Checking correct Input state output...");
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Incorrect mode LEDs for INPUT!");
		`ASSERT_EQ(w_en, 1, "Failure line 112");
		`ASSERT_EQ(show_input, 1, "Failure line 113!");
		`ASSERT_EQ(level_ld, 0, "Failure line 114!");
		`ASSERT_EQ(first_ld, 0, "Failure line 115!");
		`ASSERT_EQ(last_ld, 0, "Failure line 116!");
		`ASSERT_EQ(first_clr, 0, "Failure line 117!");		
		`ASSERT_EQ(last_clr, 0, "Failure line 118");

		// Check that illegal patterns in easy mode loop back to input state
		$display("Checking loop back to Input state...");
		`SET(curr_level, 0);
		`SET(is_legal, 0);
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Incorrect mode LEDs for INPUT!");
		
		// Check actions on transtion from Input state to Playback State
		$display("Checking actions on transition from Input to Playback...");
		`SET(curr_level, 0);
		`SET(is_legal, 1);
		`ASSERT_EQ(curr_set, 1, "Failure line 131!");
		`ASSERT_EQ(curr_ld, 1, "Failure line 132!");
		
		// Transition to Playback state
		$display("Transitioning from Input to Playback...");
		`CLOCK;
		$display("Checking correct Playback state output...");
		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Incorrect mode LEDs for PLAYBACK!");
		`SET(curr_eq_last, 0);
		`ASSERT_EQ(w_en, 0, "Failure line 140");
		`ASSERT_EQ(show_input, 0, "Failure line 141");
		`ASSERT_EQ(curr_set, 0, "Failure line 142!");
		`ASSERT_EQ(curr_ld, 1, "Failure line 143!");

		// Checks that Playback loops back when !curr_eq_last
		$display("Checking loop back to Playback state...");
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Incorrect mode LEDs for PLAYBACK!");
		`SET(curr_eq_last, 1);
		`ASSERT_EQ(w_en, 0, "Failure line 150");
		`ASSERT_EQ(show_input, 0, "Failure line 151");
		`ASSERT_EQ(curr_set, 1, "Failure line 152!");
		`ASSERT_EQ(curr_ld, 1, "Failure line 153!");

		// Transition to Repeat
		$display("Transitioning from Playback to Repeat...");
		`CLOCK;
		$display("Checking correct Repeat state output...");
		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Incorrect mode LEDs for REPEAT!");
		`SET(curr_eq_last, 0);
		`SET(ptrn_eq_input, 1);
		`ASSERT_EQ(show_input, 1, "Failure line 162");
		`ASSERT_EQ(curr_set, 0, "Failure line 163");
		`ASSERT_EQ(curr_ld, 1, "Failure line 164");

		// Checks that REPEAT loops back when !curr_eq_last
		$display("Checking loop back to Repeat state...");
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Incorrect mode LEDs for REPEAT!");

		// Checks that REPEAT goes to input when curr = last 
		$display("Transitioning from Repeat to Input...");
		`SET(curr_eq_last, 1);
		`SET(ptrn_eq_input, 1);
		`ASSERT_EQ(show_input, 1, "Failure line 175");
		`ASSERT_EQ(curr_set, 0, "Failure line 176");
		`ASSERT_EQ(curr_ld, 0, "Failure line 177");
		`ASSERT_EQ(first_ld, 1, "Failure line 178");
		`ASSERT_EQ(last_ld, 1, "Failure line 179");
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Incorrect mode LEDs for INPUT!");

		// Repeat actions and return to Repeat state
		$display("Repeating transitions second time...");
		`SET(curr_level, 1);
		`SET(is_legal, 0);
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "Incorrect mode LEDs for PLAYBACK!");
		`SET(curr_eq_last, 1);
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Incorrect mode LEDs for REPEAT!");
		
		// Check transition to DONE state
		$display("Transitioning from Repeat to Done...");
		`SET(ptrn_eq_input, 0);
		`ASSERT_EQ(show_input, 1, "Failure line 196");
		`ASSERT_EQ(curr_set, 1, "Failure line 197");
		`ASSERT_EQ(curr_ld, 1, "Failure line 198");
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_DONE, "Incorrect mode LEDs for DONE!");
		
		// Check looping back to Done state
		$display("Checking Loop back to Done state...");
		`SET(curr_eq_last, 0);
		`ASSERT_EQ(show_input, 0, "Failure line 205");
		`ASSERT_EQ(curr_set, 0, "Failure line 206");
		`ASSERT_EQ(curr_ld, 1, "Failure line 207");
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_DONE, "Incorrect mode LEDs for DONE!");

		$display("All tests passed!");
		
		$finish;
	end

endmodule
