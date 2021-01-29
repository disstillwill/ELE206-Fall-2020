module Decoder3x8(
  input [2:0] i,
  output [7:0] d
);

  reg [7:0] d;

  always @( * ) begin

    // Avoid implicit latching
    {d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7]} = 8'b0;

    case (i)
      3'd0: begin
        d[0] = 1'b1;
      end
      3'd1: begin
        d[1] = 1'b1;
      end
      3'd2: begin
        d[2] = 1'b1;
      end
      3'd3: begin
        d[3] = 1'b1;
      end
      3'd4: begin
        d[4] = 1'b1;
      end
      3'd5: begin
        d[5] = 1'b1;
      end
      3'd6: begin
        d[6] = 1'b1;
      end
      3'd7: begin
        d[7] = 1'b1;
      end
    endcase
  end

endmodule
