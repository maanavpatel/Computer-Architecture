module timer(TimerInterrupt, cycle, TimerAddress,
            data, address, MemRead, MemWrite, clock, reset);
   output        TimerInterrupt;
   output [31:0] cycle;
   output        TimerAddress;
   input  [31:0] data, address;
   input         MemRead, MemWrite, clock, reset;
 
   // complete the timer circuit here   nah
 
 
   wire acknowledge;
   wire [31:0] D_wire;
   wire [31:0] Q_wire;
   wire timerread;
   wire timerwrite;
   wire [31:0] interrupToEq;
   wire eqToIntLine;
   wire interlineReset;
 
 
   wire w1c;
   wire w6c;
 
   assign w1c = ('hffff001c == address);
   assign w6c = ('hffff006c == address);
 
 
   or timerAddress1(TimerAddress, w1c, w6c);
   and timerRead1(timerread, w1c, MemRead);
   and timerWrite1(timerwrite, w1c, MemWrite);
   and know1(acknowledge, w6c, MemWrite);
 
   assign eqToIntLine = (Q_wire == interrupToEq);
 
  
   assign interlineReset = (acknowledge|reset);
 
 
   // HINT: make your interrupt cycle register reset to 32'hffffffff
   //       (using the reset_value parameter)
   //       to prevent an interrupt being raised the very first cycle
 
 
   register c_counter(Q_wire, D_wire, clock, 1'd1, reset);
   alu32 alu1(D_wire, , , `ALU_ADD, Q_wire, 32'h1);
   tristate #(32) tRead(cycle, Q_wire, timerread);
   register #(32, 32'hffffffff) interrupt_cyc(interrupToEq, data, clock, timerwrite, reset);
   dffe interruptLine(TimerInterrupt, 1'd1, clock, eqToIntLine, interlineReset);
 
endmodule
 

