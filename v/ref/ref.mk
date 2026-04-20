#=========================================================================
# ref
#=========================================================================

ref_srcs = \
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
  Proc.v \

ref_tests = \
  Proc-addi-test.v \
  Proc-add-test.v \
  Proc-lw-test.v \
  Proc-sw-test.v \
  Proc-jal-test.v \
  Proc-jr-test.v \
  Proc-bne-test.v \

$(eval $(call check_part,ref))
