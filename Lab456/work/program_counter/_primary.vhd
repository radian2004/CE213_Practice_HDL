library verilog;
use verilog.vl_types.all;
entity program_counter is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        pc_out          : out    vl_logic_vector(31 downto 0)
    );
end program_counter;
