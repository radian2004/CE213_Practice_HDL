// program_counter.v
// This module implements the Program Counter, which holds the address
// of the instruction being fetched. In this simple single-cycle datapath,
// it increments by 4 on each clock cycle for sequential instruction execution.

module program_counter
  (
   input wire        clk,     // Clock signal
   input wire        reset_n, // Reset signal
   output reg [31:0] pc_out   // Output: Current value of the Program Counter (byte address)
   );

   // Initial PC value (start execution from byte address 0)
   // This happens when the simulation starts.
   initial
     begin
        pc_out = 32'b0;
     end

   // Update PC on the positive clock edge or on reset
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        begin
           // On reset, set the PC back to the starting address (0)
           pc_out <= 32'b0;
        end
      else
        begin
           // For sequential instruction execution, increment the PC by 4
           // (since each instruction is 4 bytes = 1 word)
           // For branching/jumping, you would have logic here (e.g., a MUX)
           // to select the next PC based on control signals and branch/jump addresses.
           pc_out <= pc_out + 32'd4;
        end
   end

endmodule
