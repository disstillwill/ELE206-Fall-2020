module Latch(
  input ns,
  input nr,
  output q,
  output nq
);

  // INSERT LOGIC HERE
  assign q = ~(ns & ~(q & nr));
  assign nq = ~(nr & ~(nq & ns));

endmodule
