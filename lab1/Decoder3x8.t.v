module Decoder3x8_test;
  reg [4:0] counter;
  wire [7:0] out;

  Decoder3x8 circuit_under_test(
    .i(counter[2:0]),
    .d(out)
  );

  always @( * ) begin
    if (counter[4]) begin
      $finish;
    end
  end

  initial begin
    $dumpfile("Decoder3x8_test.vcd");
    $dumpvars;

    counter = 5'b00000;

    while (1) begin
      #1  // Delay for one second
      counter = counter + 3'b001;
    end
  end

endmodule
