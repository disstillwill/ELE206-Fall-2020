module SimpleCircuit_test;
	reg[3:0] counter;
	wire out;

	SimpleCircuit circuit_under_test(
		.a(counter[2]),
		.b(counter[1]),
		.c(counter[0]),
		.f(out)
	);

	always @( * ) begin
		if (counter[3]) begin
			$finish;
		end
	end

	initial begin
		$dumpfile("SimpleCircuit_test.vcd");
		$dumpvars;

		counter = 4'b0000;

		while (1) begin
			#1 // Delay for one second
			counter = counter + 3'b001;
		end
	end

endmodule
