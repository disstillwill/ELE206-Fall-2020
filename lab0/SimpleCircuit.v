module SimpleCircuit(
	input a,
	input b,
	input c,
	output f
);
	wire d;

	assign d = a || b;
	assign f = d && c;
endmodule
