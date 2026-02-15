
module mux2_1 (
  input a,
  input b,
  input sel,
  output logic y);
   assign  y = sel ? b:a;
endmodule
