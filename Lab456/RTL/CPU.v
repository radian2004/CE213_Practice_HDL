module CPU (
    input wire clk,
    input wire reset_n,
    
    // Outputs for monitoring
    output wire [31:0] current_pc,
    output wire [31:0] current_instruction,
    output wire [31:0] alu_result,
    output wire [31:0] read_data_2,
    output wire [31:0] mem_write_data,
    output wire [31:0] mem_address,
    output wire mem_read,
    output wire mem_write,
    output wire reg_write
);

    // Control signals 
    wire reg_dst;
    wire alu_src;
    wire mem_to_reg;
    wire [3:0] alu_control;

    // Extract instruction fields
    wire [5:0] opcode = current_instruction[31:26];
    wire [5:0] funct = current_instruction[5:0];

    // Instantiate Control Unit
    control_unit controller (
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst),
        .alu_src(alu_src), 
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_control(alu_control)
    );

    // Instantiate Datapath
    Datapath datapath (
        .clk(clk),
        .reset_n(reset_n),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg), 
        .alu_control(alu_control),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .current_pc(current_pc),
        .current_instruction(current_instruction),
        .alu_result(alu_result),
        .read_data_2(read_data_2),
        .mem_write_data(mem_write_data),
        .mem_address(mem_address)
    );

endmodule