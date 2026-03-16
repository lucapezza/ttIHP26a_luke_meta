// Author: Luke
// A wrapper for the and4 standard cell.
// Options are:
// sg13g2_and4_1
// sg13g2_and4_2

module and4 (
    input   wire in1,
    input   wire in2,
    input   wire in3,
    input   wire in4,
    output  wire out
);

    /*
    assign #25ps out = in1 & in2 & in3 & in4;
    */

    (* keep_hierarchy *) sg13g2_and4_2 sg13g2_and4_2_inst (
        .A  (in1),
        .B  (in2),
        .C  (in3),
        .D  (in4),
        .Y  (out)
    );

endmodule