`default_nettype none
`timescale 1ps/1ps

//

module calibrate_data_generator (
    input wire clk,
    input wire reset_n, //(0 = reset, 1 = run)
    output wire calibrate_data // the syncronous data for calibration
);

    // generate calibration signal
    output reg  calibrate_data_int;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            calibrate_data_int <= 1'b0;
        else
            calibrate_data_int <= ~calibrate_data_int;
    end    

    assign calibrate_data = calibrate_data_int;

endmodule