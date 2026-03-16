// Author: Luke
// A wrapper for the or3 standard cell.
// Options are:
// sg13g2_or3_1
// sg13g2_or3_2

module or3 (
    input   wire in1,
    input   wire in2,
    input   wire in3,
    output  wire out
);

    /*
    assign #25ps out = in1 | in2 | in3;
    */

    (* keep_hierarchy *) sg13g2_or3_2 sg13g2_or3_2_inst (
        .A  (in1),
        .B  (in2),
        .C  (in3),
        .Y  (out)
    );

endmodule