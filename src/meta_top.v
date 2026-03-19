`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// Top-level module for the metastability demonstrator. To be wrapped by tt_um_luke_meta.v for pin assignment.

module meta_top (
    input  wire clk,
    input  wire reset_n, // reset_n - low to reset
    input  wire enable, // becomes 1 when the design is powered

    input  wire [2:0] data_frequency_ctrl,
    input  wire [1:0] prescaler_bypass_ctrl,
    input  wire external_data,
    input  wire detector_select, // 1 for detector 1, 0 for detector 2
    input  wire calibration_mode,

    output wire metastability_detected,
    output wire data_monitor,
    output wire tune_delay_monitor,
    input  wire [4:0] tune_delay_ctrl,

    output wire [7:0] metastability_count_out
);

    // Tunable delay
    wire clk_delayed;
    (* keep_hierarchy *) tunable_delay u_tunable_delay (
        .td_ctrl(tune_delay_ctrl), // tunable delay control
        .in(clk),
        .out(clk_delayed)
    );

    // Reset synchronizer
    wire reset_n_sync;
    (* keep_hierarchy *) reset_synchronizer u_reset_synchronizer (
        .clk(clk),
        .reset_n_async(reset_n),
        .reset_n_sync(reset_n_sync)
    );


    // Enable signal synchronizer
    wire enable_sync;
    (* keep_hierarchy *) input_synchronizer u_input_synchronizer_enable (
        .clk(clk),
        .async_in(enable),
        .sync_out(enable_sync)
    );

    // Start delay counter
    wire enable_delayed;
    (* keep_hierarchy *) start_delay #(.N(5)) u_start_delay (
        .clk(clk),
        .reset_n(reset_n_sync),
        .enable(enable_sync),
        .run(enable_delayed)
    );

    // Data generator
    wire data;
    (* keep_hierarchy *) data_generator u_data_generator (
        .reset_n(reset_n_sync),
        .enable(enable_delayed),
        .r_ctrl(data_frequency_ctrl), // ring control
        .pb_ctrl(prescaler_bypass_ctrl), // prescaler-bypass control
        .data_in_bypass(external_data),
        .data_out(data)
    );

    // Calibrate data generator.
    wire calibrate_data;
    (* keep_hierarchy *) calibrate_data_generator u_calibrate_data_generator (
        .clk(clk),
        .reset_n(reset_n_sync),
        .calibrate_data(calibrate_data)
    );

   // Calibration mode signal synchronizer
    wire calibration_mode_sync;
    (* keep_hierarchy *) input_synchronizer u_input_synchronizer_calibration_mode (
        .clk(clk),
        .async_in(calibration_mode),
        .sync_out(calibration_mode_sync)
    );

    // Metastability detector 1
    wire metastability_1;
    (* keep_hierarchy *) metastability_detector_1 u_metastability_detector_1 (
        .clk(clk),
        .clk_delayed(clk_delayed),
        .reset_n(reset_n_sync),
        .calibrate(calibration_mode_sync), 
        .calibrate_data(calibrate_data), 
        .data(data),
        .metastability(metastability_1)
    );

    // Metastability detector 1
    wire metastability_2;
    (* keep_hierarchy *) metastability_detector_2 u_metastability_detector_2 (
        .clk(clk),
        .clk_delayed(clk_delayed),
        .reset_n(reset_n_sync),
        .calibrate(calibration_mode_sync), 
        .calibrate_data(calibrate_data), 
        .data(data),
        .metastability(metastability_2)
    );

    wire metastability;
    assign metastability = detector_select ? metastability_2 : metastability_1;

    // Metastability counter
    (* keep_hierarchy *) metastability_counter u_metastability_counter (
        .clk(clk),
        .reset_n(reset_n_sync),
        .enable(metastability),
        .count(metastability_count_out)
    );

    assign tune_delay_monitor = clk_delayed ^ clk; // for measuring the actual delay
    assign data_monitor = data; // for checking the data pattern
    assign metastability_detected = metastability; // for checking if metastability is detected

endmodule
