#=========================================================================
# ref
#=========================================================================

ref_srcs = \
  INV.v \
  AND2.v \
  AND3.v \
  AND4.v \
  OR2.v \
  OR3.v \
  NAND2.v \
  NAND3.v \
  NOR2.v \
  NOR3.v \
  XOR2.v \
  AOI21.v \
  FullAdder.v \
  DFFRE.v \
  Adder_8b.v \
  EqComparator_8b.v \
  Mux2_8b.v \
  Mux4_8b.v \
  Mux4_4b.v \
  Incrementer_4b.v \
  Register_4b.v \
  Register_8b.v \
  Register_16b.v \
  RegEn_8b.v \
  RegEn_16b.v \
  ALU_8b.v \
  ImmGen.v \
  Regfile.v \
  ProcDpath.v \
  ProcCtrl.v \
  Proc.v \
  Proc2Dpath.v \
  Proc2Ctrl.v \
  Proc2.v \

ref_cell_tests = \
  INV-test.v \
  AND2-test.v \
  AND3-test.v \
  AND4-test.v \
  OR2-test.v \
  OR3-test.v \
  NAND2-test.v \
  NAND3-test.v \
  NOR2-test.v \
  NOR3-test.v \
  XOR2-test.v \
  AOI21-test.v \
  FullAdder-test.v \
  DFFRE-test.v \

ref_blocks_tests = \
  Adder_8b-test.v \
  EqComparator_8b-test.v \
  Mux2_8b-test.v \
  Mux4_8b-test.v \
  Mux4_4b-test.v \
  Incrementer_4b-test.v \
  ALU_8b-test.v \
  ImmGen-test.v \
  Register_4b-test.v \
  Register_8b-test.v \
  Register_16b-test.v \
  Regfile-test.v \

ref_proc_tests = \
  Proc2Ctrl-test.v \
  Proc2-test.v \

ref_tests = $(ref_cell_tests) $(ref_blocks_tests) $(ref_proc_tests)

$(eval $(call check_part,ref_cell))
$(eval $(call check_part,ref_blocks))
$(eval $(call check_part,ref_proc))
$(eval $(call check_part,ref))
