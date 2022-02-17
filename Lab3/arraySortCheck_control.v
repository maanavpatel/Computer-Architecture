
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;


	wire sGarbage, sReady, sIter, sCheck, sDns, sDs;

	/*
		Notes:

		+ go will come from user and will be 1 when circuit should be ready to start checking the array,
			 dropping to 0 to start a checking run on your arraySortCheck_circuit
			-> Once a checking run starts, it must be completed irrespective of the changes on the go signal
		+ If the go signal is 1 at the end of the run, then your circuit should get ready to start another checking run

		+ load_input, load_index and select_index == ouput (control signals)  ... sent to arraySortCheck_circuit
		+ The done signal should be 1 when your algorithm has terminated
		+ sorted = 1 if array is sorted
		+ sorted signal should be 0 when it is not indicating the result of the checking run
		+ These signals should maintain their value until you receive receive a new go signal, indicating that your machine should be ready to start a new run (RESET)

		+ Start in 'garbage', return to garbage when reset == 1, synchronous ... change to garbage on the cycle after reset
		+ control should be sync with circuit

	*/

   //Next state tracking

   wire sGarbNext = (~go & sGarbage) | reset;
   wire sReadyNext = ((sReady & go) | (sDs & go) | (sDns & go) | (sGarbage & go)) & ~reset;
   wire sCheckNext = (sIter | sReady & ~go) & ~reset;
   wire sDnsNext = ((sDns & ~go) | (sCheck & inversion_found)) & ~reset;
   wire sDsNext = ((sCheck & end_of_array) | (sCheck & zero_length_array) | (sDs & ~go)) & ~reset;
   wire sIterNext = (sCheck & ~inversion_found & ~end_of_array & ~zero_length_array) & ~reset;
  
   //Dffes
   dffe fsGarbage(sGarbage, sGarbNext, clock, 1'b1, 1'b0);
   dffe fReady(sReady, sReadyNext, clock, 1'b1, 1'b0);
   dffe fsIter(sIter, sIterNext, clock, 1'b1, 1'b0);
   dffe fsCheck(sCheck, sCheckNext, clock, 1'b1, 1'b0);
   dffe fsDs(sDs, sDsNext, clock, 1'b1, 1'b0);
   dffe fsDns(sDns, sDnsNext, clock, 1'b1, 1'b0);

   //Outputs
   assign sorted = sDs;
   assign load_input = sReady;
   assign load_index = sReady | sIter;
   assign select_index = sIter;
   assign done = sDns | sDs;

endmodule

