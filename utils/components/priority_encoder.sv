
module priority_encoder #(
  parameter integer N = 8,
  parameter integer LogN = N == 1 ? 0 : $clog2(N)-1
) (
  input logic [N-1:0] A,
  output logic [LogN:0] Y,
  output logic empty
);

genvar i, j;

logic [LogN:0] [LogN:0] [LogN:0] tmp;

// Tree Structure
generate
  for(i = 0; i <= LogN; i = i + 1) begin: gen_tree_line
    for(j = 0; j < 2**i; j = j + 1) begin: gen_tree_nodes
      if(i == LogN) begin: gen_init_line
        assign tmp[i][j] = A[2*j + 1] ? (2*j+1) : 2*j;  
      end else begin: gen_other_lines
        assign tmp[i][j] = A[(2**(LogN - i) + 1)*j + (2**(LogN - i))] ? tmp[i+1][2*j + 1] : tmp[i+1][2*j];  
      end
    end
  end
endgenerate

assign Y = tmp[0][0];
assign empty = ~(|A);

endmodule
