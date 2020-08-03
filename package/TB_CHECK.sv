/*=============================================================================
 * Title        : AtCoder test case check testbench task interface
 *
 * File Name    : TB_CHECK.sv
 * Project      : AtCoder beginners Selection
 * Designer     : toms74209200 <https://github.com/toms74209200>
 * Created      : 2020/08/03
 * License      : MIT License.
                  http://opensource.org/licenses/mit-license.php
 *============================================================================*/

`define Comment(variable) \
$messagelog("%:S %:0F(%:0L) %:O.", "Note", `__FILE__, `__LINE__, variable);
`define MessageOK(variable) \
$messagelog("%:S %:0F(%:0L) OK:Assertion %:O.", "Note", `__FILE__, `__LINE__, variable);
`define MessageERROR(variable, expected, actual) \
$messagelog("%:S %:0F(%:0L) ERROR:%:O expected %x, but %x.", "Error", `__FILE__, `__LINE__, variable, expected, actual);
`define ChkValue(variable, value) \
    if ((variable)===(value)) \
        `MessageOK(variable) \
    else \
        `MessageERROR(variable, value, variable)

interface TB_CHECK (
    input           RESET_n,            //(n) Reset
    input           CLK,                //(p) Clock
    output          SINK_VALID,         //(p) Sink data valid
    output  [7:0]   SINK_DATA,          //(p) Sink data
    input           SOURCE_VALID,       //(p) Source data valid
    input   [7:0]   SOURCE_DATA         //(p) Source data
);

// Parameter
parameter ClkCyc    = 10;       // Signal change interval(10ns/50MHz)
parameter ResetTime = 20;       // Reset hold time

// internal signals
bit         sink_valid_i;
bit [7:0]   sink_data_i;

bit [7:0]   answers[0:10];
int         file_handler;
int         string_length;
string      file_data;
string      file_path;
int         data_cnt;


/*=============================================================================
 * Port connection
 *============================================================================*/
assign SINK_VALID = sink_valid_i;
assign SINK_DATA  = sink_data_i;


/*=============================================================================
 * Test case check task
 *============================================================================*/
task check(string in_file, string out_file);
    // input
    file_handler = $fopen(in_file, "r");
    while ($feof(file_handler) == 0) begin
        sink_valid_i = 1'b1;
        string_length = $fgets(file_data, file_handler);
        $display("%s", file_data);
        for (int i=0;i<string_length;i++) begin
            if (file_data[i] == 8'h0a)
                sink_data_i = 8'h0d;
            else
                sink_data_i = file_data[i];
            @(posedge CLK);
        end
    end
    sink_valid_i = 1'b0;
    // output
    file_handler = $fopen(out_file, "r");
    wait(SOURCE_VALID);
    @(posedge CLK);
    data_cnt = 0;
    while (SOURCE_VALID) begin
        if (SOURCE_DATA == 8'h0d)
            answers[data_cnt] = 8'h0a;
        else
            answers[data_cnt] = SOURCE_DATA;
        data_cnt++;
        @(posedge CLK);
    end
    $display("%s", string'(answers));
    while ($feof(file_handler) == 0) begin
        string_length = $fgets(file_data, file_handler);
        for (int i=0;i<string_length;i++) begin
            `ChkValue(answers[i], file_data[i]);
        end
    end
endtask

endinterface    //TB_CHECK
