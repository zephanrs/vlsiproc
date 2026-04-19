export ECE2300_INSTALL="/classes/ece2300/install"
export PATH="${ECE2300_INSTALL}/pkgs/modules-5.4.0/bin:${PATH}"
source "${ECE2300_INSTALL}/pkgs/modules-5.4.0/init/bash"
module use "${ECE2300_INSTALL}/modules"

module load ece2300-scripts/0.0
module load bash-completion/2.14.0
module load gcc/13.2.1
module load iverilog/12.0
module load verilator/5.026
module load gtkwave/3.3.120
module load verible/0.0-3756-gda9a0f8c
module load python/3.11.9
module load venvs/py3.11.9-default

module load siemens/questasim
module load synopsys/synopsys-dc
module load cadence/innovus
module load cadence/cadence

export ASSURAHOME=/opt/cadence/ASSURA41
export QRC_HOME=/opt/cadence/QUANTUS231
export PATH=$ASSURAHOME/tools/bin:$QRC_HOME/bin:$QRC_HOME/tools/bin:$PATH
export OA_HOME=/opt/cadence/IC231.007/oa_v22.61.014
export OA_UNSUPPORTED_PLAT=linux_rhel70_gcc93x
export CDS_Netlisting_Mode=Analog

export PS1="\[\e[1;34m\]proc:\[\e[0m\] \[\e[1m\]\w\[\e[0m\] % "
export PROMPT_DIRTRIM=2
alias rmlck='find . -type f -name "*cdslck*" -delete'
export SETUP_COURSE="project"