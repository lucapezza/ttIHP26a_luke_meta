`default_nettype none
`timescale 1ps/1ps

// Author: Luke
// A tunable delay line with 32 different delay settings. The delay is implemented as a chain of inverters, and the delay can be tuned by selecting how many inverters the signal goes through.

module one_hot_encoder_5to32 (
    input  wire [4:0] in,
    output wire [31:0] out
);

    assign out[0]  = ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[1]  = ~in[4] & ~in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[2]  = ~in[4] & ~in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[3]  = ~in[4] & ~in[3] & ~in[2] &  in[1] &  in[0];
    assign out[4]  = ~in[4] & ~in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[5]  = ~in[4] & ~in[3] &  in[2] & ~in[1] &  in[0];
    assign out[6]  = ~in[4] & ~in[3] &  in[2] &  in[1] & ~in[0];
    assign out[7]  = ~in[4] & ~in[3] &  in[2] &  in[1] &  in[0];

    assign out[8]  = ~in[4] &  in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[9]  = ~in[4] &  in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[10] = ~in[4] &  in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[11] = ~in[4] &  in[3] & ~in[2] &  in[1] &  in[0];
    assign out[12] = ~in[4] &  in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[13] = ~in[4] &  in[3] &  in[2] & ~in[1] &  in[0];
    assign out[14] = ~in[4] &  in[3] &  in[2] &  in[1] & ~in[0];
    assign out[15] = ~in[4] &  in[3] &  in[2] &  in[1] &  in[0];

    assign out[16] =  in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[17] =  in[4] & ~in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[18] =  in[4] & ~in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[19] =  in[4] & ~in[3] & ~in[2] &  in[1] &  in[0];
    assign out[20] =  in[4] & ~in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[21] =  in[4] & ~in[3] &  in[2] & ~in[1] &  in[0];
    assign out[22] =  in[4] & ~in[3] &  in[2] &  in[1] & ~in[0];
    assign out[23] =  in[4] & ~in[3] &  in[2] &  in[1] &  in[0];

    assign out[24] =  in[4] &  in[3] & ~in[2] & ~in[1] & ~in[0];
    assign out[25] =  in[4] &  in[3] & ~in[2] & ~in[1] &  in[0];
    assign out[26] =  in[4] &  in[3] & ~in[2] &  in[1] & ~in[0];
    assign out[27] =  in[4] &  in[3] & ~in[2] &  in[1] &  in[0];
    assign out[28] =  in[4] &  in[3] &  in[2] & ~in[1] & ~in[0];
    assign out[29] =  in[4] &  in[3] &  in[2] & ~in[1] &  in[0];
    assign out[30] =  in[4] &  in[3] &  in[2] &  in[1] & ~in[0];
    assign out[31] =  in[4] &  in[3] &  in[2] &  in[1] &  in[0];

endmodule


