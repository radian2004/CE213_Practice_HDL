module instruction_memory
  (
   input wire [31:0]  address,    // Byte address from PC
   output wire [31:0] instruction // Instruction at that address
   );

   // Instruction memory array: e.g., 1024 words (4KB)
   // MIPS PC provides byte addresses, but memory is typically accessed in words.
   // We use address[31:2] to get the word index (address / 4).
   // The size [0:1023] means 1024 words, which is 1024 * 4 = 4096 bytes (4KB).
   reg [31:0] imem [0:1023];

   // Initialize instruction memory from a file
   // The file ("instructions.txt") should contain hexadecimal machine code,
   // one instruction per line. $readmemh reads hexadecimal values.
   // The file path is relative to where the simulation is run.
   initial
     begin
        $readmemh("D:/STUDY/HDL/Practice/Lab456/instructions.txt", imem);
        // You can specify a start and end address for loading if needed:
        // $readmemh("instructions.txt", imem, start_addr, end_addr);
        $display("Instruction memory loaded from instructions.txt");
     end

   // Read instruction based on the PC address (word-aligned)
   // In a single-cycle design, reading from instruction memory is typically
   // treated as a combinational operation. The instruction is available
   // based on the current PC value.
   assign instruction = imem[address[31:2]];

endmodule
