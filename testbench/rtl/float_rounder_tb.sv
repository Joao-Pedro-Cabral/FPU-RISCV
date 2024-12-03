
module float_rounder_tb;

import float_pkg::*;

localparam integer N = 4;

logic sign;
logic [N-1:0] A;
logic [1:0] sticky;
round_mode_t round_mode;
logic [N:0] Y;

function static check_round(input logic sign, input logic [N-1:0] A, input logic [1:0] sticky,
                            input round_mode_t round_mode, input logic [N:0] R);
  logic [N:0] R2;
  begin
    unique case(round_mode)
      RNE: begin
        if(sticky inside {2'b00, 2'b01}) R2 = A;
        else if(sticky == 2'b10) R2 = (A + A%2);
        else R2 = A + 1;
      end
      RTZ: R2 = A;
      RDN: begin
        if(sticky == 2'b00) R2 = A;
        else R2 = sign ? A + 1 : A;
      end
      RUP: begin
        if(sticky == 2'b00) R2 = A;
        else R2 = sign ? A: A + 1;
      end
      RMM: begin
        if(sticky[1]) R2 = A + 1;
        else R2 = A;
      end
      default: R2 = R; // Don't care
    endcase
    return (R2 == R);
  end
endfunction

float_rounder #(
  .N(N)
) DUT (
  .sign,
  .A,
  .sticky,
  .round_mode,
  .Y
);

initial begin
  $display("SOT!");
  A = 0;
  
  sticky = 0;
  sign = 0;
  #5;
  for(int i = 0; i < 2**N; i++) begin
    for(int j = 0; j < 4; j++) begin
      for(int k = 0; k < 2; k++) begin
        // In this case, DYN is not valid
        for(round_mode_t l = l.first(); l != l.last(); l = l.next()) begin
          A = i;
          sticky = j;
          sign = k;
          round_mode = l;
          #5;
          CHK_Y: assert(check_round(sign, A, sticky, round_mode, Y));
          #5;
        end
      end
    end
  end
  $display("EOT!");
end

endmodule
