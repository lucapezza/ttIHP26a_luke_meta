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

    (* keep_hierarchy *) data_generator data_gen (
        .reset_n(rst_n),
        .enable(ena),
        .rc(ui_in[2:0]),
        .pb(ui_in[4:3]),
        .data_in_bypass(ui_in[5]),
        .data_out(uio_out[0])
    );    

    assign uio_oe  = 8'b00000001; // Only uio_out[0] is an output, the rest are inputs   
    assign uio_out[7:1] = 7'b0; // Unused outputs should be tied to 0 
    assign uo_out = 0;


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
