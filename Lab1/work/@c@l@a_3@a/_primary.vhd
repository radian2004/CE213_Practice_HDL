library verilog;
use verilog.vl_types.all;
entity CLA_3A is
    port(
        A               : in     vl_logic_vector(2 downto 0);
        B               : in     vl_logic_vector(2 downto 0);
        Cin             : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0)
    );
end CLA_3A;
