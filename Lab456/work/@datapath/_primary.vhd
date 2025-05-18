library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        current_pc      : out    vl_logic_vector(31 downto 0);
        current_instruction: out    vl_logic_vector(31 downto 0);
        alu_result      : out    vl_logic_vector(31 downto 0);
        read_data_2     : out    vl_logic_vector(31 downto 0);
        mem_write_data  : out    vl_logic_vector(31 downto 0);
        mem_address     : out    vl_logic_vector(31 downto 0);
        mem_read        : out    vl_logic;
        mem_write       : out    vl_logic;
        reg_write       : out    vl_logic
    );
end Datapath;
