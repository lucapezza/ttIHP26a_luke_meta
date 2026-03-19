set TEST_PATH "C:/Users/lpez/Documents/tiny_tapeout/ttIHP26a_luke_meta/src/tests"
add_force ${p}/ena -radix bin {0 0ns}
set p "/meta_top/"
set ROSC_TAPS 701
set ROSC_INV_DURATION_PS 25
set ROSC_TAP_NUM_OF_INV 100
set CLK_NS 20

proc rosc_period_ns {ctrl pres} {
    global ROSC_INV_DURATION_PS ROSC_TAP_NUM_OF_INV
    # In every half period there is the contribution ofone extra inverter, 2 AND gates and 2 OR gates, each same delay as one INV
    set t_half_ps [expr (5+$ctrl*$ROSC_TAP_NUM_OF_INV)*$ROSC_INV_DURATION_PS]
    return [expr 2*$t_half_ps * 2**($pres-1) / 1000.0]
}

proc init {} {
    global p
    add_force ${p}/clk -radix bin {1 0ns} {0 10ns} -repeat_every 20ns
    add_force ${p}/rst_n -radix bin {0 0ns} {1 100ns}
    add_force ${p}/external_data_in -radix unsigned {0 0ns}
    add_force ${p}/calibration_mode_in -radix unsigned {0 0ns}
    add_force ${p}/tune_delay_ctrl_in -radix unsigned {0 0ns}
    add_force ${p}/ring_ctrl_in -radix unsigned {0 0ns}
    add_force ${p}/prescaler_bypass_ctrl_in -radix unsigned {0 0ns}
}

proc reset {} {
    global p CLK_NS
    add_force ${p}/rst_n -radix bin {0 0ns} {1 10ns}
    run 10 ns
    # Run till ROSC is stable
    run [expr 32*$CLK_NS] ns
}

########################
# Ena released by platform
add_force ${p}/ena -radix bin {1 0ns}
init

##########################
# frequency sweep
for {set ctrl 1} {$ctrl<8} {incr ctrl} {
    for {set pres 1} {$pres<4} {incr pres} {
        add_force ${p}/ring_ctrl_in -radix unsigned "$ctrl 0ns"
        add_force ${p}/prescaler_bypass_ctrl_in -radix unsigned "$pres 0ns"
        reset
        set t [rosc_period_ns $ctrl $pres]
        puts "ROSC settings ring_ctrl_in:$ctrl prescaler_bypass_ctrl:$pres"
        puts "Expected ROSC period (ns): $t"
        run [expr 10*$t] ns
    }
}


