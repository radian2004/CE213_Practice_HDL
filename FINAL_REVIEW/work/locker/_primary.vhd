library verilog;
use verilog.vl_types.all;
entity locker is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        key_in          : in     vl_logic_vector(3 downto 0);
        key_valid       : in     vl_logic;
        enter           : in     vl_logic;
        \open\          : out    vl_logic;
        error           : out    vl_logic
    );
end locker;
