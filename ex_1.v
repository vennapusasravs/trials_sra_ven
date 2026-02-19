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


   
   
	 