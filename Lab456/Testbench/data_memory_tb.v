`timescale 1ns/1ps

module data_memory_tb;

   // Declare inputs as registers
   reg clk;
   reg [31:0] address;    // Byte address
   reg [31:0] write_data; // Data to write
   reg        mem_read;   // Control signal for read
   reg        mem_write;  // Control signal for write

   // Declare output as a wire
   wire [31:0] read_data;   // Data read from memory

   // Instantiate the Data Memory module under test
   // Make sure data_memory.v is in the same directory or included
   data_memory dut (
                    .clk(clk),
                    .address(address),
                    .write_data(write_data),
                    .mem_read(mem_read),
                    .mem_write(mem_write),
                    .read_data(read_data)
                    );

   // Clock generation
   parameter T = 10; // Clock period
   always #((T)/2) clk = ~clk; // Generate clock with 50% duty cycle

   // Helper task for writing a word to a word address
   task write_mem_word_task;
      input [31:0] word_addr; // Word index (0, 1, 2, ...)
      input [31:0] data;
      reg [31:0]   byte_address;
      begin
         byte_address = word_addr * 4; // Calculate the corresponding byte address

         address = byte_address;
         write_data = data;
         mem_write = 1; // Assert write enable
         mem_read = 0;  // Ensure read is deasserted during write

         @(posedge clk); #1;// Wait for the positive clock edge where write happens

         mem_write = 0; // Deassert write enable after the edge
         // address and write_data can be changed after the edge
      end
   endtask

   // Helper task for reading a word from a word address
   task read_mem_word_task;
      input [31:0] word_addr; // Word index (0, 1, 2, ...)
      reg [31:0]   byte_address;
      begin
         byte_address = word_addr * 4; // Calculate the corresponding byte address

         address = byte_address;
         mem_read = 1; // Assert read enable
         mem_write = 0; // Ensure write is deasserted during read

         #1; // Wait a small delta time for combinatorial read logic

         $display("Time: %0d | Reading Word Address %0d (Byte Addr %h): %h",
                  $time, word_addr, byte_address, read_data);

         mem_read = 0; // Deassert read enable after reading
         // address can be changed after reading
      end
   endtask


   // Test stimulus
   initial
     begin
        $display("Starting Data Memory Testbench...");

        // Initialize inputs
        clk = 0;
        address = 32'h0;
        write_data = 32'h0;
        mem_read = 0;
        mem_write = 0;

        // Wait for a few initial cycles (optional, but good practice)
        #T;

        $display("--- Writing to memory ---");

        // Write some values to different word addresses
        write_mem_word_task(0, 32'hAABBCCDD); // Write 0xAABBCCDD to word 0 (byte address 0)
        #T; // Wait one clock cycle

        write_mem_word_task(1, 32'h11223344); // Write 0x11223344 to word 1 (byte address 4)
        #T; // Wait one clock cycle

        write_mem_word_task(2, 32'h55667788); // Write 0x55667788 to word 2 (byte address 8)
        #T; // Wait one clock cycle


        $display("--- Reading from written addresses ---");

        // Read back the values we just wrote
        read_mem_word_task(0); // Should read 0xAABBCCDD
        #T; // Wait one clock cycle

        read_mem_word_task(1); // Should read 0x11223344
        #T; // Wait one clock cycle

        read_mem_word_task(2); // Should read 0x55667788
        #T; // Wait one clock cycle


        $display("--- Testing write/read control signals ---");

        // Attempt to write with mem_write low (should not change memory)
        $display("Time: %0d | Attempting write with mem_write=0...", $time);
        address = 32'd12; // Byte address 12 (word address 3)
        write_data = 32'hDEADBEEF;
        mem_write = 0; // Keep write disabled
        mem_read = 0;
        @(posedge clk);
        #T; // Wait one clock cycle

        // Read the address we just attempted to write to (should be uninitialized/default)
        read_mem_word_task(3); // Read word address 3
        #T; // Wait one clock cycle

        // Attempt to read with mem_read low (should output 0 based on our DM module)
        $display("Time: %0d | Attempting read with mem_read=0...", $time);
        address = 32'd16; // Byte address 16 (word address 4)
        mem_read = 0; // Keep read disabled
        mem_write = 0;
        #1; // Wait a delta time
        $display("Time: %0d | Read Data (mem_read=0): %h", $time, read_data); // Should be 0
        #T; // Wait one clock cycle


        $display("--- Testing overwriting a memory location ---");

        // Write a new value to word address 1 (byte address 4)
        write_mem_word_task(1, 32'hCAFEF00D); // Overwrite the previous value
        #T; // Wait one clock cycle

        // Read word address 1 again
        read_mem_word_task(1); // Should now read 0xCAFEF00D
        #T; // Wait one clock cycle


        $display("--- Reading from an unwritten address ---");

        // Read from a word address that hasn't been explicitly written (e.g., word 25 = byte 100)
        read_mem_word_task(25);
        #T;


        $display("Data Memory Testbench finished.");
        $finish; // End simulation
     end

endmodule
