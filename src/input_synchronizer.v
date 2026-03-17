`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A simple 3 flip-flop syncronizer (no reset).

module input_synchronizer (
    input  wire clk,
    input  wire async_in,
    output wire sync_out
);

reg ff1;
reg ff2;
reg ff3;

always @(posedge clk) begin
    ff1 <= async_in;
    ff2 <= ff1;
    ff3 <= ff2;
end

assign sync_out = ff3;

endmodule