`timescale 1ns/1ps

module register_file_tb;

   // Declare inputs as registers
   reg clk;
   reg reset_n;
   reg [4:0] read_reg1;
   reg [4:0] read_reg2;
   reg [4:0] write_reg;
   reg [31:0] write_data;
   reg        reg_write; // Write enable signal

   // Declare outputs as wires
   wire [31:0] read_data1;
   wire [31:0] read_data2;

   // Instantiate the Register File module under test
   // Make sure register_file.v is in the same directory or included
   register_file dut (
                      .clk(clk),
                      .reset_n(reset_n),
                      .read_reg1(read_reg1),
                      .read_reg2(read_reg2),
                      .write_reg(write_reg),
                      .write_data(write_data),
                      .reg_write(reg_write),
                      .read_data1(read_data1),
                      .read_data2(read_data2)
                      );

   // Clock generation
   parameter T = 10; // Clock period
   always #((T)/2) clk = ~clk; // Generate clock with 50% duty cycle

   // Helper task for writing to a register
   task write_reg_task;
      input [4:0] addr;
      input [31:0] data;
      begin
         write_reg = addr;
         write_data = data;
         reg_write = 1; // Assert write enable
         @(posedge clk); #1; // Wait for the positive clock edge where write happens
         reg_write = 0; // Deassert write enable after the edge
         // Inputs can be changed after the edge
      end
   endtask

   // Helper task for reading from registers
   task read_regs_task;
      input [4:0] addr1;
      input [4:0] addr2;
      begin
         read_reg1 = addr1;
         read_reg2 = addr2;
         // Reads are combinational, data should be available after a short delay
         #1; // Wait a small delta time for combinatorial logic
         $display("Time: %0d | Read Reg1 (%0d): %h, Read Reg2 (%0d): %h",
                  $time, addr1, read_data1, addr2, read_data2);
      end
   endtask


   // Test stimulus
   initial
     begin
        $display("Starting Register File Testbench...");

        // Initialize inputs
        clk = 0;
        reset_n = 0;
        read_reg1 = 5'b0;
        read_reg2 = 5'b0;
        write_reg = 5'b0;
        write_data = 32'h0;
        reg_write = 0;

        // Apply reset sequence
        #((T)*2); // Hold reset for 2 clock cycles
        reset_n = 1; // Release reset
        #T; // Wait one more clock cycle

        $display("--- After Reset ---");
        // Read from register 0 and another (should be 0 and uninitialized)
        read_regs_task(5'd0, 5'd1); // Read reg 0 and reg 1

        $display("--- Writing to registers ---");

        // Write data to register 5
        write_reg_task(5'd5, 32'hAABBCCDD);
        #T; // Wait one clock cycle

        // Write data to register 10
        write_reg_task(5'd10, 32'h11223344);
        #T; // Wait one clock cycle

        // Attempt to write to register 0 (should not change its value)
        $display("Time: %0d | Attempting to write to reg 0...", $time);
        write_reg_task(5'd0, 32'hDEADBEEF); // This write should be ignored by the DUT
        #T; // Wait one clock cycle

        $display("--- Reading from written registers ---");

        // Read from register 5 and 10
        read_regs_task(5'd5, 5'd10); // Should read AABBCCDD and 11223344
        #T; // Wait one clock cycle

        // Read from register 0 and register 1 (reg 0 still 0, reg 1 likely uninitialized)
        read_regs_task(5'd0, 5'd1); // Should read 0 and whatever is in reg 1
        #T; // Wait one clock cycle

        $display("--- Testing read during write ---");
        fork
           $display("Time: %0d | Reading during write (Regs %0d, %0d)...", $time, read_reg1, read_reg2);
           $display("Time: %0d | Read Data1: %h, Read Data2: %h", $time, read_data1, read_data2);
           // Write to register 15 and read from it and another register in the same cycle
           write_reg_task(5'd15, 32'hCAFEF00D);
           read_regs_task(5'd15, 5'd5);
           #1; // Wait a delta time - combinational read should give the OLD value of reg 15
        join

        // Wait for the write to complete on the clock edge
        @(posedge clk);

        #T; // Wait one full clock cycle after the write

        $display("Time: %0d | Reading after write (Regs %0d, %0d)...", $time, read_reg1, read_reg2);
        // Read again after the write has taken effect
        read_regs_task(5'd15, 5'd5); // Should now read the NEW value (CAFEF00D) from reg 15
        #T;

        $display("Register File Testbench finished.");
        $finish; // End simulation
     end

endmodule
