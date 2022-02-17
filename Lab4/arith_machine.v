module arith_machine(except, clock, reset);
   output      except;
   input       clock, reset;
 
   wire [31:0] inst; 
   wire [31:0] PC; 
 
   wire [31:0] nextPC;
   wire [31:0] A_data;
   wire [31:0] B_data;
   wire [31:0] B_wire;
   wire [31:0] W_data;
   wire[4:0] W_addr;
 
   wire [31:0] sign_ex;
   wire [31:0] zero_ex;
 
   wire[1:0] alu_src2;
   wire[2:0] alu_op;
  
   wire writeenable;
   wire rd_src;
 
 
   assign sign_ex = {{16{inst[15]}}, inst[15:0]};
   assign zero_ex = {16'h0000 ,inst[15:0]};
 
   // DO NOT comment out or rename this module
   // or the test bench will break
 
   register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
 
   // DO NOT comment out or rename this module
   // or the test bench will break
 
   instruction_memory im(inst, PC[31:2]);
 
   // DO NOT comment out or rename this module
   // or the test bench will break
 
   mips_decode mips1(rd_src, writeenable, alu_src2, alu_op,  except, inst[31:26], inst[5:0]);
 
   regfile rf (A_data, B_data, inst[25:21], inst[20:16], W_addr,  W_data,  writeenable, clock, reset);
 
   /* add other modules */
 
   alu32 pcplus4(nextPC, , , , PC, 32'h4, `ALU_ADD);
 
   mux2v #(5) mux_small(W_addr, inst[15:11], inst[20:16], rd_src );
   mux3v #(32) mux_big(B_wire, B_data, sign_ex, zero_ex, alu_src2);
 
   alu32 alu_beeg(W_data, , , , A_data, B_wire, alu_op);


    
   
endmodule // arith_machine

