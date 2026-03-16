/*
 * Copyright (c) 2026 Luke
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_luke_meta (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // All output pins must be assigned. If not used, assign to 0.
    // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    // assign uio_out = 0;
    // assign uio_oe  = 0;
    
    wire _unused = &{ clk, ui_in[7:6], uio_in };

    // Tunable delay
    wire clk_delayed;
    (* keep_hierarchy *) tunable_delay tunable_delay_inst (
        .td(uio_in[7:4]), // tunable delay control
        .in(clk),
        .out(clk_delayed)
    );

    // Reset synchronizer
    wire rst_n_sync;
    (* keep_hierarchy *) reset_syncronizer rst_sync (
        .clk(clk),
        .reset_n_async(rst_n),
        .reset_n_sync(rst_n_sync)
    );


    // 
    wire ena_sync;
    (* keep_hierarchy *) input_sync input_sync_ena_inst (
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
        .rc(ui_in[2:0]), // ring control
        .pb(ui_in[4:3]), // prescaler-bypass control
        .data_in_bypass(ui_in[5]),
        .data_out(data)
    );

    // Calibrate data generator.
    wire calibrate_data;
    (* keep_hierarchy *) calibrate_data_generator calibrate_data_generator_inst (
        .clk(clk),
        .reset_n(rst_n_sync),
        .calibrate_data(calibrate_data)
    );

    // Metastability detector
    wire metastability;
    (* keep_hierarchy *) metastability_detector_1 metastability_detector_1_inst (
        .clk(clk),
        .clk_delayed(clk_delayed),
        .reset_n(rst_n_sync),
        .calibrate(uio_in[3]), 
        .calibrate_data(calibrate_data), 
        .data(data),
        .metastability(metastability)
    );

    // Metastability counter
    (* keep_hierarchy *) metastability_counter metastability_counter_inst (
        .clk(clk),
        .reset_n(rst_n_sync),
        .enable(metastability),
        .count(uo_out)
    );

    assign uio_out[2] = clk_delayed ^ clk; // for measuring the actual delay
    assign uio_out[1] = data; // for checking the data pattern
    assign uio_out[0] = metastability; // for checking if metastability is detected


    assign uio_oe  = 8'b00000111; // Only uio_out[2:0] are outputs
    assign uio_out[7:3] = 5'b0; // Unused outputs should be tied to 0 



    /*
    wire reset = !rst_n;

    // Just wrap the Chisel generated Verilog
    ChiselTop ChiselTop(
        .clock(clk),
        .reset(reset),
        .io_ui_in(ui_in),
        .io_uo_out(uo_out),
        .io_uio_in(uio_in),
        .io_uio_out(uio_out),
        .io_uio_oe(uio_oe)
    );

    wire _unused = &{ ena };
    */

endmodule
