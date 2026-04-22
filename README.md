# VLSI Final Project

## Setup
```bash
source scripts/setup-project.sh
```

## Running Tests
```bash
mkdir -p build && cd build # Go to an out-of-source build directory
../configure               # Generate the Makefile
make check-ref             # Compile and run the Verilog tests
# or make check-ref-verbose
```

## Datapath Floorplanning
```bash
python3 scripts/datapath_floorplan.py \
  --verilog v/ref/ProcDpath.v \
  --module-dir v/ref \
  --out-dir build/floorplan
```

This extracts instance-to-instance datapath nets from `ProcDpath`, propagates
simple assign-derived field wires (e.g. `rs1/rs2/rd` off `inst`), estimates
first-order block size from the referenced module definitions, and runs a
simulated annealer on a 1D ordering. The primary objective is max cut overlap;
the secondary objective is quadratic wire cost (`width * span^2`). By default
the tool now uses a balanced normalized score so wire cost can win when the
overlap increase is small; `--cost-mode strict` restores the old
overlap-first behavior.

Outputs:
- `proc-dpath-floorplan.svg` visual floorplan + wire spans + cut-bandwidth profile
- `proc-dpath-floorplan-bitslice.svg` column/track bitslice-style view for hand floorplanning
- `proc-dpath-floorplan.json` machine-readable blocks, wires, and metrics
- `proc-dpath-floorplan.txt` compact human-readable summary

Useful flags:
- `--steps N` to trade runtime for annealing quality
- `--seed N` for reproducible runs
- `--cost-mode balanced|strict` to switch between weighted tradeoff and strict overlap-first scoring
- `--overlap-weight X` and `--wire-cost-weight Y` to tune the balanced objective
- `--include-ports` to keep top-level ports as explicit wire endpoints
- `--stdout-report` to print the text summary directly; GitHub Actions uses this as the main check output
