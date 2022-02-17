// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    
    wire [31:0] PC, nPC, pc4_out, pc4_off;
    wire [1:0] alu_src2;
    wire write_enable, overflow, neg, rd_src, slt, zero, lui, mem_read;
    wire byte_we, addm, word_we, by_load;
    wire [31:0] rs_d, rt_d, addr, B, w_data, rd_d;
    wire [31:0] slt_o, data_o, byteo, mem_o, lui_o, B_o, addm_o;

    wire [2:0] alu_op;
    wire [4:0] w_addr;
    wire [7:0] byte_load;
    wire [1:0] control_type;
    

    wire [31:0] _slt;
    wire [31:0] _lui;
    wire [31:0] _bt_l;


    assign _slt [31:1] = 0;
    assign _slt [0] = neg;

    assign _lui [31:16] = inst[15:0];
    assign _lui [15:0] = 0;

    assign _bt_l [31:8] = 0;
    assign _bt_l [7:0] = byte_load;

    wire [31:0] se_o = {{16{inst[15]}}, inst[15:0]};
    wire [31:0] zero_ex = {16'h0000 ,inst[15:0]};

    wire [31:0] br_off = {se_o[29:0], 2'b00};
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nPC, clock, 1'b1, reset);


    wire [31:0] j;
    assign j[31:28] = PC[31:28];
    assign j[27:2] = inst[25:0];
    assign j[1:0] = 0;

    alu32 pc_4(pc4_out, , , , PC, 32'b100, `ALU_ADD);
    alu32 pc4_offset(pc4_off, , , , pc4_out, br_off, `ALU_ADD);
    mux4v control(nPC, pc4_out, pc4_off, j, rs_d, control_type);
    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rs_d, rt_d, inst[25:21], inst[20:16], w_addr, rd_d, write_enable, clock, reset);
    mux2v #(5) mx_rd(w_addr, inst[15:11], inst[20:16], rd_src);

    alu32 alu_addm(addm_o, , , , rt_d, data_o, 3'b010);

    mux3v mx2_b(B_o, rt_d, se_o, zero_ex, alu_src2);
    
    mux2v mx_addm(B, B_o, 32'b0, addm);
    mux2v mx_addo(rd_d, lui_o, addm_o, addm);
    alu32 alu_out(addr, overflow, zero, neg, rs_d, B, alu_op);

    mux2v mx_slt(slt_o, addr, _slt, slt);
    mux2v mx_mem(mem_o, slt_o, byteo, mem_read);
    mux2v mx_lui(lui_o, mem_o, _lui, lui);
    
    data_mem mem(data_o, addr, rt_d, word_we, byte_we, clock, reset);
    mux4v #(8) mx4(byte_load, data_o[7:0], data_o[15:8], data_o[23:16], data_o[31:24], addr[1:0]);
    
    mux2v mx_byte(byteo, data_o, _bt_l, by_load);

    mips_decode mipsd1(alu_op, write_enable, rd_src, alu_src2, except, control_type,
                       mem_read, word_we, byte_we, by_load, slt, lui, addm,
                       inst[31:26], inst[5:0], zero);


endmodule // full_machine
