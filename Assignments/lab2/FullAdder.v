//==============================================================================
// One-Bit Full Adder Module
//==============================================================================

module FullAdder(
	input  a,  // Operand A
	input  b,  // Operand B
	input  ci, // Carry-In
	output s,  // Sum
	output co  // Carry-Out
);

	// Declare any internal wires you want to use here.

	// Write your code here. Use only continuous assignment
	// and bitwise operators.
	assign co = (a & b) || (a & ci) || (b & ci);
	assign s = a ^ b ^ ci;

endmodule
