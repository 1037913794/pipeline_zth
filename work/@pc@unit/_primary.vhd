library verilog;
use verilog.vl_types.all;
entity PcUnit is
    port(
        PCSel           : in     vl_logic;
        PCIn            : in     vl_logic_vector(31 downto 0);
        PCOut           : out    vl_logic_vector(31 downto 0);
        PCOut_plus4     : out    vl_logic_vector(31 downto 0);
        PcReSet         : in     vl_logic;
        PCWrite         : in     vl_logic;
        clk             : in     vl_logic
    );
end PcUnit;
