`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A wrapper for the or4 standard cell.
// Options are:
// sg13g2_or4_1
// sg13g2_or4_2

module or4 (
    input   wire in1,
    input   wire in2,
    input   wire in3,
    input   wire in4,
    output  wire out
);

    /*
    assign #25 out = in1 | in2 | in3 | in4;
    */

    (* keep_hierarchy *) sg13g2_or4_2 u_sg13g2_or4_2 (
        .A  (in1),
        .B  (in2),
        .C  (in3),
        .D  (in4),
        .X  (out)
    );

endmodule