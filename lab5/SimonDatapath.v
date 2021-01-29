//==============================================================================
// Datapath for Simon Project
//==============================================================================

`include "Memory.v"

module SimonDatapath(
	// External Inputs
	input        clk,           // Clock
	input        rst,         // Switch for setting level
	input        level,         // Switch for setting level
	input  [3:0] pattern,       // Switches for creating pattern

	// Datapath Control Signals
	input		 level_ld,		// Signal to load selected level on start
	input		 first_ld,		// 
	input		 first_clr,		//
	input		 last_ld,		//
	input		 last_clr,		//
	input		 curr_ld,		//
	input		 curr_set,
	input		 show_input,	//
	input		 w_en,			//

	// Datapath Outputs to Control
	output reg curr_eq_last,	//
	output reg ptrn_eq_input, //
	output reg is_legal,		//
	output reg curr_level,	//

	// External Outputs 
	output reg [3:0] pattern_leds	// LED outputs for pattern
);

	// Declare Local Vars Here
	
	reg [5:0] first;
	reg [5:0] last;
	reg [5:0] current;
	reg level_reg;

	wire [3:0] curr_ptrn;
	//----------------------------------------------------------------------
	// Internal Logic -- Manipulate Registers, ALU's, Memories Local to
	// the Datapath
	//----------------------------------------------------------------------

	always @(posedge clk) begin
		// Sequential Internal Logic Here

		// first reg manipulation
		if (first_ld) begin
			if (first == 63) begin
					last <= 6'd0;
			end
			else if (first > last || last == 63) begin
				first <= first + 1'd1;
			end
		end
		if (first_clr) begin
			first <= 6'd0;
		end

		// last reg manipulation
		if (last_ld) begin
			if (last == 63) begin
				last <= 6'd0;
			end
			else begin
				last <= last + 6'd1;
			end
		end
		if (last_clr) begin
			last <= 6'd0;
		end

		// current reg manipulation
		if (curr_ld) begin
			if (curr_set) begin
				current <= first;
			end
			else begin
				if (current == 63) begin
					current <= 6'd0;
				end
				else if (current == last) begin
					current <= first;
				end
				else begin
					current <= current + 6'd1;
				end
			end
		end
		
		// curr_level reg manipulation
		if (level_ld) begin
			level_reg <= level; 
		end
	end

	// 64-entry 4-bit memory (from Memory.v) -- Fill in Ports!
	Memory mem(
		.clk     (clk),
		.rst     (rst),
		.r_addr  (current),
		.w_addr  (last),
		.w_data  (pattern),
		.w_en    (w_en),
		.r_data  (curr_ptrn)
	);

	//----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------

	always @( * ) begin
		// Output Logic Here

		// Output if current pattern input equals current pattern in memory
		if (pattern == curr_ptrn) begin
			ptrn_eq_input = 1;
		end
		else begin
			ptrn_eq_input = 0;
		end

		// Set pattern leds to either current pattern in memory or current pattern input
		if (show_input) begin
			pattern_leds = pattern;
		end
		else begin
			pattern_leds = curr_ptrn;
		end

		// Output if current pattern input is legal
		if (pattern == 4'b0001 || pattern == 4'b0010 || pattern == 4'b0100 || pattern == 4'b1000) begin
			is_legal = 1;
		end
		else begin
			is_legal = 0;
		end

		// Ouput if current equals last
		if (current == last) begin
			curr_eq_last = 1;
		end
		else begin
			curr_eq_last = 0;
		end

		curr_level = level_reg;


	end

endmodule
