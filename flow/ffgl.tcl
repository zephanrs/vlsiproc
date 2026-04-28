#=========================================================================
# ffgl.tcl
#=========================================================================

# Proc2 FFGL simulation manifest. The shell wrapper uses the same files
# directly when invoking VCS.

set proc2_ffgl_top Top
set proc2_ffgl_test proc2_ffglsim

set proc2_ffgl_verilog_files [list \
  "../v/test/test-utils.v" \
  "../v/test/TestMemory.v" \
  "Proc2-testbench-pickled.v" \
  "Proc2-top-pickled.v" \
  "$env(TSMC_180NM)/stdcells.v" \
  "post-synth.v" \
]
