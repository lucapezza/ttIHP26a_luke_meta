`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A simple start delay module. When enable goes high, it waits for a N^2 clock cycles before setting run high. 

module start_delay #(
    parameter N = 5   // delay = 2^N clock cycles
)(
    input  wire clk,
    input  wire reset_n,
    input  wire enable,
    output wire  run
);

reg [N-1:0] count;
reg run_int;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        count <= {N{1'b0}};
        run_int   <= 1'b0;
    end else if (!enable) begin
        count <= {N{1'b0}}; // reset counter when enable=0
        run_int   <= 1'b0;
    end else if (!run_int) begin
        count <= count + 1'b1;
        if (&count) // all bits = 1
            run_int <= 1'b1;
    end
end

assign run = run_int;

endmodule