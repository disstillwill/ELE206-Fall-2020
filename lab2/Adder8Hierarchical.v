//==============================================================================
// 8-bit Hierarchical Adder Module
//==============================================================================

`include "FullAdder.v"

module Adder8Hierarchical(
	input  [7:0] a,  // Operand A
	input  [7:0] b,  // Operand B
	input        ci, // Carry-In
	output [7:0] s,  // Sum
	output       co  // Carry-Out
);

	// Declare any internal wires you want to use here.
	wire co1, co2, co3, co4, co5, co6, co7;

	// Write your code here. Instantiate eight FullAdder modules
	// and connect them to the inputs and outputs appropriately.

	// Instantiate each FullAdder
	// The carry-out of each adder is the carry-in of the next adder
	FullAdder adder1(.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]), .co(co1));
	FullAdder adder2(.a(a[1]), .b(b[1]), .ci(co1), .s(s[1]), .co(co2));
	FullAdder adder3(.a(a[2]), .b(b[2]), .ci(co2), .s(s[2]), .co(co3));
	FullAdder adder4(.a(a[3]), .b(b[3]), .ci(co3), .s(s[3]), .co(co4));
	FullAdder adder5(.a(a[4]), .b(b[4]), .ci(co4), .s(s[4]), .co(co5));
	FullAdder adder6(.a(a[5]), .b(b[5]), .ci(co5), .s(s[5]), .co(co6));
	FullAdder adder7(.a(a[6]), .b(b[6]), .ci(co6), .s(s[6]), .co(co7));
	FullAdder adder8(.a(a[7]), .b(b[7]), .ci(co7), .s(s[7]), .co(co));

endmodule
