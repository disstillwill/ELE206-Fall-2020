module Popcount(
  input [2:0] bitstring,
  output [1:0] popcount
);

  // INSERT LOGIC HERE
  wire y, y1, y2, y3;
  wire z, z1, z2, z3, z4;

  // Count number of 1s for output y (higher order)
  assign y1 = ~bitstring[2] & (bitstring[1] & bitstring[0]);
  assign y2 = bitstring[2] & (~bitstring[1] & bitstring[0]);
  assign y3 = bitstring[2] & bitstring[1];
  assign y = y1 | (y2 | y3);

  // Count number of 1s for output z (lower order)
  assign z1 = ~bitstring[2] & (~bitstring[1] & bitstring[0]);
  assign z2 = ~bitstring[2] & (bitstring[1] & ~bitstring[0]);
  assign z3 = bitstring[2] & (~bitstring[1] & ~bitstring[0]);
  assign z4 = bitstring[2] & (bitstring[1] & bitstring[0]);
  assign z = z1 | (z2 | (z3 | z4));

  // Assign the higher and lower bits of popcount to y and z respectively
  assign popcount[1] = y;
  assign popcount[0] = z;

endmodule
