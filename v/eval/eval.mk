#=========================================================================
# eval
#=========================================================================

eval_dir := $(top_dir)/v/eval

eval_srcs = \
  $(eval_dir)/Proc-vvadd-eval.v \
  $(eval_dir)/Proc-sort-eval.v \

eval_exes := $(patsubst $(eval_dir)/%.v, %, $(eval_srcs))
eval_logs := $(patsubst $(eval_dir)/%.v, %.log, $(eval_srcs))
eval_deps := $(patsubst $(eval_dir)/%.v, %.d, $(eval_srcs))

$(eval_deps) : %.d : $(eval_dir)/%.v
	$(VMKDEPS) -I $(top_dir)/v $* $<

$(eval_exes) : % : $(eval_dir)/%.v
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
