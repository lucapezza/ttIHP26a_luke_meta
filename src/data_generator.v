`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A data generator for the metastability detector. It consists of a tunable ring oscillator and some dividers.

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
    input  wire reset_n,   // active-low reset
    output wire div8,
    output wire div16
);

    reg q0;
    reg q1;
    reg q2;
    reg q3;

    // First stage
    always @(posedge clk_in or negedge reset_n)
        if (!reset_n)
            q0 <= 1'b0;
        else
            q0 <= ~q0;

    // Second stage
    always @(posedge q0 or negedge reset_n)
        if (!reset_n)
            q1 <= 1'b0;
        else
            q1 <= ~q1;

    // Third stage
    always @(posedge q1 or negedge reset_n)
        if (!reset_n)
            q2 <= 1'b0;
        else
            q2 <= ~q2;

    // Fourth stage
    always @(posedge q2 or negedge reset_n)
        if (!reset_n)
            q3 <= 1'b0;
        else
            q3 <= ~q3;

    assign div8  = q2;
    assign div16 = q3;

endmodule

module data_generator (
    input wire reset_n, //(0 = reset, 1 = run)
    input wire enable, //(0 = stop, 1 = run)
    input wire [2:0] r_ctrl, // ring control
    input wire [1:0] pb_ctrl, // prescaler-bypass control
    input wire data_in_bypass,
    output wire data_out
);

    (* keep, dont_touch *) wire [7:0] rc_one_hot;
    (* keep_hierarchy *) one_hot_encoder_3to8 u_one_hot_encoder_3to8 (
        .in(r_ctrl),
        .out(rc_one_hot)
    );

    (* keep, dont_touch *) wire [3:0] pb_one_hot;
    (* keep_hierarchy *) one_hot_encoder_2to4 u_one_hot_encoder_2to4 (
        .in(pb_ctrl),
        .out(pb_one_hot)
    );

    (* keep, dont_touch *) wire b_in, b_start, b_a, b_b, b_c, b_d, b_e, b_f, b_g;

    (* keep_hierarchy *) inverter u_inverter_start (.in(b_in), .out(b_start)); // first inverter (all the following chain must be even)
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_a (.in(b_start), .out(b_a) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_b (.in(b_a), .out(b_b) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_c (.in(b_b), .out(b_c) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_d (.in(b_c), .out(b_d) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_e (.in(b_d), .out(b_e) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_f (.in(b_e), .out(b_f) );
    (* keep_hierarchy *) inverter_chain #(.N(100)) u_inverter_chain_g (.in(b_f), .out(b_g) );

    (* keep, dont_touch *) wire run;
    //assign run = ~rc_one_hot[0] & reset_n & enable & ~pb_one_hot[0]; // rc_one_hot[0] = 1 means stop the ring, pb_one_hot[0] = 1 means bypass
    (* keep_hierarchy *) and4 u_and4_run (.in1(~rc_one_hot[0]), .in2(reset_n), .in3(enable), .in4(~pb_one_hot[0]), .out(run));


    //assign b_in = run & (
    //    (b_a & rc_one_hot[1]) | 
    //    (b_b & rc_one_hot[2]) | 
    //    (b_c & rc_one_hot[3]) | 
    //    (b_d & rc_one_hot[4]) | 
    //    (b_e & rc_one_hot[5]) | 
    //    (b_f & rc_one_hot[6]) | 
    //    (b_g & rc_one_hot[7]));

    (* keep, dont_touch *) wire b_a_gated, b_b_gated, b_c_gated, b_d_gated, b_e_gated, b_f_gated, b_g_gated;
    (*keep_hierarchy *) and2 u_and2_b_a (.in1(b_a), .in2(rc_one_hot[1]), .out(b_a_gated));
    (*keep_hierarchy *) and2 u_and2_b_b (.in1(b_b), .in2(rc_one_hot[2]), .out(b_b_gated));
    (*keep_hierarchy *) and2 u_and2_b_c (.in1(b_c), .in2(rc_one_hot[3]), .out(b_c_gated));
    (*keep_hierarchy *) and2 u_and2_b_d (.in1(b_d), .in2(rc_one_hot[4]), .out(b_d_gated));
    (*keep_hierarchy *) and2 u_and2_b_e (.in1(b_e), .in2(rc_one_hot[5]), .out(b_e_gated));
    (*keep_hierarchy *) and2 u_and2_b_f (.in1(b_f), .in2(rc_one_hot[6]), .out(b_f_gated));
    (*keep_hierarchy *) and2 u_and2_b_g (.in1(b_g), .in2(rc_one_hot[7]), .out(b_g_gated));

    (* keep, dont_touch *) wire b_in_or_1, b_in_or_2, b_in_or;
    (* keep_hierarchy *) or4 u_or4_b_in_or_1 (.in1(b_a_gated), .in2(b_b_gated), .in3(b_c_gated), .in4(b_d_gated), .out(b_in_or_1));
    (* keep_hierarchy *) or3 u_or3_b_in_or_2 (.in1(b_e_gated), .in2(b_f_gated), .in3(b_g_gated), .out(b_in_or_2));
    (* keep_hierarchy *) or2 u_or2_b_in (.in1(b_in_or_1), .in2(b_in_or_2), .out(b_in_or));
    (* keep_hierarchy *) and2 u_and2_b_in (.in1(b_in_or), .in2(run), .out(b_in));

    (* keep, dont_touch *) wire ring_out, ring_out_div8, ring_out_div16;
    assign ring_out = b_in;

    (* keep_hierarchy *) ripple_divider u_ripple_divider (
        .clk_in(ring_out),
        .reset_n(reset_n),
        .div8(ring_out_div8),
        .div16(ring_out_div16)
    );

    (* keep, dont_touch *) wire data_in_bypass_gated, ring_out_gated, ring_out_div8_gated, ring_out_div16_gated;
    (* keep_hierarchy *) and2 u_and2_data_in_bypass (.in1(data_in_bypass), .in2(pb_one_hot[0]), .out(data_in_bypass_gated));
    (* keep_hierarchy *) and2 u_and2_ring_out (.in1(ring_out), .in2(pb_one_hot[1]), .out(ring_out_gated));
    (* keep_hierarchy *) and2 u_and2_ring_out_div8 (.in1(ring_out_div8), .in2(pb_one_hot[2]), .out(ring_out_div8_gated));
    (* keep_hierarchy *) and2 u_and2_ring_out_div16 (.in1(ring_out_div16), .in2(pb_one_hot[3]), .out(ring_out_div16_gated));

    (* keep_hierarchy *) or4 u_or4_data_out (.in1(data_in_bypass_gated), .in2(ring_out_gated), .in3(ring_out_div8_gated), .in4(ring_out_div16_gated), .out(data_out));

endmodule