
module float_normalizer #(
  parameter int N = 8
) (
  input  logic [2*N-1:0] A,
  output logic [N-1:0] Y,
  output logic [$clog2(N):0] msb_pos
);

logic [$clog2(N):0] msb_pos_;
logic [3*N-1:0] A2 = {A, {N{1'b0}}};

priority_encoder #(
  .N(2*N)
) encoder (
  .A(A),
  .Y(msb_pos_),
  .empty()
);

assign Y = A2[msb_pos_+:N];

assign msb_pos = msb_pos_;

endmodule
