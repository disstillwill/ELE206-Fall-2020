//==============================================================================
// Stoplight Testbench Module for Lab 4
//==============================================================================
`timescale 1ns/100ps

`include "Stoplight.v"

module StoplightTest;

	// Local Vars
	reg clk = 1;
	reg rst = 0;
	reg car = 0;
	wire [2:0] lp, lw;

	// Light Colors
	localparam GRN = 3'b100;
	localparam YLW = 3'b010;
	localparam RED = 3'b001;

	// VCD Dump
	initial begin
		$dumpfile("StoplightTest.vcd");
		$dumpvars;
	end

	// Stoplight Module
	Stoplight light(
		.clk        (clk),
		.rst        (rst),
		.car_present(car),
		.light_pros (lp),
		.light_wash (lw)
	);

	// Clock
	always begin
		#2.5 clk = ~clk;
	end

	// Main Test Logic
	initial begin
		
		#1; 
		// Time 1  
		// The FSM’s rst signal goes high.
		rst = 1; 

		#5;  
		// Time 6
		// The FSM’s rst signal goes low.
		rst = 0;

		#1; 
		if (lp !== RED || lw !== GRN) begin
			$display("Error at time %t", $time);
		end


		#34;  
		// Time 41
		// The car signal goes high, indicating that a car is waiting on Prospect Avenue.
		car = 1;

		#1;
		if (lp !== RED || lw !== GRN) begin
			$display("Error at time %t", $time);
		end

		#4; 
		// Time 46
		// The car is still waiting at the light.
		car = 1; 

		#1;
		if (lp !== RED || lw !== YLW) begin
			$display("Error at time %t", $time);
		end

		#4; 
		// Time 51
		// After seeing a green light, the car on Prospect leaves, and the car signal goes low.
		car = 0; 

		#1; 
		if (lp !== GRN || lw !== RED) begin
			$display("Error at time %t", $time);
		end

		#14; 
		// Time 66
		// A steady stream of cars begins to appear on Prospect, keeping the car signal high.
		car = 1;

		#1;
		if (lp !== GRN || lw !== RED) begin
			$display("Error at time %t", $time);
		end

		#4; 
		// Time 71
		// The car signal is still high.
		car = 1;

		#1; 
		if (lp !== YLW || lw !== RED) begin
			$display("Error at time %t", $time);
		end

		#4; 
		// Time 76 
		// One last car gets trapped on Prospect as the light switches to red. The car signal remains high.
		car = 1;

		#1;
		if (lp !== RED || lw !== GRN) begin
			$display("Error at time %t", $time);
		end

		#9; 
		// Time 86
		// The car on Prospect makes a right turn on red, and the car signal goes low.
		car = 0; 

		#1;
		if (lp !== RED || lw !== GRN) begin
			$display("Error at time %t", $time);
		end

		#19; 
		// Time 106
		// A car is sighted on Prospect, and the car signal goes high.
		car = 1;


		#1;
		if (lp !== RED || lw !== GRN) begin
			$display("Error at time %t", $time);
		end

		#9;
		// Time 116
		//  The car on Prospect makes a left turn on green, and car goes to zero.
		car = 0;

		#1;
		if (lp !== GRN || lw !== RED) begin
			$display("Error at time %t", $time);
		end

		#14; 
		// Time 131
		// Another car shows up on Prospect, and car goes high.
		car = 1;

		#1;
		if (lp !== GRN || lw !== RED) begin
			$display("Error at time %t", $time);
		end

		#4;  
		// Time 136
		// The final car leaves, and car falls back to zero.
		car = 0;


		#1;
		if (lp !== YLW || lw !== RED) begin
			$display("Error at time %t", $time);
		end
		
		#3; 
		// Time 140
		// The simulation ends.
		$finish;
	end

endmodule

