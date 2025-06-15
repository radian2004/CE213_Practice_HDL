library verilog;
use verilog.vl_types.all;
entity traffic_light is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        req             : in     vl_logic;
        green_main      : out    vl_logic;
        yellow_main     : out    vl_logic;
        red_main        : out    vl_logic;
        green_side      : out    vl_logic;
        yellow_side     : out    vl_logic;
        red_side        : out    vl_logic
    );
end traffic_light;