module tunable_delay (
    input wire [4:0] td, // tunable delay control
    input wire in,
    output wire out
);

    (* keep, dont_touch *) wire [31:0] td_one_hot;
    (* keep_hierarchy *) one_hot_encoder_5to32 td_encoder (
        .in(td),
        .out(td_one_hot)
    );

    (* keep, dont_touch *) wire out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, 
                                out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31;
    assign out_0 = in; // no delay
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_1 (.in(out_0), .out(out_1) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_2 (.in(out_1), .out(out_2) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_3 (.in(out_2), .out(out_3) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_4 (.in(out_3), .out(out_4) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_5 (.in(out_4), .out(out_5) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_6 (.in(out_5), .out(out_6) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_7 (.in(out_6), .out(out_7) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_8 (.in(out_7), .out(out_8) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_9 (.in(out_8), .out(out_9) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_10 (.in(out_9), .out(out_10) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_11 (.in(out_10), .out(out_11) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_12 (.in(out_11), .out(out_12) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_13 (.in(out_12), .out(out_13) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_14 (.in(out_13), .out(out_14) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_15 (.in(out_14), .out(out_15) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_16 (.in(out_15), .out(out_16) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_17 (.in(out_16), .out(out_17) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_18 (.in(out_17), .out(out_18) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_19 (.in(out_18), .out(out_19) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_20 (.in(out_19), .out(out_20) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_21 (.in(out_20), .out(out_21) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_22 (.in(out_21), .out(out_22) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_23 (.in(out_22), .out(out_23) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_24 (.in(out_23), .out(out_24) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_25 (.in(out_24), .out(out_25) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_26 (.in(out_25), .out(out_26) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_27 (.in(out_26), .out(out_27) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_28 (.in(out_27), .out(out_28) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_29 (.in(out_28), .out(out_29) );
    (* keep_hierarchy *) inverter_chain #(.N(30)) inverter_chain_30 (.in(out_29), .out(out_30) );
    (* keep_hierarchy *) inverter inverter_clk (.in(in), .out(out_31));

    (* keep, dont_touch *) wire out_0_gated, out_1_gated, out_2_gated, out_3_gated, out_4_gated, out_5_gated, out_6_gated, out_7_gated, out_8_gated, out_9_gated, out_10_gated, out_11_gated, out_12_gated, out_13_gated, out_14_gated, out_15_gated,
                                out_16_gated, out_17_gated, out_18_gated, out_19_gated, out_20_gated, out_21_gated, out_22_gated, out_23_gated, out_24_gated, out_25_gated, out_26_gated, out_27_gated, out_28_gated, out_29_gated, out_30_gated, out_31_gated;    
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
    (* keep_hierarchy *) and2 and2_out_16 (.in1(out_16), .in2(td_one_hot[16]), .out(out_16_gated));
    (* keep_hierarchy *) and2 and2_out_17 (.in1(out_17), .in2(td_one_hot[17]), .out(out_17_gated));
    (* keep_hierarchy *) and2 and2_out_18 (.in1(out_18), .in2(td_one_hot[18]), .out(out_18_gated));
    (* keep_hierarchy *) and2 and2_out_19 (.in1(out_19), .in2(td_one_hot[19]), .out(out_19_gated));
    (* keep_hierarchy *) and2 and2_out_20 (.in1(out_20), .in2(td_one_hot[20]), .out(out_20_gated));
    (* keep_hierarchy *) and2 and2_out_21 (.in1(out_21), .in2(td_one_hot[21]), .out(out_21_gated));
    (* keep_hierarchy *) and2 and2_out_22 (.in1(out_22), .in2(td_one_hot[22]), .out(out_22_gated));
    (* keep_hierarchy *) and2 and2_out_23 (.in1(out_23), .in2(td_one_hot[23]), .out(out_23_gated));
    (* keep_hierarchy *) and2 and2_out_24 (.in1(out_24), .in2(td_one_hot[24]), .out(out_24_gated));
    (* keep_hierarchy *) and2 and2_out_25 (.in1(out_25), .in2(td_one_hot[25]), .out(out_25_gated));
    (* keep_hierarchy *) and2 and2_out_26 (.in1(out_26), .in2(td_one_hot[26]), .out(out_26_gated));
    (* keep_hierarchy *) and2 and2_out_27 (.in1(out_27), .in2(td_one_hot[27]), .out(out_27_gated));
    (* keep_hierarchy *) and2 and2_out_28 (.in1(out_28), .in2(td_one_hot[28]), .out(out_28_gated));
    (* keep_hierarchy *) and2 and2_out_29 (.in1(out_29), .in2(td_one_hot[29]), .out(out_29_gated));
    (* keep_hierarchy *) and2 and2_out_30 (.in1(out_30), .in2(td_one_hot[30]), .out(out_30_gated));
    (* keep_hierarchy *) and2 and2_out_31 (.in1(out_31), .in2(td_one_hot[31]), .out(out_31_gated));

    (* keep, dont_touch *) wire out_or_1, out_or_2, out_or_3, out_or_4, out_or_5, out_or_6, out_or_7, out_or_8;
    (* keep_hierarchy *) or4 or4_out_or_1 (.in1(out_0_gated), .in2(out_1_gated), .in3(out_2_gated), .in4(out_3_gated), .out(out_or_1));
    (* keep_hierarchy *) or4 or4_out_or_2 (.in1(out_4_gated), .in2(out_5_gated), .in3(out_6_gated), .in4(out_7_gated), .out(out_or_2));
    (* keep_hierarchy *) or4 or4_out_or_3 (.in1(out_8_gated), .in2(out_9_gated), .in3(out_10_gated), .in4(out_11_gated), .out(out_or_3));
    (* keep_hierarchy *) or4 or4_out_or_4 (.in1(out_12_gated), .in2(out_13_gated), .in3(out_14_gated), .in4(out_15_gated), .out(out_or_4));
    (* keep_hierarchy *) or4 or4_out_or_5 (.in1(out_16_gated), .in2(out_17_gated), .in3(out_18_gated), .in4(out_19_gated), .out(out_or_5));
    (* keep_hierarchy *) or4 or4_out_or_6 (.in1(out_20_gated), .in2(out_21_gated), .in3(out_22_gated), .in4(out_23_gated), .out(out_or_6));
    (* keep_hierarchy *) or4 or4_out_or_7 (.in1(out_24_gated), .in2(out_25_gated), .in3(out_26_gated), .in4(out_27_gated), .out(out_or_7));
    (* keep_hierarchy *) or4 or4_out_or_8 (.in1(out_28_gated), .in2(out_29_gated), .in3(out_30_gated), .in4(out_31_gated), .out(out_or_8));

    (* keep, dont_touch *) wire out_tunable_delay_1, out_tunable_delay_2;
    (* keep_hierarchy *) or4 or4_tunable_delay_out_1 (.in1(out_or_1), .in2(out_or_2), .in3(out_or_3), .in4(out_or_4), .out(out_tunable_delay_1));
    (* keep_hierarchy *) or4 or4_tunable_delay_out_2 (.in1(out_or_5), .in2(out_or_6), .in3(out_or_7), .in4(out_or_8), .out(out_tunable_delay_2));

    (* keep_hierarchy *) or2 or2_tunable_delay_out (.in1(out_tunable_delay_1), .in2(out_tunable_delay_2), .out(out));

endmodule