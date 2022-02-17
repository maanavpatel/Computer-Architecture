// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
     wire a, b, c ,d;
  
  or or1(b, A, B);
  xor xor1(d, A, B);
  nor no1(c, A, B);
  and a1(a, A, B);
  
  mux4 mu1(out, a, b, c, d, control);
endmodule // logicunit

