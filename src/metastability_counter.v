`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A simple start delay module. When enable goes high, it waits for a N^2 clock cycles before setting run high.

module metastability_counter (
    input  wire       clk,
    input  wire       reset_n,   // async active-low reset
    input  wire       enable,
    output wire [7:0] count
);

    reg [7:0] count_reg;

    assign count = count_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count_reg <= 8'b0000_0000;
        else if (enable)
            count_reg <= count_reg + 1'b1;
    end

endmodule