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
