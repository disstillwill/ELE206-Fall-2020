module Popcount(
  input [2:0] bitstring,
  output [1:0] popcount
);
  reg [1:0] popcount;
  reg y1, y2, y3;
  reg z1, z2, z3, z4;

  // INSERT LOGIC HERE
  
  always @( * ) begin
    
    // Count number of 1s for output y (higher order)
    y1 = ~bitstring[2] & (bitstring[1] & bitstring[0]);
    y2 = bitstring[2] & (~bitstring[1] & bitstring[0]);
    y3 = bitstring[2] & bitstring[1];
    popcount[1] = y1 | (y2 | y3);

    // Count number of 1s for output z (lower order)
    z1 = ~bitstring[2] & (~bitstring[1] & bitstring[0]);
    z2 = ~bitstring[2] & (bitstring[1] & ~bitstring[0]);
    z3 = bitstring[2] & (~bitstring[1] & ~bitstring[0]);
    z4 = bitstring[2] & (bitstring[1] & bitstring[0]);
    popcount[0] = z1 | (z2 | (z3 | z4));

  end

endmodule
