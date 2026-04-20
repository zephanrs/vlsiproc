#=========================================================================
# eval
#=========================================================================

eval_tests = \
  Proc-vvadd-eval.v \
  Proc-sort-eval.v \

eval_exes := $(patsubst %.v, %, $(eval_tests))
eval_logs := $(patsubst %.v, %.log, $(eval_tests))
eval_deps := $(patsubst %.v, %.d, $(eval_tests))

$(eval_deps) : %.d : %.v
	$(VMKDEPS) -I $(top_dir)/v $* $<

$(eval_exes) : % : %.v
	$(VERILATOR_LINT) -I$(top_dir)/v --top-module Top $<
	$(IVERILOG_COMPILE) -I $(top_dir)/v -s Top -o $@ $<

$(eval_logs) : %.log : %
	./$< > $@

check-eval : $(eval_logs)
	@for log in $(eval_logs); do \
		echo ""; \
		cat $$log; \
	done
	@echo ""

.PHONY : check-eval

deps += $(eval_deps)
junk += $(eval_exes) $(eval_logs) $(eval_deps)
