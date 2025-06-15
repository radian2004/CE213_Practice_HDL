library verilog;
use verilog.vl_types.all;
entity counter is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        load            : in     vl_logic;
        d               : in     vl_logic_vector(3 downto 0);
        up              : in     vl_logic;
        hold            : in     vl_logic;
        q               : out    vl_logic_vector(3 downto 0)
    );
end counter;
