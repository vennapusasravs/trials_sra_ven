module 4_1_mux(
  input [1:0]s,
  input a,b,c,d
  output  y);
  assign y = ((~s[0])&(~s[1])&a) & ((~s[0])&s[1]&b) &(s[0]&(~s[1])&c) & (s[0]&s[1]&d);
endmodule
