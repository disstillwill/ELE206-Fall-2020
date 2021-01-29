module Decoder3x8(
  input [2:0] i,
  output [7:0] d
);

  // INSERT LOGIC HERE

  assign d[0] = ~i[2] & (~i[1] & ~i[0]);
  assign d[1] = ~i[2] & (~i[1] & i[0]);
  assign d[2] = ~i[2] & (i[1] & ~i[0]);
  assign d[3] = ~i[2] & (i[1] & i[0]);
  assign d[4] = i[2] & (~i[1] & ~i[0]);
  assign d[5] = i[2] & (~i[1] & i[0]);
  assign d[6] = i[2] & (i[1] & ~i[0]);
  assign d[7] = i[2] & (i[1] & i[0]);

endmodule
