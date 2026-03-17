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
    
    
    wire _unused = &{ui_in[7:6], uio_in[2:0] };

    assign uio_oe  = 8'b00000111; // Only uio_out[2:0] are outputs
    assign uio_out[7:3] = 5'b0; // Unused outputs should be tied to 0 



    (* keep_hierarchy *) meta_top meta_top_inst (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .clk_delayed_monitor_out(uio_out[2]),
        .metastability_detected_out(uio_out[0]),
        .internal_data_out(uio_out[1]),
        .external_data_in(ui_in[5]), 
        .calibration_mode_in(uio_in[3]), 
        .tune_delay_ctrl_in(uio_in[7:4]), 
        .ring_ctrl_in(ui_in[2:0]), 
        .prescaler_bypass_ctrl_in(ui_in[4:3]), 
        .metastability_count_out(uo_out) 
    );

endmodule
