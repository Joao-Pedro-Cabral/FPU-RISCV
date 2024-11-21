
package ieee_float_pkg;

  import config_pkg::*;

  localparam integer Bias = (2**Exponent) - 1;

  typedef struct packed {
    logic sign;
    logic [Exponent-1:0] exp;
    logic [Fraction-1:0] frac;
  } ieee_float;

endpackage
