library verilog;
use verilog.vl_types.all;
entity elevator is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        req             : in     vl_logic_vector(2 downto 0);
        cur_floor       : in     vl_logic_vector(1 downto 0);
        dir_up          : out    vl_logic;
        dir_down        : out    vl_logic;
        door_open       : out    vl_logic
    );
end elevator;
