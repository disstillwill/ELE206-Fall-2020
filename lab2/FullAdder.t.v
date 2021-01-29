//==============================================================================
// Test Unit for Full Adder
//==============================================================================

`include "FullAdder.v"

// Macro for creating an adder test case
`define ADDER_TEST_CASE(AP, BP, CIP, SP, COP)                          \
	a = AP;                                                            \
	b = BP;                                                            \
	ci = CIP;                                                          \
	#5;                                                                \
	if (s !== SP || co !== COP) begin                                  \
		$display("\nTest Case Failure!:\n",                            \
		         "\tA(%h), B(%h), CI(%h) => ", a, b, ci,               \
		         "S(%h), CO(%h)\n", s, co,                             \
		         "\t         Expected => S(%h), CO(%h)", SP, COP);     \
		err_cnt = err_cnt + 1;                                         \
	end else begin                                                     \
		pass_cnt = pass_cnt + 1;                                       \
	end                                                                \
	#5

// Tester Module
module FullAdderTest;

	// Local Vars
	reg a, b, ci;
	wire s, co;
	reg [3:0] err_cnt = 0;
	reg [3:0] pass_cnt = 0;

	// VCD Dump
	initial begin
		$dumpfile("FullAdderTest.vcd");
		$dumpvars;
	end

	// Full Adder Module
	FullAdder fa(
		.a (a),
		.b (b),
		.ci(ci),
		.s (s),
		.co(co)
	);

	// Main Test Logic
	initial begin
		$display("\nBeginning Tests");
		$display("========================");
		//               a  b  ci s  co
		`ADDER_TEST_CASE(0, 0, 0, 0, 0);
		`ADDER_TEST_CASE(0, 0, 1, 1, 0);
		`ADDER_TEST_CASE(0, 1, 0, 1, 0);
		`ADDER_TEST_CASE(0, 1, 1, 0, 1);
		`ADDER_TEST_CASE(1, 0, 0, 1, 0);
		`ADDER_TEST_CASE(1, 0, 1, 0, 1);
		`ADDER_TEST_CASE(1, 1, 0, 0, 1);
		`ADDER_TEST_CASE(1, 1, 1, 1, 1);

		$display("\nTests Completed. %d Passed, %d Failed.\n", pass_cnt, err_cnt);
		$display("========================");
		$finish;
	end

endmodule
