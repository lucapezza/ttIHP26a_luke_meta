`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// SPDX-License-Identifier: Apache-2.0
// Top-level module just including pin assignment.

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
    
    assign uio_oe  = 8'b00000111; // Only uio_out[2:0] are outputs
    assign uio_out[7:3] = 5'b0; // Unused outputs should be tied to 0 

    (* keep_hierarchy *) meta_top u_meta_top (
        .clk(clk),
        .reset_n(rst_n),
        .enable(ena),

        .data_frequency_ctrl(ui_in[2:0]), 
        .prescaler_bypass_ctrl(ui_in[4:3]), 
        .external_data(ui_in[5]), 
        .detector_select(ui_in[6]), 
        .calibration_mode(ui_in[7]),

        .metastability_detected(uio_out[0]),
        .data_monitor(uio_out[1]),
        .tune_delay_monitor(uio_out[2]),
        .tune_delay_ctrl(uio_in[7:3]), 

        .metastability_count(uo_out) 
    );

    wire _unused = &{ uio_in[2:0] };

endmodule

