<<<<<<< HEAD
// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_ff1;
  logic sig_A;
  logic clk_A;
  logic clk_B;
  logic rst;
  logic xor_out;
  ff1 dut (
    .sig_A  (sig_A),
    .clk_A  (clk_A),
    .clk_B  (clk_B),
    .rst    (rst),
    .xor_out(xor_out)
  );

  // Clock A: 4 ns period (250 MHz)
  initial clk_A = 0;
  always #2 clk_A = ~clk_A;

  // Clock B: 1 ns period (5 GHz)
  initial clk_B = 0;
  always #0.5 clk_B = ~clk_B;

  // Reset generation (active-low)
  initial begin
    rst = 0;
    #30;
    rst = 1;
  end

  // sig_A stimulus (clk_A domain)
  initial begin
    sig_A = 0;
    wait(rst == 1);

    repeat (10) begin
      @(posedge clk_A);
      sig_A <= ~sig_A;
    end

    // Random toggling
    repeat (10) begin
      @(posedge clk_A);
      sig_A <= $random;
    end
  end

  // Monitor signals
  initial begin
    $display("Time  clk_A clk_B sig_A q1 q2 q3 q4 xor_out");
    $monitor("%0t   %b     %b     %b     %b  %b  %b  %b   %b",
             $time,
             clk_A, clk_B, sig_A,
             dut.q1_reg, dut.q2_reg, dut.q3_reg, dut.q4_reg,
             xor_out);
  end

  // End simulation
  initial begin
    #500;
    $finish;
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
    
=======
// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_ff1;
  logic sig_A;
  logic clk_A;
  logic clk_B;
  logic rst;
  logic xor_out;
  ff1 dut (
    .sig_A  (sig_A),
    .clk_A  (clk_A),
    .clk_B  (clk_B),
    .rst    (rst),
    .xor_out(xor_out)
  );

  // Clock A: 4 ns period (250 MHz)
  initial clk_A = 0;
  always #2 clk_A = ~clk_A;

  // Clock B: 1 ns period (5 GHz)
  initial clk_B = 0;
  always #0.5 clk_B = ~clk_B;

  // Reset generation (active-low)
  initial begin
    rst = 0;
    #30;
    rst = 1;
  end

  // sig_A stimulus (clk_A domain)
  initial begin
    sig_A = 0;
    wait(rst == 1);

    repeat (10) begin
      @(posedge clk_A);
      sig_A <= ~sig_A;
    end

    // Random toggling
    repeat (10) begin
      @(posedge clk_A);
      sig_A <= $random;
    end
  end

  // Monitor signals
  initial begin
    $display("Time  clk_A clk_B sig_A q1 q2 q3 q4 xor_out");
    $monitor("%0t   %b     %b     %b     %b  %b  %b  %b   %b",
             $time,
             clk_A, clk_B, sig_A,
             dut.q1_reg, dut.q2_reg, dut.q3_reg, dut.q4_reg,
             xor_out);
  end

  // End simulation
  initial begin
    #500;
    $finish;
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
    
>>>>>>> 2f6e0c0417285751c97f77488ba909d7dbd77cbb
endmodule