# Author: Luke
# Just a series of driving patterns for testing in the Vivado simulator. Testing is carried out by observing the waveforms.

restart

#set TEST_PATH "C:/Users/lpez/Documents/tiny_tapeout/ttIHP26a_luke_meta/sim/tests"
set p "/meta_top"
#add_force ${p}/ena -radix bin {0 0ns}
set ROSC_TAPS 701
set ROSC_INV_DURATION_PS 25
set ROSC_TAP_NUM_OF_INV 100
set CLK_NS 20

proc rosc_period_ns {ctrl pres} {
    global ROSC_INV_DURATION_PS ROSC_TAP_NUM_OF_INV
    # In every half period there is the contribution ofone extra inverter, 2 AND gates and 2 OR gates, each same delay as one INV
    set t_half_ps [expr (5+$ctrl*$ROSC_TAP_NUM_OF_INV)*$ROSC_INV_DURATION_PS]
    if {$pres == 1} {
        return [expr {2*$t_half_ps / 1000.0}]
    } else {
        return [expr {2*$t_half_ps * (2**($pres+1)) / 1000.0}]
    }
    #return [expr 2*$t_half_ps *  2**($pres-1) / 1000.0]
}

proc init {} {
    global p
    add_force ${p}/clk -radix bin {1 0ns} {0 10ns} -repeat_every 20ns
    add_force ${p}/reset_n -radix bin {0 0ns} {1 100ns}
    add_force ${p}/external_data -radix unsigned {0 0ns}
    add_force ${p}/calibration_mode -radix unsigned {0 0ns}
    add_force ${p}/detector_select -radix unsigned {0 0ns}
    add_force ${p}/tune_delay_ctrl -radix unsigned {0 0ns}
    add_force ${p}/data_frequency_ctrl -radix unsigned {0 0ns}
    add_force ${p}/prescaler_bypass_ctrl -radix unsigned {0 0ns}
}

proc reset {} {
    global p CLK_NS
    add_force ${p}/reset_n -radix bin {0 0ns} {1 10ns}
    run 10 ns
    # Run till ROSC is stable
    run [expr 32*$CLK_NS] ns
}

########################
# Ena released by platform
add_force ${p}/enable -radix bin {1 0ns}
init

##########################
# frequency sweep
for {set ctrl 1} {$ctrl<8} {incr ctrl} {
    for {set pres 1} {$pres<4} {incr pres} {
        add_force ${p}/data_frequency_ctrl -radix unsigned "$ctrl 0ns"
        add_force ${p}/prescaler_bypass_ctrl -radix unsigned "$pres 0ns"
        reset
        set t [rosc_period_ns $ctrl $pres]
        puts "ROSC settings data_frequency_ctrl:$ctrl prescaler_bypass_ctrl:$pres"
        puts "Expected ROSC period (ns): $t"
        run [expr 10*$t] ns
    }
}

# tuned delay sweep
reset
add_force ${p}/data_frequency_ctrl -radix unsigned {0 0ns}
add_force ${p}/prescaler_bypass_ctrl -radix unsigned {0 0ns}

for {set tune 0} {$tune<16} {incr tune} {
    add_force ${p}/tune_delay_ctrl -radix unsigned "$tune 0ns"
    run 500 ns
}


# test calibration mode meta 1
reset
add_force ${p}/data_frequency_ctrl -radix unsigned {5 0ns}
add_force ${p}/prescaler_bypass_ctrl -radix unsigned {1 0ns}
add_force ${p}/calibration_mode -radix unsigned {1 0ns}
add_force ${p}/detector_select -radix unsigned {0 0ns}

for {set tune 0} {$tune<16} {incr tune} {
    add_force ${p}/tune_delay_ctrl -radix unsigned "$tune 0ns"
    run 500 ns
}

# test calibration mode meta 2
reset
add_force ${p}/data_frequency_ctrl -radix unsigned {5 0ns}
add_force ${p}/prescaler_bypass_ctrl -radix unsigned {1 0ns}
add_force ${p}/calibration_mode -radix unsigned {1 0ns}
add_force ${p}/detector_select -radix unsigned {1 0ns}

for {set tune 0} {$tune<16} {incr tune} {
    add_force ${p}/tune_delay_ctrl -radix unsigned "$tune 0ns"
    run 500 ns
}

# test meta 1
reset
add_force ${p}/tune_delay_ctrl -radix unsigned {5 0ns}
add_force ${p}/calibration_mode -radix unsigned {0 0ns}
add_force ${p}/detector_select -radix unsigned {0 0ns}

for {set ctrl 1} {$ctrl<8} {incr ctrl} {
    for {set pres 3} {$pres<4} {incr pres} {
        add_force ${p}/data_frequency_ctrl -radix unsigned "$ctrl 0ns"
        add_force ${p}/prescaler_bypass_ctrl -radix unsigned "$pres 0ns"
        reset
        set t [rosc_period_ns $ctrl $pres]
        run [expr 10*$t] ns
    }
}

# test meta 2
reset
add_force ${p}/tune_delay_ctrl -radix unsigned {5 0ns}
add_force ${p}/calibration_mode -radix unsigned {0 0ns}
add_force ${p}/detector_select -radix unsigned {1 0ns}

for {set ctrl 1} {$ctrl<8} {incr ctrl} {
    for {set pres 3} {$pres<4} {incr pres} {
        add_force ${p}/data_frequency_ctrl -radix unsigned "$ctrl 0ns"
        add_force ${p}/prescaler_bypass_ctrl -radix unsigned "$pres 0ns"
        reset
        set t [rosc_period_ns $ctrl $pres]
        run [expr 10*$t] ns
    }
}
