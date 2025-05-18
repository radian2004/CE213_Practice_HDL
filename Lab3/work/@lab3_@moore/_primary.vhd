library verilog;
use verilog.vl_types.all;
entity Lab3_Moore is
    generic(
        RESET           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        S1              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        S2              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        S3              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        S4              : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        CLK             : in     vl_logic;
        dataIn          : in     vl_logic_vector(3 downto 0);
        RST             : in     vl_logic;
        odd             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RESET : constant is 1;
    attribute mti_svvh_generic_type of S1 : constant is 1;
    attribute mti_svvh_generic_type of S2 : constant is 1;
    attribute mti_svvh_generic_type of S3 : constant is 1;
    attribute mti_svvh_generic_type of S4 : constant is 1;
end Lab3_Moore;
