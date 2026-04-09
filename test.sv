`default_nettype none

module tb_pePipeline;

  localparam int WIDTH  = 8;
  localparam int LENGTH = 4;

  logic signed [LENGTH-1:0][WIDTH-1:0] ch1_patch, ch2_patch;
  logic signed [LENGTH-1:0][WIDTH-1:0] wt_ch1, wt_ch2;
  logic valid_in;
  logic acc_clear;
  logic clk;
  logic rst_l;

  logic valid_out;
  logic [WIDTH*2:0] sum;

  pePipeline #(
    .WIDTH(WIDTH),
    .LENGTH(LENGTH)
  ) DUT (.*);

  always #5 clk = ~clk;

  initial begin
    $monitor($time,, "valid_out = %b, sum = %0d", valid_out, $signed(sum));

    clk = 0;
    rst_l = 0;
    valid_in = 0;
    acc_clear = 0;

    ch1_patch = '{8'sd1, 8'sd2, 8'sd3, 8'sd4};
    ch2_patch = '{8'sd5, 8'sd6, 8'sd7, 8'sd8};
    wt_ch1    = '{8'sd1, 8'sd1, 8'sd1, 8'sd1};
    wt_ch2    = '{8'sd1, 8'sd1, 8'sd1, 8'sd1};

    #20;
    rst_l = 1;
    valid_in = 1;

    #10;
    valid_in = 0;

    #300;

    $finish;
  end

endmodule