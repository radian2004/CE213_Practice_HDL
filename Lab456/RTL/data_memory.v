// data_memory.v
module data_memory (
                    input wire        clk,
                    input wire [31:0] address,    // Byte address
                    input wire [31:0] write_data, // Data to write
                    input wire        mem_read,   // Control signal for read
                    input wire        mem_write,  // Control signal for write
                    output reg [31:0] read_data   // Data read from memory
                    );

   // Memory array: 1024 words (4KB), each word is 32 bits
   // MIPS uses byte addressing, but memory is typically accessed in words.
   // We use address[31:2] to get the word index (address / 4).
   reg [31:0] memory [0:1023];

   // Memory write operation (on positive clock edge if MemWrite is asserted)
   always @(posedge clk)
     begin
        if (mem_write)
          begin
             // Access memory by word address
             memory[address[31:2]] <= write_data;
          end
        else
          begin
             memory[address[31:2]] <= memory[address[31:2]];
          end
     end

   // Memory read operation (combinational)
   // Data is available based on address and MemRead.
   // Note: In a real system, read access might take time, but in a single-cycle
   // datapath model, it's often treated as combinational for simplicity.
   always @(*)
     begin
        if (mem_read)
          begin
             // Access memory by word address
             read_data = memory[address[31:2]];
          end
        else
          begin
             // Output zero or high-impedance when not reading, depending on design
             read_data = 32'b0; // Output zero when not reading
          end
     end
endmodule
