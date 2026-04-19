#=========================================================================
# ref
#=========================================================================

ref_srcs = \
  Adder_32b.v \
  EqComparator_32b.v \
  Mux2_32b.v \
  Mux4_32b.v \
  Register_32b.v \
  Multiplier_32x32b.v \
  ALU_32b.v \
  ImmGen.v \
  Regfile.v \
  ProcDpath.v \
  ProcCtrl.v \
  Proc.v \

ref_tests = \
  Proc-addi-test.v \
  Proc-add-test.v \
  Proc-mul-test.v \
  Proc-lw-test.v \
  Proc-sw-test.v \
  Proc-jal-test.v \
  Proc-jr-test.v \
  Proc-bne-test.v \

$(eval $(call check_part,ref))
