module Datapath
  (
   input wire         clk,
   input wire         reset_n,
   
   // Control inputs from CPU
   input wire         reg_dst,
   input wire         alu_src,
   input wire         mem_to_reg,
   input wire [3:0]   alu_control,
   input wire         mem_read,
   input wire         mem_write,
   input wire         reg_write,

   // Outputs for observation or connecting to a testbench
   output wire [31:0] current_pc,          
   output wire [31:0] current_instruction, 
   output wire [31:0] alu_result,         
   output wire [31:0] read_data_2,        
   output wire [31:0] mem_write_data,     
   output wire [31:0] mem_address         
   );

   // Wires for instruction fetch
   wire [31:0] pc_wire;
   wire [31:0] instruction_wire;

   // Assign outputs for monitoring
   assign current_pc = pc_wire;
   assign current_instruction = instruction_wire;

   // Instantiate Program Counter
   program_counter PC1 (
                       .clk     (clk),
                       .reset_n (reset_n),
                       .pc_out  (pc_wire)
                       );

   // Instantiate Instruction Memory
   instruction_memory IMEM1 (
                            .address     (pc_wire),
                            .instruction (instruction_wire)
                            );

   // Decode instruction fields
   wire [4:0] rs      = instruction_wire[25:21];
   wire [4:0] rt      = instruction_wire[20:16];
   wire [4:0] rd      = instruction_wire[15:11];
   wire [15:0] immediate = instruction_wire[15:0];

   // Wires for data paths
   wire [31:0]  read_data_1;           
   wire [31:0]  sign_extended_immediate;
   wire [31:0]  alu_operand_2;         
   wire [31:0]  data_memory_read_data; 
   wire [31:0]  reg_file_write_data;   
   wire [4:0]   reg_file_write_reg;    

   // Register File
   register_file RF1 (
                     .clk        (clk),
                     .reset_n    (reset_n),
                     .read_reg1  (rs),
                     .read_reg2  (rt),
                     .write_reg  (reg_file_write_reg),
                     .write_data (reg_file_write_data),
                     .reg_write  (reg_write),
                     .read_data1 (read_data_1),
                     .read_data2 (read_data_2)
                     );

   // MUX for destination register address
   assign reg_file_write_reg = (reg_dst == 1'b1) ? rd : rt;

   // Sign Extend
   sign_extend SE1 (
                   .in  (immediate),
                   .out (sign_extended_immediate)
                   );

   // MUX for ALU operand 2
   assign alu_operand_2 = (alu_src == 1'b1) ? sign_extended_immediate : read_data_2;

   // ALU
   alu ALU1 (
                  .operand1    (read_data_1),
                  .operand2    (alu_operand_2),
                  .alu_control (alu_control),
                  .result      (alu_result)
                  );

   // Memory address and write data
   assign mem_address = alu_result;
   assign mem_write_data = read_data_2;

   // Data Memory
   data_memory DM1 (
                   .clk        (clk),
                   .address    (mem_address),
                   .write_data (mem_write_data),
                   .mem_read   (mem_read),
                   .mem_write  (mem_write),
                   .read_data  (data_memory_read_data)
                   );

   // MUX for register write data
   assign reg_file_write_data = (mem_to_reg == 1'b1) ? data_memory_read_data : alu_result;

endmodule