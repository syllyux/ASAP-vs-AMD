`default_nettype none

module top #(parameter WIDTH = 8, LENGTH = 4, ARR_NUM = 2) (
  input  logic signed [ARR_NUM-1:0][LENGTH-1:0][WIDTH-1:0] ch1_patch_arr, ch2_patch_arr,
  input  logic signed [ARR_NUM-1:0][LENGTH-1:0][WIDTH-1:0] wt_ch1_arr, wt_ch2_arr,
  input  logic valid_in,
  input  logic acc_clear,
  input  logic clk, rst_l, 

  output logic [ARR_NUM-1:0] valid_out_arr, // should be when output pixel is ready (every 4 cycles)
  output logic [ARR_NUM-1:0][WIDTH*2:0] output_arr
);

  genvar j; 
  generate
    for (j = 0; j < LENGTH; j = j + 1) begin: g2
      pePipeline #(WIDTH, LENGTH) pipe(.ch1_patch(ch1_patch_arr[j]), 
                                       .ch2_patch(ch2_patch_arr[j]), 
                                       .wt_ch1(wt_ch1_arr_[j]), wt_ch2
                                       .valid_in, 
                                       .acc_clear,
                                       .clk, .rst_l, 
                                       .valid_out(valid_out_arr[j]), 
                                       .sum(output_arr[j])); 
    end: g2
  endgenerate

endmodule: top