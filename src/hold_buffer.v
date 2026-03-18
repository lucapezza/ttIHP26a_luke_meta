`default_nettype none
`timescale 1ps/1ps

// A buffer to create some prop delay.
module hold_buffer (
    input wire in, 
    output wire out
);

    (* keep_hierarchy *) inverter_chain #(.N(6)) inverter_chain_buf (.in(in), .out(out) );

endmodule