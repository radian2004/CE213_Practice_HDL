library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        reg_dst         : in     vl_logic;
        alu_src         : in     vl_logic;
        mem_to_reg      : in     vl_logic;
        alu_control     : in     vl_logic_vector(3 downto 0);
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        reg_write       : in     vl_logic;
        current_pc      : out    vl_logic_vector(31 downto 0);
        current_instruction: out    vl_logic_vector(31 downto 0);
        alu_result      : out    vl_logic_vector(31 downto 0);
        read_data_2     : out    vl_logic_vector(31 downto 0);
        mem_write_data  : out    vl_logic_vector(31 downto 0);
        mem_address     : out    vl_logic_vector(31 downto 0)
    );
end Datapath;
