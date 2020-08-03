/*=============================================================================
 * Title        : AtCoder beginners Selection ABC 086 A - Product
 *
 * File Name    : TB_ABC086A.sv
 * Project      : AtCoder beginners Selection
 * Designer     : toms74209200 <https://github.com/toms74209200>
 * Created      : 2020/07/31
 * License      : MIT License.
                  http://opensource.org/licenses/mit-license.php
 *============================================================================*/

`timescale 1ns/1ns

`define Comment(variable) \
$messagelog("%:S %:0F(%:0L) %:O.", "Note", `__FILE__, `__LINE__, variable);

module TB_ABC086A ;

// Simulation module signal
bit         RESET_n;            //(n) Reset
bit         CLK;                //(p) Clock
bit         SINK_VALID = 0;     //(p) Sink data valid
bit [7:0]   SINK_DATA  = 0;     //(p) Sink data
bit         SOURCE_VALID;       //(p) Source data valid
bit [7:0]   SOURCE_DATA;        //(p) Source data

// Parameter
parameter ClkCyc    = 10;       // Signal change interval(10ns/50MHz)
parameter ResetTime = 20;       // Reset hold time

// Test case file
parameter IN_SAMPLE_01 = "testbench/testcase/in/sample_01.txt";
parameter IN_SAMPLE_02 = "testbench/testcase/in/sample_02.txt";
parameter OUT_SAMPLE_01 = "testbench/testcase/out/sample_01.txt";
parameter OUT_SAMPLE_02 = "testbench/testcase/out/sample_02.txt";

// module
ABC086A U_ABC086A(
.*,
.SINK_VALID(SINK_VALID),
.SINK_DATA(SINK_DATA),
.SOURCE_VALID(SOURCE_VALID),
.SOURCE_DATA(SOURCE_DATA)
);

TB_CHECK U_TB_CHECK(
.RESET_n(RESET_n),
.CLK(CLK),
.SINK_VALID(SINK_VALID),
.SINK_DATA(SINK_DATA),
.SOURCE_VALID(SOURCE_VALID),
.SOURCE_DATA(SOURCE_DATA)
);

/*=============================================================================
 * Clock
 *============================================================================*/
always begin
    #(ClkCyc);
    CLK = ~CLK;
end


/*=============================================================================
 * Reset
 *============================================================================*/
initial begin
    #(ResetTime);
    RESET_n = 1;
end 


/*=============================================================================
 * Signal initialization
 *============================================================================*/
initial begin
    
    #(ResetTime);
    @(posedge CLK);

/*=============================================================================
 * Sample 1
 *============================================================================*/
    `Comment("Sample 1");
    U_TB_CHECK.check(IN_SAMPLE_01, OUT_SAMPLE_01);

/*=============================================================================
 * Sample 2
 *============================================================================*/
    `Comment("Sample 2");
    U_TB_CHECK.check(IN_SAMPLE_02, OUT_SAMPLE_02);

    $finish;
end

endmodule
// TB_ABC086A
