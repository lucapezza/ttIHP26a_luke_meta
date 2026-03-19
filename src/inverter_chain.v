`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A chain of inverters to create a delay line. The output will be the input delayed by N times the inverter delay. Id N is odd, the output will be inverted. If N is even, the output will be the same as the input.

module inverter_chain #(
    parameter integer N = 10   // number of inverters
)(
    input  wire in,
    output wire out
);

    wire [N:0] stage;

    assign stage[0] = in;
    assign out = stage[N];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : u_inv_chain
            (* keep_hierarchy *) inverter u_inverter (
                .in  (stage[i]),
                .out (stage[i+1])
            );
        end
    endgenerate

endmodule