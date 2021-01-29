module Latch(
  input ns,
  input nr,
  output q,
  output nq
);

  reg q;
  reg nq;

  always @( * ) begin
    // INSERT LOGIC HERE
    if (ns & ~nr) begin
      q = 0;
      nq = 1;
    end
    else if (~ns & nr) begin
      q = 1;
      nq = 0;      
    end
    else if (~ns & ~nr) begin
      q = 1;
      nq =1;
    end
  end

endmodule
