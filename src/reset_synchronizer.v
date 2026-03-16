`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A reset synchronizer (asynchronous assertion, synchronous deassertion).

module reset_synchronizer (
    input  wire clk,
    input  wire reset_n_async,   // asynchronous active-low reset
    output wire reset_n_sync     // synchronized active-low reset
);

reg ff1;
reg ff2;
reg ff3;

always @(posedge clk or negedge reset_n_async) begin
    if (!reset_n_async) begin
        ff1 <= 1'b0;
        ff2 <= 1'b0;
        ff3 <= 1'b0;
    end else begin
        ff1 <= 1'b1;
        ff2 <= ff1;
        ff3 <= ff2;
    end
end

assign reset_n_sync = ff3;

endmodule