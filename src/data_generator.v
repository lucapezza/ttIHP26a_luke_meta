`default_nettype none
`timescale 1ps/1ps

//

module inverter (
    input   wire in,
    output  wire out
);

    /*
    assign #23ps out = ~in;
    */

    /*
    (* keep_hierarchy *) sg13g2_inv_1    sg13g2_inv_1_inst (
        .A  (in),
        .Y  (out)
    );
    */

    /*
    (* keep_hierarchy *) sg13g2_inv_2    sg13g2_inv_2_inst (
        .A  (in),
        .Y  (out)
    );
    */

    (* keep_hierarchy *) sg13g2_inv_4    sg13g2_inv_4_inst (
        .A  (in),
        .Y  (out)
    );

    /*
    (* keep_hierarchy *) sg13g2_inv_8    sg13g2_inv_8_inst (
        .A  (in),
        .Y  (out)
    );
    */

    /*
    (* keep_hierarchy *) sg13g2_inv_16    sg13g2_inv_16_inst (
        .A  (in),
        .Y  (out)
    );
    */


endmodule


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


module one_hot_encoder_3to8 (
    input  wire [2:0] in,
    output wire [7:0] out
);

    assign out[0] = ~in[2] & ~in[1] & ~in[0];
    assign out[1] = ~in[2] & ~in[1] &  in[0];
    assign out[2] = ~in[2] &  in[1] & ~in[0];
    assign out[3] = ~in[2] &  in[1] &  in[0];
    assign out[4] =  in[2] & ~in[1] & ~in[0];
    assign out[5] =  in[2] & ~in[1] &  in[0];
    assign out[6] =  in[2] &  in[1] & ~in[0];
    assign out[7] =  in[2] &  in[1] &  in[0];

endmodule

module one_hot_encoder_2to4 (
    input  wire [1:0] in,
    output wire [3:0] out
);

    assign out[0] = ~in[1] & ~in[0];
    assign out[1] = ~in[1] &  in[0];
    assign out[2] =  in[1] & ~in[0];
    assign out[3] =  in[1] &  in[0];

endmodule


module ripple_divider (
    input  wire clk_in,
    output wire div2,
    output wire div4
);

    reg q0 = 1'b0;
    reg q1 = 1'b0;

    always @(posedge clk_in)
        q0 <= ~q0;

    always @(posedge q0)
        q1 <= ~q1;

    assign div2 = q0;
    assign div4 = q1;

endmodule

module data_generator (
    input wire reset_n, //(0 = reset, 1 = run)
    input wire enable, //(0 = stop, 1 = run)
    input wire [2:0] rc, // ring control
    input wire [1:0] pb, // prescaler-bypass control
    input wire data_in_bypass,
    output wire data_out
);

    (* keep, dont_touch *) wire [7:0] rc_one_hot;
    (* keep_hierarchy *) one_hot_encoder_3to8 rc_encoder (
        .in(rc),
        .out(rc_one_hot)
    );

    (* keep, dont_touch *) wire [3:0] pb_one_hot;
    (* keep_hierarchy *) one_hot_encoder_2to4 pb_encoder (
        .in(pb),
        .out(pb_one_hot)
    );

    (* keep, dont_touch *) wire b_in, b_start, b_a, b_b, b_c, b_d, b_e, b_f, b_g;

    (* keep_hierarchy *) inverter inverter_start (.in(b_in), .out(b_start)); // first inverter (all the following chain must be even)
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_a (.in(b_start), .out(b_a) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_b (.in(b_a), .out(b_b) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_c (.in(b_b), .out(b_c) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_d (.in(b_c), .out(b_d) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_e (.in(b_d), .out(b_e) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) inverter_chain_f (.in(b_e), .out(b_f) );
    (* keep_hierarchy *) inverter_chain #(.N(400)) inverter_chain_g (.in(b_f), .out(b_g) );

    (* keep, dont_touch *) wire run;
    assign run = ~rc_one_hot[0] & reset_n & enable & ~pb_one_hot[0]; // rc_one_hot[0] = 1 means stop the ring, pb_one_hot[0] = 1 means bypass

    assign b_in = run & (
        (b_a & rc_one_hot[1]) | 
        (b_b & rc_one_hot[2]) | 
        (b_c & rc_one_hot[3]) | 
        (b_d & rc_one_hot[4]) | 
        (b_e & rc_one_hot[5]) | 
        (b_f & rc_one_hot[6]) | 
        (b_g & rc_one_hot[7]));

    (* keep, dont_touch *) wire ring_out, ring_out_div2, ring_out_div4;
    assign ring_out = b_in;

    (* keep_hierarchy *) ripple_divider ripple_divider_inst (
        .clk_in(ring_out),
        .div2(ring_out_div2),
        .div4(ring_out_div4)
    );

    assign data_out = (data_in_bypass & pb_one_hot[0]) |
                      (ring_out & pb_one_hot[1]) | 
                      (ring_out_div2 & pb_one_hot[2]) | 
                      (ring_out_div4 & pb_one_hot[3]);

endmodule