
module float_normalizer_tb;

localparam integer N = 4;

logic [2*N-1:0] A;
logic [3*N-2:0] A2;
logic [N-1:0] Y, Y_;
logic [$clog2(N):0] msb_pos, msb_pos_;

function automatic [$clog2(N):0] floor_log2(input logic [2*N-1:0] A);
  logic [$clog2(N):0] msb_pos = 0;
  logic [2*N-1:0] tmp = A;
  begin
    while(tmp > 1) begin
      msb_pos ++;
      tmp = tmp >> 1;
    end
    return msb_pos;
  end
endfunction

float_normalizer #(
  .N(N)
) DUT (
  .A,
  .Y,
  .msb_pos
);

initial begin
  $display("SOT!");
  A = 0;
  msb_pos_ = 0;
  #5;
  for(int i = 0; i < 2**(2*N); i ++) begin
    A = i;
    #5;
    msb_pos_ = floor_log2(A);
    A2 = {A, {N-1{1'b0}}};
    Y_ = A2 >> msb_pos_;
    CHK_MSB: assert(msb_pos === msb_pos_);
    CHK_Y: assert(Y === Y_);
    #5;
  end
  $display("EOT!");
end

endmodule
