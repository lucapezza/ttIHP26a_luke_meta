// Author: Luke
// A wrapper for the and2 standard cell.
// Options are:
// sg13g2_and2_1
// sg13g2_and2_2

module and2 (
    input   wire in1,
    input   wire in2,
    output  wire out
);

    /*
    assign #25ps out = in1 & in2;
    */

    (* keep_hierarchy *) sg13g2_and2_2 sg13g2_and2_2_inst (
        .A  (in1),
        .B  (in2),
        .X  (out)
    );

endmodule