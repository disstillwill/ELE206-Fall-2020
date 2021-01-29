module Popcount_test;
  reg [3:0] counter;
  wire [1:0] out;

  Popcount circuit_under_test(
    .bitstring(counter[2:0]),
    .popcount(out)
  );

  always @( * ) begin
    if (counter[3]) begin
      $finish;
    end
  end

  initial begin
    $dumpfile("Popcount_test.vcd");
    $dumpvars;

    counter = 4'b0000;

    while (1) begin
      #1  // Delay for one second
      counter = counter + 3'b001;
    end
  end

endmodule
