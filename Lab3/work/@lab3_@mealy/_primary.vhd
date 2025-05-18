library verilog;
use verilog.vl_types.all;
entity Lab3_Mealy is
    generic(
        reset           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        s1              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        s2              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        s3              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1)
    );
    port(
        CLK             : in     vl_logic;
        dataIn          : in     vl_logic_vector(3 downto 0);
        RST             : in     vl_logic;
        odd             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of reset : constant is 1;
    attribute mti_svvh_generic_type of s1 : constant is 1;
    attribute mti_svvh_generic_type of s2 : constant is 1;
    attribute mti_svvh_generic_type of s3 : constant is 1;
end Lab3_Mealy;
