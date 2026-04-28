#=========================================================================
# 07-synopsys-dc-synth/run.tcl
#=========================================================================

#-------------------------------------------------------------------------
# Initial setup
#-------------------------------------------------------------------------

# Suppress warnings that we have decided are not relevant/waivable

source "warnings.tcl"

set_app_var target_library [list "$env(TSMC_180NM)/stdcells.db" "$env(TSMC_180NM)/iocells.db" ]

set_app_var synthetic_library dw_foundation.sldb
set_app_var link_library [concat "*" $target_library $synthetic_library]

# Use alib cache for faster runs

set_app_var alib_library_analysis_path alib

# Increase the number of significant digits in reports

set_app_var report_default_significant_digits 4

# Set work directory

define_design_lib WORK -path work

# Turn off synopsys formality

set_svf -off

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set top_file ../../../rtl/{{ design_name }}.v
analyze -format sverilog $top_file
elaborate {{ design_name }}

#-------------------------------------------------------------------------
# Timing/Operating constraints
#-------------------------------------------------------------------------

# NEED TO FIDDLE WITH
# set_input_transition 0 [all_inputs]
# set_load 0.005 [all_outputs]
# set_max_transition 0.250 {{ design_name }}

# Set the max transition for any net in the design

set_max_transition 0.250 {{ design_name }}

set_input_transition 0 [all_inputs]

# Set the assumed load for all outputs

set_load 0.005 [all_outputs]

# Clock period constraint

create_clock -name ideal_clock1 -period {{ clock_period }}

# Set the assumed propagation and contamination delay for inputs

set_input_delay -clock ideal_clock1 -max 0.050 [all_inputs]
set_input_delay -clock ideal_clock1 -min 0     [all_inputs]

# Set the assumed setup and hold time constraints for outputs

set_output_delay -clock ideal_clock1 -max 0.050 [all_outputs]
set_output_delay -clock ideal_clock1 -min 0     [all_outputs]

# Constraint all feed-through paths (i.e., combinational paths from
# inputs to outputs to take no longer than one clock cycle

set_max_delay {{ clock_period }} -from [all_inputs] -to [all_outputs]

check_timing

#-------------------------------------------------------------------------
# Synthesis
#-------------------------------------------------------------------------

check_design

compile_ultra

#-------------------------------------------------------------------------
# Outputs
#-------------------------------------------------------------------------

# Output the design which can be loaded into Synopsys DV later

write -format ddc -hierarchy -output post-synth.ddc

# Output the post-synth gate-level netlist

define_name_rules verilog -preserve_struct_ports
change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output post-synth.v

# Output the final timing constraints

write_sdc post-synth.sdc

# Report the critical path (i.e., setup-time constraint)

report_timing -nets > timing.rpt

# Report the area broken down by module

report_area -hierarchy > area.rpt

# Report which DesignWare components were used

report_resources -hierarchy > resources.rpt

exit