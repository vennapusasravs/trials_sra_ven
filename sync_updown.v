module sync_updowncounter (
  input  logic clk,         //input clock signal 
  input  logic rst_n,       //Asynchronus active low reset signal
  input  logic load_en,     // 0 = UP, 1 = DOWN
  input  logic up_pulse,    //input for the upcounter logic
  input logic load_pulse,   //input to the updowncounter whenever load_pulse is there then we are bale to load data
  input logic load_value,   //value that is loaded into counter (86400)
  input  logic down_pulse,  //input for the downcounter logic
  output logic [16:0] count, // 17 bit count value
  output logic pulse         //output pulse that looks for count 256,3600,86400
);
//logic for updowncounter
  always_ff @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
      begin
      count <= 17'h0;
      pulse <= 1'b0;
     end
    else 
       begin
      pulse <= 1'b0;
     if (load_en && load_pulse)
	 begin
        count <= 17'h15180;   // load 86400
      end	  
      // up logic
      else if (!load_en & up_pulse) 
        begin
        count <= count + 17'h1;
          if ((count + 17'h1 )== 17'h100) || ((count + 17'h1) == 17'hE10  )  || ((count + 17'h1) == 17'h15180) pulse <= 1'b1;
          else if (count==17'h15181) count<=17'h0;
        end
      // downlogic
         else if (load_en & down_pulse & load_pulse & count != 17'h00000) 
        begin
        count <= count - 17'h1;
          if ((count - 17'h1) == 17'h100) || ((count - 17'h)1 == 17'hE10) || (count - 17'h1 )== 17'h15180) pulse <= 1'b1;
      end
    end
  end
endmodule
