`default_nettype none

module processingElement #(parameter WIDTH = 8, LENGTH = 4) (
  input  logic signed [LENGTH-1:0][WIDTH-1:0] ch1_patch, ch2_patch,
  input  logic signed [WIDTH-1:0] wt_ch1, wt_ch2,
  input  logic signed [WIDTH*2:0] psum_in,
  input  logic             valid_in,
  input  logic             acc_clear,
  input  logic             clk, rst_l, 
  input  logic [$clog2(LENGTH)-1:0] patch_idx, 

  output logic             valid_out, 
  output logic [WIDTH*2:0] psum_out
);

  logic signed [WIDTH*2:0] mac_result;

  mac #(WIDTH) mcdonalds (
    .wt_ch1, .wt_ch2,
    .ch1_patch(ch1_patch[patch_idx]), .ch2_patch(ch2_patch[patch_idx]),
    .result(mac_result)
  );

  // Accumulator reg
  always_ff @(posedge clk, posedge acc_clear) begin
    if (acc_clear || ~rst_l) begin 
      psum_out <= 'b0; 
      valid_out <= 1'b0;
    end 
    else begin 
      psum_out <= psum_in + mac_result; 
      valid_out <= valid_in; // handles stalling
    end 
  end

endmodule: processingElement

// TODO: need to clear for 1 cycle after each sum 
// Example: cycle 1, ch1_patch_1 (4 pixels) into PE0, chooses first pixel
// Cycle 2, ch1_patch_2 (4 pixels) into PE0, but PE1 chooses second pixel from ch1_patch_1 --> pipeline
module pePipeline #(parameter WIDTH = 8, LENGTH = 4) (
  input  logic signed [LENGTH-1:0][WIDTH-1:0] ch1_patch, ch2_patch,
  input  logic signed [LENGTH-1:0][WIDTH-1:0] wt_ch1, wt_ch2,
  input  logic valid_in,
  input  logic acc_clear,
  input  logic clk, rst_l, 

  output logic             valid_out, 
  output logic [WIDTH*2:0] sum
);

  logic [LENGTH-1:0][WIDTH-1:0] ch1_arr, ch2_arr; 
  logic   [LENGTH:0][WIDTH*2:0] psum_arr;
  logic              [LENGTH:0] valid_arr; 

  assign psum_arr[0] = 'b0; 
  assign valid_arr[0] = valid_in;

  genvar i; 
  generate
    for (i = 0; i < LENGTH; i = i + 1) begin: g1
      processingElement #(WIDTH) pe(.ch1_patch, .ch2_patch, 
                                    .wt_ch1(wt_ch1[i]), .wt_ch2(wt_ch2[i]), 
                                    .psum_in(psum_arr[i]), 
                                    .valid_in(valid_arr[i]), 
                                    .acc_clear, 
                                    .clk, .rst_l, 
                                    .patch_idx(i), 
                                    .valid_out(valid_arr[i+1]), 
                                    .psum_out(psum_arr[i+1])
                                    );
    end: g1
  endgenerate

  assign sum = psum_arr[LENGTH]; 
  assign valid_out = valid_arr[LENGTH]; 

endmodule: pePipeline