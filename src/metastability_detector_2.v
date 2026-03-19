`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A metastability detector (V2).

module metastability_detector_2 (
    input wire clk,
    input wire clk_delayed, // delayed version of clk with tunable delay
    input wire reset_n, //(0 = reset, 1 = run)
    input wire calibrate, // when 1, syncronous data is given in input, so metastability does not happen. Used to calibrate the tunable delay.
    input wire calibrate_data, // the syncronous data for calibration
    input wire data, 
    output wire metastability // goes high when metastability is detected
);

    (* keep, dont_touch *) wire data_in, data_and, calibrate_data_and;
    //assign data_in = calibrate & calibrate_data | ~calibrate & data;
    (* keep_hierarchy *) and2 u_and2_calibrate_data (.in1(calibrate), .in2(calibrate_data), .out(calibrate_data_and));
    (* keep_hierarchy *) and2 u_and2_data (.in1(~calibrate), .in2(data), .out(data_and));
    (* keep_hierarchy *) or2 u_or2_data_in (.in1(calibrate_data_and), .in2(data_and), .out(data_in));

    (* keep, dont_touch *) reg ff_dut;

    // FF under test
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            ff_dut <= 1'b0;
        else
            ff_dut <= data_in;

    (* keep, dont_touch *) reg ff_clk;
    (* keep, dont_touch *) reg ff_clk_delayed;

    // sample with clk
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            ff_clk <= 1'b0;
        else
            ff_clk <= ff_dut;

    (* keep, dont_touch *) wire ff_dut_hold;
    (* keep_hierarchy *) hold_buffer u_hold_buffer_in (
        .in(ff_dut),
        .out(ff_dut_hold)
    );

    // sample with delayed clock
    always @(posedge clk_delayed or negedge reset_n)
        if (!reset_n)
            ff_clk_delayed <= 1'b0;
        else
            ff_clk_delayed <= ff_dut_hold;

    (* keep, dont_touch *) wire ff_clk_hold;
    (* keep_hierarchy *) hold_buffer u_hold_buffer_clk (
        .in(ff_clk),
        .out(ff_clk_hold)
    );

    (* keep, dont_touch *) wire xor_out;
    assign xor_out = ff_clk_hold ^ ff_clk_delayed; // if they are different, it means metastability happened


    // sync xor with clk delayed
    (* keep, dont_touch *) reg xor_sync;

    always @(posedge clk_delayed or negedge reset_n)
        if (!reset_n)
            xor_sync <= 1'b0;
        else
            xor_sync <= xor_out;

    (* keep, dont_touch *) wire xor_sync_hold;
    (* keep_hierarchy *) hold_buffer u_hold_buffer_out (
        .in(xor_sync),
        .out(xor_sync_hold)
    );

    reg sync1;
    reg sync2;

    // synchronizers
    always @(posedge clk or negedge reset_n)
        if (!reset_n) begin
            sync1 <= 1'b0;
            sync2 <= 1'b0;
        end else begin
            sync1 <= xor_sync_hold;
            sync2 <= sync1;
        end

    assign metastability = sync2;

endmodule