
package float_pkg;

  import config_pkg::*;

  localparam integer Bias = (2**Exponent) - 1;

  typedef struct packed {
    logic sign;
    logic [Exponent-1:0] exp;
    logic [Fraction-1:0] frac;
  } float;

  typedef enum logic [2:0] {
    RNE,
    RTZ,
    RDN,
    RUP,
    RMM,
    DYN = 3'b111
  } round_mode_t;

endpackage
