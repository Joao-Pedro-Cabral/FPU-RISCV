
import ieee_float_pkg::*;

module float_rounder #(
  parameter int N = 8
) (
  input logic sign,
  input logic [N-1:0] A,
  input logic [1:0] sticky,
  input round_mode_t round_mode,
  output logic [N:0] Y
);

logic round_up;

always @(*) begin
  unique case(round_mode)
    RNE: begin
      unique case(sticky)
        2'b00,
        2'b01: round_up = 1'b0;
        2'b10: round_up = A[0];
        default: round_up = 1'b1; // 2'b11
      endcase
    end
    RTZ: round_up = 1'b0;
    RDN: round_up = (|sticky) ? sign : 1'b0;
    RUP: round_up = (|sticky) ? ~sign : 1'b0;
    RMM: round_up = sticky[1];
    default: round_up = 1'bx; // Don't care
  endcase
end

assign Y = A + round_up;

endmodule
