
module float_rounder_tb;

localparam integer N = 4;

logic sign;
logic [N-1:0] A;
logic [1:0] sticky;
round_mode_t round_mode;
logic [N:0] Y;

function logic check_round(input logic sign, input logic [N-1:0] A, input logic [1:0] sticky,
                           input round_mode_t round_mode, input logic [N:0] R);
  logic [N:0] R2;
  real rounding;
  begin
    rounding = sticky/4.0;
    unique case(round_mode)
      RNE: begin
        R2 = floor(real'({sign, A, sticky})/4.0 + sign*0.5);
        R2 = (sticky == 2'b10) ? {R2 + R2%2} : R2;
      end
      RTZ: R2 = A;
      RDN: R2 = floor(real'({sign, A, sticky})/4.0);
      RUP: R2 = ceil(real'({sign, A, sticky})/4.0);
      RMM: R2 = floor(real'({sign, A, sticky[1]})/2.0 + sign*0.5);
      default: R2 = R; // Don't care
    endcase
    return (R2 == R);
  end
endfunction

float_rounder #(
  .N
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
        A = i;
        sticky = j;
        sign = k;
        #5;
        CHK_Y: assert(check_round(sign, A, sticky, round_mode, Y));
        #5;
      end
    end
  end
  $display("EOT!");
end

endmodule
