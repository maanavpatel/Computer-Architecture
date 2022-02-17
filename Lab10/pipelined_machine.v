module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4_new,PC_plus4, PC_target;
    wire [31:0]  inst, inst_pre;

    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rd = inst[15:11];
    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    
    wire [4:0]   wr_regnum, wr_regnum_MW;
    wire [2:0]   ALUOp, ALUOp_MW;

    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
    wire [31:0]  rd1_data_new, rd2_data_MW, rd2_data_new, alu_out_data_MW;

    wire         PCSrc, zero, w_Fwd_A, w_Fwd_B, w_stall;
    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         RegWrite_MW, BEQ_MW, ALUSrc_MW, MemRead_MW, MemWrite_MW, MemToReg_MW, RegDst_MW;
    
  	assign w_stall = ((rs == wr_regnum_MW) && ~(rs == 0) || (rt == wr_regnum_MW) && ~(rt == 0)) && (MemRead_MW);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~w_stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_new, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_pre, PC[31:2]);
    register #(32) if_deimem(inst, inst_pre, clk, ~w_stall, PCSrc || reset);
    register #(30) if_de_pcp4(PC_plus4_new, PC_plus4, clk, ~w_stall, PCSrc || reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data_new,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) fwd_a_mux(rd1_data_new, rd1_data, alu_out_data_MW, w_Fwd_A);
   	mux2v #(32) fwd_b_mux(rd2_data, rd2_data_new, alu_out_data_MW, w_Fwd_B);

    mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data_new, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);


    assign w_Fwd_A = (RegWrite_MW && (rs == wr_regnum_MW) && ~(rs == 0));
  	assign w_Fwd_B = (RegWrite_MW && (rt == wr_regnum_MW) && ~(rt == 0));

    mips_decode m_decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);
    
    register #(1) beq_MW(BEQ_MW, BEQ, clk, 1'b1, PCSrc);
    register #(3) aluop_MW(ALUOp_MW, ALUOp, clk, 1'b1, PCSrc);
    register #(1) alusrc_MW(ALUSrc_MW, ALUSrc, clk, 1'b1, PCSrc);
    register #(1) memread_MW(MemRead_MW, MemRead, clk, 1'b1, PCSrc);
    register #(1) mem_wrt_MW(MemWrite_MW, MemWrite, clk, 1'b1, PCSrc);
    register #(1) mem_2reg_MW(MemToReg_MW, MemToReg, clk, 1'b1, PCSrc);
    register #(1) reg_dst_MW(RegDst_MW, RegDst, clk, 1'b1, PCSrc);
    register #(1) regwrite_MW(RegWrite_MW, RegWrite, clk, 1'b1, PCSrc);
    
    
  	register #(32) alu_rslt_MW(alu_out_data_MW, alu_out_data, clk, 1'b1, PCSrc);
  	register #(32) fwd_b_MW(rd2_data_MW, rd2_data, clk, 1'b1, PCSrc);
  	register #(5) regnum_MW(wr_regnum_MW, wr_regnum, clk, 1'b1, PCSrc);

    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);
    mux2v #(32) wrback_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);

endmodule // pipelined_machine