// (reg_dst == 1'b1) ? rd : rt
// (alu_src == 1'b1) ? sign_extended_immediate : read_data_2
// (mem_to_reg == 1'b1) ? data_memory_read_data : alu_result

module Datapath
  (
   input wire         clk,
   input wire         reset_n,

   // Outputs for observation or connecting to a testbench
   output wire [31:0] current_pc,          // Current value of the Program Counter
   output wire [31:0] current_instruction, // Instruction being executed
   output wire [31:0] alu_result,          // Output of the ALU
   output wire [31:0] read_data_2,         // Data read from RT register (for sw)
   output wire [31:0] mem_write_data,      // Data written to Data Memory (from RD2)
   output wire [31:0] mem_address,         // Address used for Data Memory access
   output wire        mem_read,            // Control signal for Data Memory read
   output wire        mem_write,           // Control signal for Data Memory write
   output wire        reg_write            // Control signal for Register File write
   );

   // Wires for instruction fetch
   wire [31:0] pc_wire;
   wire [31:0] instruction_wire;

   // Assign outputs for monitoring
   assign current_pc = pc_wire;
   assign current_instruction = instruction_wire;

   // Instantiate Program Counter
   // Generates the address of the next instruction
   program_counter PC1 (
                       .clk     (clk),
                       .reset_n (reset_n),
                       .pc_out  (pc_wire) // Output PC value
                       );

   // Instantiate Instruction Memory
   // Fetches the instruction based on the PC address
   // This module reads instructions from "instructions.txt"
   instruction_memory IMEM1 (
                            .address     (pc_wire),      // PC output is the instruction address (byte address)
                            .instruction (instruction_wire) // Output is the current instruction (32-bit word)
                            );

   // Decode instruction fields from the fetched instruction
   wire [5:0] opcode  = instruction_wire[31:26];
   wire [4:0] rs      = instruction_wire[25:21];
   wire [4:0] rt      = instruction_wire[20:16];
   wire [4:0] rd      = instruction_wire[15:11];
   wire [5:0] funct   = instruction_wire[5:0];
   wire [15:0] immediate = instruction_wire[15:0];

   // Control signals from the Control Unit
   wire        reg_dst;    // Selects destination register (rd or rt)
   wire        alu_src;    // Selects second ALU operand (RD2 or sign-extended immediate)
   wire        mem_to_reg; // Selects data to write to register (ALU result or memory data)
   wire [3:0]  alu_control; // Controls the ALU operation
   // wire         mem_read; // Already an output
   // wire         mem_write; // Already an output
   // wire         reg_write; // Already an output

   // Instantiate the Control Unit
   // Generates control signals based on opcode and funct
   control_unit Controller1 (
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

   // Wires for data paths
   wire [31:0]  read_data_1;            // Data read from RS register
   // wire [31:0]  read_data_2;         // Already an output
   wire [31:0]  sign_extended_immediate; // 16-bit immediate sign-extended to 32
   wire [31:0]  alu_operand_2;          // Second operand for the ALU (RD2 or sign-extended)
   // wire [31:0]  alu_result;          // Already an output
   wire [31:0]  data_memory_read_data;  // Data read from Data Memory
   wire [31:0]  reg_file_write_data;    // Data written back to the Register File (ALU result or memory data)
   wire [4:0]   reg_file_write_reg;     // Destination register address for write (rd or rt)

   // Instantiate the Register File
   // Stores and provides register values
   register_file RF1 (
                     .clk        (clk),
                     .reset_n    (reset_n),
                     .read_reg1  (rs),                 // Read from RS register
                     .read_reg2  (rt),                 // Read from RT register (also used for data in sw)
                     .write_reg  (reg_file_write_reg), // Address of register to write to
                     .write_data (reg_file_write_data), // Data to write to register
                     .reg_write  (reg_write),          // Enable register write
                     .read_data1 (read_data_1),       // Data read from RS
                     .read_data2 (read_data_2)        // Data read from RT
                     );

   // MUX for destination register address (RegDst)
   // Selects rd (R-type, RegDst=1) or rt (I-type, RegDst=0) for register write
   assign reg_file_write_reg = (reg_dst == 1'b1) ? rd : rt;

   // Instantiate Sign Extend unit
   // Extends the 16-bit immediate to 32 bits
   sign_extend SE1 (
                   .in  (immediate),
                   .out (sign_extended_immediate)
                   );

   // MUX for the second ALU operand (ALUSrc)
   // Selects data from RT (alu_src=0) or sign-extended immediate (alu_src=1)
   assign alu_operand_2 = (alu_src == 1'b1) ? sign_extended_immediate : read_data_2;

   // Instantiate the ALU
   // Performs arithmetic and logic operations
   alu ALU1 (
                  .operand1    (read_data_1),         // Operand 1 comes from RS
                  .operand2    (alu_operand_2),       // Operand 2 from ALUSrc MUX
                  .alu_control (alu_control),      // Operation determined by Control Unit
                  .result      (alu_result)             // ALU Result
                  // Assuming your ALU has a zero flag output, you might connect it here if needed
                  // .zero(...)
                  );

   // The ALU result is used as the memory address for lw/sw
   assign mem_address = alu_result;

   // The data to write to memory for sw comes from the RT register (RD2)
   assign mem_write_data = read_data_2;

   // Instantiate Data Memory
   // Reads from or writes to memory
   data_memory DM1 (
                   .clk        (clk),
                   .address    (mem_address),              // Address from ALU (byte address)
                   .write_data (mem_write_data),        // Data from RT        (for sw)
                   .mem_read   (mem_read),                // Read enable from Control Unit
                   .mem_write  (mem_write),              // Write enable from Control Unit
                   .read_data  (data_memory_read_data)   // Data read from memory (for lw)
                   );

   // MUX for data to write back to Register File (MemToReg)
   // Selects ALU result (MemToReg=0) or data from memory (MemToReg=1)
   // sw does not write back, so this selection doesn't matter when RegWrite is 0
   assign reg_file_write_data = (mem_to_reg == 1'b1) ? data_memory_read_data : alu_result;

endmodule
