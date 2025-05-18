library verilog;
use verilog.vl_types.all;
entity CPU_tb is
    generic(
        T               : integer := 10
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of T : constant is 1;
end CPU_tb;
