`include "Latch_structural.v"

module MemBlock(
  input x,
  input y,
  output q,
  output nq
);

  // INSERT LOGIC HERE

  // Declare additional wires
  wire out1, out2;
  wire in1, in2;

  // Instantiate three Latch module instances

  // Top
  Latch latch1(.ns(in2), .nr(x), .q(), .nq(out1));

  // Split three-input NAND since Latch uses two-input NAND
  assign in1 = out1 & x;

  // Bottom
  Latch latch2(.ns(in1), .nr(y), .q(out2), .nq(in2));

  // Final
  Latch latch3(.ns(out1), .nr(out2), .q(q), .nq(nq));

endmodule
