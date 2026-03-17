`default_nettype none
`timescale 1ps/1ps

// Athor: Luke
// A wrapper for the inverter standard cell.
// Options are:
// sg13g2_inv_1
// sg13g2_inv_2
// sg13g2_inv_4
// sg13g2_inv_8
// sg13g2_inv_16

module inverter (
    input   wire in,
    output  wire out
);

    assign #25 out = ~in;

    /*
    (* keep_hierarchy *) sg13g2_inv_4 sg13g2_inv_4_inst (
        .A  (in),
        .Y  (out)
    );
    */

endmodule