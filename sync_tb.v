`timescale 1ns/1ps

module tb_sync_updowncounter;

  logic        clk;
  logic        rst_n;
  logic        load_en;
  logic        up_pulse;
  logic        down_pulse;
  logic        load_pulse;
  logic        load_value;   
  logic [16:0] count;
  logic        pulse;

  // DUT
  sync_updowncounter dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .load_en    (load_en),
    .up_pulse   (up_pulse),
    .load_pulse (load_pulse),
    .load_value (load_value),
    .down_pulse (down_pulse),
    .count      (count),
    .pulse      (pulse)
  );
  initial clk = 0;
  always #5 clk = ~clk;
  initial 
    begin
    rst_n      = 0;
    load_en   = 0;
    up_pulse  = 0;
    down_pulse= 0;
    load_pulse= 0;
    load_value= 0;
    #20;
    rst_n = 1;
      // up logic
    repeat (300) begin
      @(posedge clk);
      up_pulse = 1;
      @(posedge clk);
      up_pulse = 0;
    end
// down logic
    load_en = 1;
    load_pulse = 1;

    repeat (300) begin
      @(posedge clk);
      down_pulse = 1;
      @(posedge clk);
      down_pulse = 0;
    end

    #50;
    $finish;
  end
  initial begin
    $monitor("T=%0t,load_en=%b,up=%b,down=%b,count=0x%h,pulse=%b",
              $time, load_en, up_pulse, down_pulse, count, pulse);
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
