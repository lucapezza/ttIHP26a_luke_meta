`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// Top-level module for the metastability demonstrator.

`default_nettype none

module meta_top (
    input  wire       clk,      // clock
    input  wire       rst_n,     // reset_n - low to reset
    input  wire       ena,      // becomes 1 when the design is powered

    output wire clk_delayed_monitor_out,
    output wire metastability_detected_out,
    output wire internal_data_out,
    
    input  wire external_data_in,
    input  wire calibration_mode_in,
    input  wire detector_1_2_select_in, // 1 for detector 1, 0 for detector 2

    input  wire [3:0] tune_delay_ctrl_in,
    input  wire [2:0] ring_ctrl_in,
    input  wire [1:0] prescaler_bypass_ctrl_in,

    output wire [7:0] metastability_count_out
);

    // Tunable delay
    wire clk_delayed;
    (* keep_hierarchy *) tunable_delay tunable_delay_inst (
        .td(tune_delay_ctrl_in), // tunable delay control
        .in(clk),
        .out(clk_delayed)
    );

    // Reset synchronizer
    wire rst_n_sync;
    (* keep_hierarchy *) reset_synchronizer rst_sync (
        .clk(clk),
        .reset_n_async(rst_n),
        .reset_n_sync(rst_n_sync)
    );


    // 
    wire ena_sync;
    (* keep_hierarchy *) input_synchronizer input_synchronizer_ena_inst (
        .clk(clk),
        .async_in(ena),
        .sync_out(ena_sync)
    );

    // Start delay counter
    wire ena_delayed;
    (* keep_hierarchy *) start_delay #(.N(5)) start_delay_inst (
        .clk(clk),
        .reset_n(rst_n_sync),
        .enable(ena_sync),
        .run(ena_delayed)
    );

    // Data generator
    wire data;
    (* keep_hierarchy *) data_generator data_generator_inst (
        .reset_n(rst_n_sync),
        .enable(ena_delayed),
        .rc(ring_ctrl_in), // ring control
        .pb(prescaler_bypass_ctrl_in), // prescaler-bypass control
        .data_in_bypass(external_data_in),
        .data_out(data)
    );

    // Calibrate data generator.
    wire calibrate_data;
    (* keep_hierarchy *) calibrate_data_generator calibrate_data_generator_inst (
        .clk(clk),
        .reset_n(rst_n_sync),
        .calibrate_data(calibrate_data)
    );

   // 
    wire calibration_mode_in_sync;
    (* keep_hierarchy *) input_synchronizer input_synchronizer_calibration_mode_inst (
        .clk(clk),
        .async_in(calibration_mode_in),
        .sync_out(calibration_mode_in_sync)
    );

    // Metastability detector
    wire metastability_1;
    (* keep_hierarchy *) metastability_detector_1 metastability_detector_1_inst (
        .clk(clk),
        .clk_delayed(clk_delayed),
        .reset_n(rst_n_sync),
        .calibrate(calibration_mode_in), 
        .calibrate_data(calibrate_data), 
        .data(data),
        .metastability(metastability_1)
    );

    wire metastability_2;
    (* keep_hierarchy *) metastability_detector_2 metastability_detector_2_inst (
        .clk(clk),
        .clk_delayed(clk_delayed),
        .reset_n(rst_n_sync),
        .calibrate(calibration_mode_in), 
        .calibrate_data(calibrate_data), 
        .data(data),
        .metastability(metastability_2)
    );

    wire metastability;
    assign metastability = detector_1_2_select_in ? metastability_2 : metastability_1; // select which detector to use 

    // Metastability counter
    (* keep_hierarchy *) metastability_counter metastability_counter_inst (
        .clk(clk),
        .reset_n(rst_n_sync),
        .enable(metastability),
        .count(metastability_count_out)
    );

    assign clk_delayed_monitor_out = clk_delayed ^ clk; // for measuring the actual delay
    assign internal_data_out = data; // for checking the data pattern
    assign metastability_detected_out = metastability; // for checking if metastability is detected

endmodule
