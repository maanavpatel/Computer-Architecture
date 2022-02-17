// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

    
    wire w_op0 = opcode == `OP_OTHER0;

    //regular
    wire w_add = w_op0 & (funct == `OP0_ADD);
    wire w_sub = w_op0 & (funct == `OP0_SUB);
    wire w_and = w_op0 & (funct == `OP0_AND);
    wire w_or = w_op0 & (funct == `OP0_OR);
    wire w_nor = w_op0 & (funct == `OP0_NOR);
    wire w_xor = w_op0 & (funct == `OP0_XOR);

    //immediate
    wire w_addi = (opcode == `OP_ADDI);
    wire w_andi = (opcode == `OP_ANDI);
    wire w_ori = (opcode == `OP_ORI);
    wire w_xori = (opcode == `OP_XORI);

    assign alu_op[0] = (w_sub | w_or | w_xor | w_ori | w_xori);
    assign alu_op[1] = (w_add | w_sub | w_xor | w_nor | w_addi | w_xori);
    assign alu_op[2] = (w_and | w_or | w_nor | w_xor | w_xori | w_andi | w_ori);

    nor nr1(except, w_add , w_sub , w_and , w_or , w_nor , w_xor , w_addi , w_andi , w_ori , w_xori);
    assign alu_src2[1] =  w_andi | w_ori | w_xori;
    assign alu_src2[0] = w_addi;
    assign rd_src = w_andi | w_addi | w_ori | w_xori;
    wire writeenable = ~except;



    


endmodule // mips_decode
