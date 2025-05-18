`timescale 1ns/1ps
module control_unit_tb;

   // Declare inputs as registers
   reg [5:0] opcode;
   reg [5:0] funct;

   // Declare outputs as wires
   wire      reg_dst;
   wire      alu_src;
   wire      mem_to_reg;
   wire      reg_write;
   wire      mem_read;
   wire      mem_write;
   wire [3:0] alu_control;

   integer    i;

   // Instantiate the Control Unit module under test
   // Make sure control_unit.v is in the same directory or included in your project
   control_unit dut (
                     .opcode      (opcode),
                     .funct       (funct),
                     .reg_dst     (reg_dst),
                     .alu_src     (alu_src),
                     .mem_to_reg  (mem_to_reg),
                     .reg_write   (reg_write),
                     .mem_read    (mem_read),
                     .mem_write   (mem_write),	
                     .alu_control (alu_control)
                     );

   // Memory to hold test opcode/funct pairs read from the file
   // Each entry is 12 bits: [11:6] for opcode, [5:0] for funct
   reg [11:0] test_instructions [0:9]; // Example: up to 100 test cases

   // Test stimulus
   initial begin
      $display("Starting Control Unit Testbench (reading from file)...");

      // Read test cases from the external file
      // The file format is assumed to be hex opcode followed by hex funct on each line
      // We'll read them into a 12-bit memory where bits 11:6 are opcode and bits 5:0 are funct
      $readmemh("/home/lamar/quartus/HDL/lab/lab456/control_unit_instructions.txt", test_instructions);
      $display("Test instructions loaded from control_unit_instructions.txt");

      // Initialize inputs to a known state
      opcode = 6'b000000;
      funct  = 6'b000000;
      #10; // Wait for initial values to propagate

      $display("Time | Opcode | Funct  | RegDst | ALUSrc | MemToReg | RegWrite | MemRead | MemWrite | ALUControl");
      $display("-------------------------------------------------------------------------------------------------");

      // Apply each test case from the loaded memory
      for (i = 0; i < 10; i = i + 1) begin // Loop through up to 100 test cases
         // Extract opcode and funct from the loaded test instruction
         opcode = test_instructions[i][11:6];
         funct  = test_instructions[i][5:0];

         // Wait for the combinatorial logic to settle after applying inputs
         #10;

         // Display the current time, inputs, and outputs
         $display("%4d | %6b | %6b | %6b | %6b | %8b | %8b | %7b | %8b | %10b",
                  $time, opcode, funct, reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, alu_control);
      end

      $display("-------------------------------------------------------------------------------------------------");
      $display("Control Unit Testbench finished.");
      $finish; // End simulation
   end

endmodule
