<<<<<<< HEAD
// Code your design here
module ff1 (
input sig_A,  // input for the first flipflop
input clk_A,  // clock for the first flipflop
input clk_B,  //clock foe next flipflops
input rst_n,   //asynchronus active low reset
output logic xor_out); //overall output
logic xor_reg;  //interrnal signal from xor gate to first flop
logic q1_reg;   //internal signal from ff1 to ff1
logic q2_reg;   //internal signal from ff2 to ff3
logic q3_reg;   //internal signal from ff3 to ff4
logic q4_reg;   //internal signal from ff4 to output xor gate 
// output of xor acts as input to ff1
assign xor_reg = q1_reg ^ sig_A;
// logic for ff1
always_ff @ (posedge clk_A or negedge rst)
   if(!rst) q1_reg <= 1'b0;
   else q1_reg <= xor_reg;
   //logic for ff2
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q2_reg <= 1'b0;
   else q2_reg <= q1_reg;
   // logic for ff3
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q3_reg <= 1'b0;
   else q3_reg <= q2_reg;
   //logic for ff4
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q4_reg <= 1'b0;
   else q4_reg <= q3_reg;
   //output logic
assign xor_out = q3_reg ^ q4_reg;
endmodule


   
   
=======
// Code your design here
module ff1 (
input sig_A,
input clk_A,
input clk_B,
input rst,
output logic xor_out);
logic xor_reg;
logic q1_reg;
logic q2_reg;
logic q3_reg;
logic q4_reg;
// output of xor acts as input to ff1
assign xor_reg = q1_reg ^ sig_A;
always_ff @ (posedge clk_A or negedge rst)
   if(!rst) q1_reg <= 1'b0;
   else q1_reg <= xor_reg;
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q2_reg <= 1'b0;
   else q2_reg <= q1_reg;
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q3_reg <= 1'b0;
   else q3_reg <= q2_reg;
always_ff @ (posedge clk_B or negedge rst)
   if(!rst) q4_reg <= 1'b0;
   else q4_reg <= q3_reg;
assign xor_out = q3_reg ^ q4_reg;
endmodule


   
   
>>>>>>> 2f6e0c0417285751c97f77488ba909d7dbd77cbb
	 