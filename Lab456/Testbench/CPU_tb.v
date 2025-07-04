`timescale 1ns/1ps

module CPU_tb;

   // Clock and reset signals
   reg clk;
   reg reset_n;

   // Wires to connect to the datapath outputs (for monitoring)
   wire [31:0] current_pc;
   wire [31:0] current_instruction;
   wire [31:0] alu_result;
   wire [31:0] read_data_2;
   wire [31:0] mem_write_data;
   wire [31:0] mem_address;
   wire        mem_read;
   wire        mem_write;
   wire        reg_write;

   // Instantiate the top-level datapath module
   // Make sure all datapath sub-modules (.v files) are included in your project
   datapath dut (
                 .clk                 (clk),
                 .reset_n             (reset_n),
                 .current_pc          (current_pc),
                 .current_instruction (current_instruction),
                 .alu_result          (alu_result),
                 .read_data_2         (read_data_2),
                 .mem_write_data      (mem_write_data),
                 .mem_address         (mem_address),
                 .mem_read            (mem_read),
                 .mem_write           (mem_write),
                 .reg_write           (reg_write)
                 );

   // Clock generation
   parameter T = 10; // Clock period
   always #((T)/2) clk = ~clk; // Generate clock with 50% duty cycle

   // Test stimulus
   initial
     begin
        $display("Starting MIPS Datapath Testbench...");

        // Initialize inputs
        clk = 0;
        reset_n = 0; // Start with reset asserted

        // Apply reset sequence
        #((T)*2); // Hold reset for 2 clock cycles
        reset_n = 1; // Release reset
        #(T); // Wait one more clock cycle for PC to update to 0 and fetch first instruction
        $display(" ");
        $display("--- Initial State After Reset ---");
        $display("Time |    PC    | Instruction | RegWrite | MemRead | MemWrite | ALU Result | Mem Addr | Mem Write Data | Rd1 Addr | Rd2 Addr | Read Data1 | Read Data2 | Reg Write Data");
        $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("%4d | %8h | %11h | %8b | %7b | %8b | %10h | %8h | %14h | %8d | %8d | %10h | %10h | %14h",
                 $time, current_pc, current_instruction, reg_write, mem_read, mem_write, alu_result, mem_address, mem_write_data,
                 dut.rf.read_reg1, dut.rf.read_reg2, // Register File read addresses
                 dut.read_data_1, dut.read_data_2, dut.reg_file_write_data);
        $display("Time: %0d | PC: %h | Instruction: %h", $time, current_pc, current_instruction);
        // You might want to display initial register/memory contents here if accessible

        // Initialize Data Memory in the DUT with some known values
        // These values will be read by the initial LW instructions (0x00-0x24)
        // AND will be overwritten by the SW instructions (0x100-0x124), then read by the verification LWs.
        $display("--- Initializing Data Memory ---");
        // Initial LW addresses: 0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18, 0x1C, 0x20, 0x24
        // Corresponding word indices: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        dut.dm.memory[0] = 32'h00000100; // Value for lw $t0, 0($zero)
        dut.dm.memory[1] = 32'h00000200; // Value for lw $t1, 4($zero)
        dut.dm.memory[2] = 32'h00000300; // Value for lw $t2, 8($zero)
        dut.dm.memory[3] = 32'h00000400; // Value for lw $t3, 12($zero)
        dut.dm.memory[4] = 32'h00000500; // Value for lw $t4, 16($zero)
        dut.dm.memory[5] = 32'h00000600; // Value for lw $t5, 20($zero)
        dut.dm.memory[6] = 32'h00000700; // Value for lw $t6, 24($zero)
        dut.dm.memory[7] = 32'h00000800; // Value for lw $t7, 28($zero)
        dut.dm.memory[8] = 32'h00000900; // Value for lw $s0, 32($zero)
        dut.dm.memory[9] = 32'h00000A00; // Value for lw $s1, 36($zero)

        $display("--- Initializing Registers ---");
        // Registers used in the ADD and SW instructions in instructions.txt
        dut.rf.registers[8] = 32'h00000000; // $t0 = 0
        dut.rf.registers[9] = 32'h0000000A; // $t1 = 10
        dut.rf.registers[10] = 32'h00000014; // $t2 = 20
        dut.rf.registers[11] = 32'h0000001E; // $t3 = 30
        dut.rf.registers[12] = 32'h00000028; // $t4 = 40
        dut.rf.registers[13] = 32'h00000032; // $t5 = 50
        dut.rf.registers[14] = 32'h0000003C; // $t6 = 60
        dut.rf.registers[15] = 32'h00000046; // $t7 = 70
        dut.rf.registers[16] = 32'h00000050; // $s0 = 80
        dut.rf.registers[17] = 32'h0000005A; // $s1 = 90
        dut.rf.registers[18] = 32'h00000064; // $s2 = 100
        dut.rf.registers[19] = 32'h0000006E; // $s3 = 110
        dut.rf.registers[20] = 32'h00000078; // $s4 = 120
        dut.rf.registers[21] = 32'h00000082; // $s5 = 130
        dut.rf.registers[22] = 32'h0000008C; // $s6 = 140
        dut.rf.registers[23] = 32'h00000096; // $s7 = 150

        $display("--- Executing Instructions ---");

        // Execute 40 instructions (10 add + 10 lw + 10 sw + 10 lw for verify)
        repeat (100)
          begin
             @(posedge clk);
             $display(" ");
             $display("Time |    PC    | Instruction | RegWrite | MemRead | MemWrite | ALU Result | Mem Addr | Mem Write Data | Rd1 Addr | Rd2 Addr | Read Data1 | Read Data2 | Reg Write Data");
             $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
             $display("%4d | %8h | %11h | %8b | %7b | %8b | %10h | %8h | %14h | %8d | %8d | %10h | %10h | %14h",
                      $time, current_pc, current_instruction, reg_write, mem_read, mem_write, alu_result, mem_address, mem_write_data,
                      dut.rf.read_reg1, dut.rf.read_reg2, // Register File read addresses
                      dut.read_data_1, dut.read_data_2, dut.reg_file_write_data);

             // Add display for Register File read data (aligned)
             $display("       | Register File Read Data 1: %h, Read Data 2: %h",
                      dut.read_data_1, dut.read_data_2);
             // Optional: Display contents of key registers after each instruction
             // Access the internal register array of the register_file module
             $display("       | $t0 (R8):  %h, $t1 (R9):  %h, $t2 (R10):  %h, $t3  (R11): %h",
                      dut.rf.registers[8], dut.rf.registers[9], dut.rf.registers[10], dut.rf.registers[11]);
             $display("       | $t4 (R12): %h, $t5 (R13): %h, $t6 (R14): %h, $t7 (R15): %h",
                      dut.rf.registers[12], dut.rf.registers[13], dut.rf.registers[14], dut.rf.registers[15]);
             $display("       | $s0 (R16): %h, $s1 (R17): %h, $s2 (R18): %h, $s3 (R19): %h",
                      dut.rf.registers[16], dut.rf.registers[17], dut.rf.registers[18], dut.rf.registers[19]);
             $display("       | $s4 (R20): %h, $s5 (R21): %h, $s6 (R22): %h, $s7 (R23): %h",
                      dut.rf.registers[20], dut.rf.registers[21], dut.rf.registers[22], dut.rf.registers[23]);


             // Optional: Display contents of key memory locations after each instruction
             // Check memory locations written by SW instructions (e.g., after the SWs execute)
             // SW addresses: 0x100, 0x104, 0x108, 0x10C, 0x110, 0x114, 0x118, 0x11C, 0x120, 0x124
             // Corresponding word indices: 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49
             // Decimal word indices: 64, 65, 66, 67, 68, 69, 70, 71, 72, 73
             $display("       | Mem[Word 64 (0x100)]: %h, Mem[Word 65 (0x104)]: %h, Mem[Word 66 (0x108)]: %h",
                      dut.dm.memory[64], dut.dm.memory[65], dut.dm.memory[66]);
             $display("       | Mem[Word 67 (0x10C)]: %h, Mem[Word 68 (0x110)]: %h, Mem[Word 69 (0x114)]: %h",
                      dut.dm.memory[67], dut.dm.memory[68], dut.dm.memory[69]);
             $display("       | Mem[Word 70 (0x118)]: %h, Mem[Word 71 (0x11C)]: %h, Mem[Word 72 (0x120)]: %h, Mem[Word 73 (0x124)]: %h",
                      dut.dm.memory[70], dut.dm.memory[71], dut.dm.memory[72], dut.dm.memory[73]);
          end

        $display("--------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("MIPS Datapath Testbench finished.");
        $finish; // End simulation
     end

endmodule
