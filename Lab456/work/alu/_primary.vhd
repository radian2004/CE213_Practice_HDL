library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        operand1        : in     vl_logic_vector(31 downto 0);
        operand2        : in     vl_logic_vector(31 downto 0);
        alu_control     : in     vl_logic_vector(3 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        zero            : out    vl_logic
    );
end alu;
