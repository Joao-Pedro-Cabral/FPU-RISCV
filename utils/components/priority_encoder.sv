
module priority_encoder #(
  parameter integer N = 8,
  parameter integer LogN = N == 1 ? 0 : $clog2(N)-1
) (
  input logic [N-1:0] A,
  output logic [LogN:0] Y,
  output logic empty
);

localparam N2 = N/2 + (N%2);

logic [LogN:0] [N2-1:0] [LogN:0] tmp;
logic [LogN:0] [N2-1:0] sel;

// Tree Structure
generate
  for(genvar i = 0; i <= LogN; i = i + 1) begin: gen_tree_line
    for(genvar j = 0; j < N2; j = j + 1) begin: gen_tree_nodes
      if(i == LogN) begin: gen_init_line
        if(2*j < N - 1) begin: gen_two_node
          assign sel[i][j] = A[2*j] | A[2*j + 1];
          assign tmp[i][j] = A[2*j + 1] ? (2*j+1) : 2*j; 
        end else begin: gen_one_node
          assign sel[i][j] = A[2*j];
          assign tmp[i][j] = 2*j;
        end
      end else begin: gen_other_lines
        if(2*j < N2 - 1) begin: gen_two_node
          assign sel[i][j] = sel[i+1][2*j] | sel[i+1][2*j+1];
          assign tmp[i][j] = sel[i+1][2*j+1] ? tmp[i+1][2*j + 1] : tmp[i+1][2*j];
        end else if (2*j == N2 - 1) begin: gen_one_node
          assign sel[i][j] = sel[i+1][2*j];
          assign tmp[i][j] = tmp[i+1][2*j];
        end else begin: gen_zero_node
          assign sel[i][j] = 0;
          assign tmp[i][j] = 0;
        end
      end
    end
  end
endgenerate

assign Y = tmp[0][0];
assign empty = ~sel[0][0];

endmodule
