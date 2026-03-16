// Author: Luke
// A chain of inverters to create a delay line. The output will be the input delayed by N times the inverter delay.

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
        for (i = 0; i < N; i = i + 1) begin : inv_chain
            (* keep_hierarchy *) inverter inverter_inst (
                .in  (stage[i]),
                .out (stage[i+1])
            );
        end
    endgenerate

endmodule