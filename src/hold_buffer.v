`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A buffer to create some prop./cont. delay.

module hold_buffer (
    input wire in, 
    output wire out
);

    (* keep_hierarchy *) inverter_chain #(.N(6)) u_inverter_chain (.in(in), .out(out) );

endmodule