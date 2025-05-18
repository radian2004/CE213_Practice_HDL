library verilog;
use verilog.vl_types.all;
entity control_unit is
    port(
        opcode          : in     vl_logic_vector(5 downto 0);
        funct           : in     vl_logic_vector(5 downto 0);
        reg_dst         : out    vl_logic;
        alu_src         : out    vl_logic;
        mem_to_reg      : out    vl_logic;
        reg_write       : out    vl_logic;
        mem_read        : out    vl_logic;
        mem_write       : out    vl_logic;
        alu_control     : out    vl_logic_vector(3 downto 0)
    );
end control_unit;
