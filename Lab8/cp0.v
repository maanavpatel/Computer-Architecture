`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14
 
module cp0(rd_data, EPC, TakenInterrupt,
          wr_data, regnum, next_pc,
          MTC0, ERET, TimerInterrupt, clock, reset);
   output [31:0] rd_data;
   output [29:0] EPC;
   output        TakenInterrupt;
   input  [31:0] wr_data;
   input   [4:0] regnum;
   input  [29:0] next_pc;
   input         MTC0, ERET, TimerInterrupt, clock, reset;
 
   wire [31:0] user_stats;
   wire [31:0] cause_reg, status_reg;
   wire [31:0] epc2b0;
   wire [31:0] enableCombined;
   wire [29:0] mux_to_epc_d;
   wire explvl_reset, exp_lvl;
   wire epc_reg_enable;
 //  wire userstat_enable;
    assign status_reg[31:16] = {16{1'b0}};
   assign status_reg[15:8] = user_stats[15:8];
   assign status_reg[7:2] = 6'b0;
   assign status_reg[0] = user_stats[0];
   assign status_reg[1] = exp_lvl;
 
   assign TakenInterrupt = (cause_reg[15] & status_reg[15])  &  (~status_reg[1] & status_reg[0]);
 
   assign cause_reg[14:0] = {15{1'b0}};
   assign cause_reg[15] = TimerInterrupt;
   assign cause_reg[31:16]  = {16{1'b0}};
 
   assign epc2b0 = {EPC, 2'b0};
 
   or (explvl_reset, reset, ERET);
   or(epc_reg_enable, enableCombined[14], TakenInterrupt);
 
 
 
   register #(32) user_stat_reg(user_stats, wr_data, clock, enableCombined[12], reset);
   mux2v #(30) takenIntMux(mux_to_epc_d, wr_data[31:2], next_pc, TakenInterrupt);
   decoder32 decode1(enableCombined , regnum, MTC0);
   register #(1) exception_lvl(exp_lvl, 1'd1, clock, TakenInterrupt, explvl_reset);
   register #(30) epc_reg(EPC, mux_to_epc_d, clock, epc_reg_enable, reset);
   mux3v #(32) muxbig(rd_data, status_reg, cause_reg, epc2b0, regnum[1:0]);
 
 
   // your Verilog for coprocessor 0 goes here
endmodule
