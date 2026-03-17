`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A tunable delay line with 16 different delay settings. The delay is implemented as a chain of inverters, and the delay can be tuned by selecting how many inverters the signal goes through.

module one_hot_encoder_4to16 (
    input  wire [3:0] in,
    output wire [15:0] out
);

    assign out[0]  = ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[1]  = ~in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[2]  = ~in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[3]  = ~in[3] & ~in[2] &  in[1] &  in[0];
    assign out[4]  = ~in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[5]  = ~in[3] &  in[2] & ~in[1] &  in[0];
    assign out[6]  = ~in[3] &  in[2] &  in[1] & ~in[0];
    assign out[7]  = ~in[3] &  in[2] &  in[1] &  in[0];
    assign out[8]  =  in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[9]  =  in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[10] =  in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[11] =  in[3] & ~in[2] &  in[1] &  in[0];
    assign out[12] =  in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[13] =  in[3] &  in[2] & ~in[1] &  in[0];
    assign out[14] =  in[3] &  in[2] &  in[1] & ~in[0];
    assign out[15] =  in[3] &  in[2] &  in[1] &  in[0];

endmodule


module tunable_delay (
    input wire [3:0] td, // tunable delay control
    input wire in,
    output wire out
);

    (* keep, dont_touch *) wire [15:0] td_one_hot;
    (* keep_hierarchy *) one_hot_encoder_4to16 td_encoder (
        .in(td),
        .out(td_one_hot)
    );

    (* keep, dont_touch *) wire out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15;
    assign out_0 = in; // no delay
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_1 (.in(out_0), .out(out_1) );
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_2 (.in(out_1), .out(out_2) );
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_3 (.in(out_2), .out(out_3) );
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_4 (.in(out_3), .out(out_4) );
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_5 (.in(out_4), .out(out_5) );
    (* keep_hierarchy *) inverter_chain #(.N(2)) inverter_chain_6 (.in(out_5), .out(out_6) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_7 (.in(out_6), .out(out_7) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_8 (.in(out_7), .out(out_8) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_9 (.in(out_8), .out(out_9) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_10 (.in(out_9), .out(out_10) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_11 (.in(out_10), .out(out_11) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_12 (.in(out_11), .out(out_12) );
    (* keep_hierarchy *) inverter_chain #(.N(4)) inverter_chain_13 (.in(out_12), .out(out_13) );
    (* keep_hierarchy *) inverter_chain #(.N(10)) inverter_chain_14 (.in(out_13), .out(out_14) );
    (* keep_hierarchy *) inverter_chain #(.N(10)) inverter_chain_15 (.in(out_14), .out(out_15) );

    (* keep, dont_touch *) wire out_0_gated, out_1_gated, out_2_gated, out_3_gated, out_4_gated, out_5_gated, out_6_gated, out_7_gated, out_8_gated, out_9_gated, out_10_gated, out_11_gated, out_12_gated, out_13_gated, out_14_gated, out_15_gated;
    (* keep_hierarchy *) and2 and2_out_0 (.in1(out_0), .in2(td_one_hot[0]), .out(out_0_gated));
    (* keep_hierarchy *) and2 and2_out_1 (.in1(out_1), .in2(td_one_hot[1]), .out(out_1_gated));
    (* keep_hierarchy *) and2 and2_out_2 (.in1(out_2), .in2(td_one_hot[2]), .out(out_2_gated));
    (* keep_hierarchy *) and2 and2_out_3 (.in1(out_3), .in2(td_one_hot[3]), .out(out_3_gated));
    (* keep_hierarchy *) and2 and2_out_4 (.in1(out_4), .in2(td_one_hot[4]), .out(out_4_gated));
    (* keep_hierarchy *) and2 and2_out_5 (.in1(out_5), .in2(td_one_hot[5]), .out(out_5_gated));
    (* keep_hierarchy *) and2 and2_out_6 (.in1(out_6), .in2(td_one_hot[6]), .out(out_6_gated));
    (* keep_hierarchy *) and2 and2_out_7 (.in1(out_7), .in2(td_one_hot[7]), .out(out_7_gated));
    (* keep_hierarchy *) and2 and2_out_8 (.in1(out_8), .in2(td_one_hot[8]), .out(out_8_gated));
    (* keep_hierarchy *) and2 and2_out_9 (.in1(out_9), .in2(td_one_hot[9]), .out(out_9_gated));
    (* keep_hierarchy *) and2 and2_out_10 (.in1(out_10), .in2(td_one_hot[10]), .out(out_10_gated));
    (* keep_hierarchy *) and2 and2_out_11 (.in1(out_11), .in2(td_one_hot[11]), .out(out_11_gated));
    (* keep_hierarchy *) and2 and2_out_12 (.in1(out_12), .in2(td_one_hot[12]), .out(out_12_gated));
    (* keep_hierarchy *) and2 and2_out_13 (.in1(out_13), .in2(td_one_hot[13]), .out(out_13_gated));
    (* keep_hierarchy *) and2 and2_out_14 (.in1(out_14), .in2(td_one_hot[14]), .out(out_14_gated));
    (* keep_hierarchy *) and2 and2_out_15 (.in1(out_15), .in2(td_one_hot[15]), .out(out_15_gated));

    (* keep, dont_touch *) wire out_or_1, out_or_2, out_or_3, out_or_4;
    (* keep_hierarchy *) or4 or4_out_or_1 (.in1(out_0_gated), .in2(out_1_gated), .in3(out_2_gated), .in4(out_3_gated), .out(out_or_1));
    (* keep_hierarchy *) or4 or4_out_or_2 (.in1(out_4_gated), .in2(out_5_gated), .in3(out_6_gated), .in4(out_7_gated), .out(out_or_2));
    (* keep_hierarchy *) or4 or4_out_or_3 (.in1(out_8_gated), .in2(out_9_gated), .in3(out_10_gated), .in4(out_11_gated), .out(out_or_3));
    (* keep_hierarchy *) or4 or4_out_or_4 (.in1(out_12_gated), .in2(out_13_gated), .in3(out_14_gated), .in4(out_15_gated), .out(out_or_4));

    (* keep_hierarchy *) or4 or4_tunable_delay_out (.in1(out_or_1), .in2(out_or_2), .in3(out_or_3), .in4(out_or_4), .out(out));

endmodule