#=========================================================================
# ref
#=========================================================================

ref_srcs = \
  FullAdder.v \
  DFFRE.v \
  Adder_8b.v \
  EqComparator_8b.v \
  Mux2_8b.v \
  Mux4_8b.v \
  Register_8b.v \
  Register_16b.v \
  ALU_8b.v \
  ImmGen.v \
  Regfile.v \
  ProcDpath.v \
  ProcCtrl.v \
  ProcCtrl2.v \
  Proc.v \
  Proc2.v \

ref_cell_tests = \
  FullAdder-test.v \
  DFFRE-test.v \

ref_blocks_tests = \
  Adder_8b-test.v \
  EqComparator_8b-test.v \
  Mux2_8b-test.v \
  Mux4_8b-test.v \
  ALU_8b-test.v \
  ImmGen-test.v \
  Register_8b-test.v \
  Register_16b-test.v \
  Regfile-test.v \

ref_proc_tests = \
  Proc-addi-test.v \
  Proc-add-test.v \
  Proc-lw-test.v \
  Proc-sw-test.v \
  Proc-jal-test.v \
  Proc-jr-test.v \
  Proc-bne-test.v \
  Proc2-test.v \

ref_tests = $(ref_cell_tests) $(ref_blocks_tests) $(ref_proc_tests)

$(eval $(call check_part,ref_cell))
$(eval $(call check_part,ref_blocks))
$(eval $(call check_part,ref_proc))
$(eval $(call check_part,ref))
