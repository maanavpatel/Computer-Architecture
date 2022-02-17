module alu1_test;

    // cycle through all combinations of A, B, C, D every 16 time units
    reg A = 0;
    always #1 A = !A;
    
    reg B = 0;
    always #2 B = !B;
    
    reg carryin = 0;
    always #3 carryin = !carryin;
   
    reg [2:0] control = 0; 
     
    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 16 control = 2; // wait 16 time units (why 16?) and then set it to 2
        # 16 control = 3; // wait 16 time units and then set it to 3
        # 16 control = 4; // wait 16 time units and then set it to 4
        # 16 control = 5; // wait 16 time units and then set it to 5
        # 16 control = 6; // wait 16 time units and then set it to 6
        # 16 control = 7; // wait 16 time units and then set it to 7

        # 16 $finish; // wait 16 time units and then end the simulation
    end

    wire out, carryout;
    alu1 al1(out, carryout, A, B, carryin, control);

    // you really should be using gtkwave instead
    
    initial begin
        $display("A B control carryin carryout out");
        $monitor("%d %d %d %d %d %d (at time %t)", A, B, control, carryin, carryout, out, $time);
    end
endmodule // alu1_test