
module mux2_1 (
  input a,
  input b,
  input sel,
  output logic y);
  always_comb begin
    y = sel ? b:a;
  end
endmodule
