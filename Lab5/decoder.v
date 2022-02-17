// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//19.29/20 <- early

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire w_op0 = opcode == `OP_OTHER0;
 
  //Lab 4
  wire w_add = w_op0 & (funct == `OP0_ADD);
  wire w_sub = w_op0 & (funct == `OP0_SUB);
  wire w_and = w_op0 & (funct == `OP0_AND);
  wire w_or = w_op0 & (funct == `OP0_OR);
  wire w_nor = w_op0 & (funct == `OP0_NOR);
  wire w_xor = w_op0 & (funct == `OP0_XOR);
 
  wire w_addi = (opcode == `OP_ADDI);
  wire w_andi = (opcode == `OP_ANDI);
  wire w_ori = (opcode == `OP_ORI);
  wire w_xori = (opcode == `OP_XORI);
 
  //Lab 5 new
  wire w_bne = (opcode == `OP_BNE);
  wire w_beq = (opcode == `OP_BEQ);
  wire w_j = (opcode == `OP_J);
  wire w_jr = w_op0 & (funct == `OP0_JR);
  wire w_lw = (opcode == `OP_LW);
  wire w_lbu = (opcode == `OP_LBU);
  wire w_sw = (opcode == `OP_SW);
  wire w_sb = (opcode == `OP_SB);
 
  wire w_lui = (opcode == `OP_LUI);
  wire w_slt = w_op0 & (funct == `OP0_SLT);
  wire w_addm = w_op0 & (funct == `OP0_ADDM);
 
 
  assign rd_src = w_andi | w_addi | w_ori | w_xori | w_lw | w_lui | w_lbu;
 
  assign alu_op[0] = (w_sub | w_or | w_xor | w_ori | w_xori | w_bne | w_beq | w_slt);
  assign alu_op[1] = (w_add | w_sub | w_xor | w_nor | w_addi | w_xori | w_bne | w_beq | w_lw | w_lbu | w_sb | w_sw | w_slt | w_addm);
  assign alu_op[2] = (w_and | w_or | w_nor | w_xor | w_xori | w_andi | w_ori);
 
  assign alu_src2[1] =  w_andi | w_ori | w_xori;
  assign alu_src2[0] = w_addi | w_lw | w_lbu | w_sb | w_sw;
 
  assign mem_read = w_lw | w_lbu;
  assign word_we = w_sw;
  assign byte_we = w_sb;
  assign byte_load = w_lbu;
 
  assign slt = w_slt;
  assign lui = w_lui;
  assign addm = w_addm;
 
  assign control_type[0] = w_jr | (w_bne & !zero) | (w_beq & zero);
  assign control_type[1] = w_jr | w_j;
 
  //includes all wires?
  nor nr1(except, w_j, w_jr, w_beq, w_bne, w_lui, w_slt, w_sb, w_sw, w_lw, w_lbu, w_addm, w_add , w_sub , w_and , w_or , w_nor , w_xor , w_addi , w_andi , w_ori , w_xori);

  assign writeenable = ~(except | w_beq | w_bne | w_j | w_jr | w_sb | w_sw);
 
 

endmodule // mips_decode
