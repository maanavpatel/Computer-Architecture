module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;

   or oCol(w1, a, b, c);
   or oW(valid, w2, w3, w4, w5);

   //and gates
   and a1(w2, w1, d);   //D
   and a2(w3, w1, e);   //E
   and a3(w4, w1, f);   //F
   and a4(w5, b, g);    //BG

   //assign bits for output number
   assign number[3] = (b && f) || (c && f);
   assign number[2] = (a && e) || (c && e) || (b && e)  || (a && f);
   assign number[1] = (b && d) || (c && e) || (c && d) || (a && f);
   assign number[0] = (a && d) || (b && e) || (c && d) || (a && f) || (c && f);

  
   


endmodule // keypad
