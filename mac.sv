`default_nettype none

// Combinational MAC logic
module mac #(parameter WIDTH = 8) (
  input  logic signed [WIDTH-1:0] wt_ch1, wt_ch2,
  input  logic signed [WIDTH-1:0] ch1_patch, ch2_patch,
  output logic signed [WIDTH*2:0] result
);

  logic [WIDTH*2-1:0] prod_ch1;
  logic [WIDTH*2-1:0] prod_ch2;

  assign prod_ch1 = wt_ch1 * ch1_patch;
  assign prod_ch2 = wt_ch2 * ch2_patch;

  assign result = prod_ch1 + prod_ch2;

endmodule: mac

