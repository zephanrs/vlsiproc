# TinyRV1 ISA

## 1. TinyRV1 Architectural State

### 1.1. Data Formats

TinyRV1 only supports 1B (one-byte) signed and unsigned integer values. There are no half-word nor word values and no floating-point.

### 1.2. General-Purpose Registers

There are 7 general-purpose registers (GPRs) `x1`–`x7` (called x registers), which hold integer values. Register `x0` is hardwired to the constant zero. Each register is 8 bits wide.

| Register | Description                  |
|----------|------------------------------|
| x0       | The constant value 0         |
| x1–x7    | General-purpose registers    |

### 1.3. Memory

TinyRV1 supports a byte-addressable 8-bit address space (256B total). TinyRV1 uses a little-endian memory system. By convention the first 128B are used for instructions (64 two-byte instructions) and the second 128B are used for data (128 one-byte words).

## 2. TinyRV1 Encoding

The TinyRV1 ISA uses a fixed 16-bit instruction format. There is one instruction format with two immediate encodings. Each instruction has a specific instruction type, and if that instruction includes an immediate, then it will also have an immediate type.

### 2.1. Instruction Format

All TinyRV1 instructions are encoded in 16 bits with the following fixed field layout:

```
 15       12 11      9 8       6 5       3 2      0
 | opcode    | rd      | rs1     | rs2     | imm    |
 | [15:12]   | [11:9]  | [8:6]   | [5:3]   | [2:0]  |
```

| Field    | Bits    | Width |
|----------|---------|-------|
| `opcode` | [15:12] | 4     |
| `rd`     | [11:9]  | 3     |
| `rs1`    | [8:6]   | 3     |
| `rs2`    | [5:3]   | 3     |
| `imm`    | [2:0]   | 3     |

### 2.2. Immediate Formats

TinyRV1 has two 6-bit immediate encodings that are sign-extended to 8 bits. The sign-bit for the immediate is always in bit 5 of the reconstructed immediate (i.e., the most-significant bit of the 6-bit field).

#### I-immediate

Used by ADDI, LW, and JAL. The 6-bit immediate is formed by concatenating the `rs2` and `imm` fields:

```
imm[5:0] = { inst[5:3], inst[2:0] }
```

Sign-extended to 8 bits: `{ {2{inst[5]}}, inst[5:3], inst[2:0] }`

#### S-immediate

Used by SW and BNE. The 6-bit immediate is formed by concatenating the `rd` and `imm` fields:

```
imm[5:0] = { inst[11:9], inst[2:0] }
```

Sign-extended to 8 bits: `{ {2{inst[11]}}, inst[11:9], inst[2:0] }`

## 3. TinyRV1 Instructions

For each instruction we include a brief summary, assembly syntax, instruction semantics, instruction and immediate encoding format, and the actual encoding for the instruction. We use the following conventions when specifying the instruction semantics:

- `R[rx]`: general-purpose register value for register specifier `rx`
- `sext`: sign extend to 8 bits
- `M[addr]`: 1-byte memory value at address `addr`
- `PC`: current program counter
- `imm`: immediate according to the immediate type
- `addr`: 8-bit absolute memory address

### 3.1. ADDI

- Summary: Add constant
- Assembly: `addi rd, rs1, imm`
- Format: I-type, I-immediate
- Encoding: opcode = `0010`
- Semantics:

```
R[rd] <- R[rs1] + sext(imm)
PC <- PC + 2
```

### 3.2. ADD

- Summary: Addition with 3 GPRs (no overflow)
- Assembly: `add rd, rs1, rs2`
- Format: R-type
- Encoding: opcode = `1000`
- Semantics:

```
R[rd] <- R[rs1] + R[rs2]
PC <- PC + 2
```

### 3.3. LW

- Summary: Load byte from memory
- Assembly: `lw rd, imm(rs1)`
- Format: I-type, I-immediate
- Encoding: opcode = `0011`
- Semantics:

```
R[rd] <- M[ R[rs1] + sext(imm) ]
PC <- PC + 2
```

### 3.4. SW

- Summary: Store byte in memory
- Assembly: `sw rs2, imm(rs1)`
- Format: S-type, S-immediate
- Encoding: opcode = `1100`
- Semantics:

```
M[ R[rs1] + sext(imm) ] <- R[rs2]
PC <- PC + 2
```

TinyRV1 does not support self-modifying code. Using a SW instruction to write memory locations which will eventually be fetched as instructions results in undefined behavior.

### 3.5. JAL

- Summary: Jump to address, place return address in GPR
- Assembly: `jal rd, addr`
- Format: I-type, I-immediate
- Encoding: opcode = `1010`
- Semantics:

```
R[rd] <- PC + 2
PC <- addr
```

The encoded immediate `imm` is calculated during assembly such that `PC + sext(imm) = addr`. TinyRV1 requires the JAL target address to always be two-byte aligned (i.e., the bottom bit must be zero). An unaligned JAL target address results in undefined behavior.

### 3.6. JR

- Summary: Jump to address in register
- Assembly: `jr rs1`
- Format: R-type
- Encoding: opcode = `1001`
- Semantics:

```
PC <- R[rs1]
```

TinyRV1 requires the JR target address to always be two-byte aligned (i.e., the bottom bit must be zero). An unaligned JR target address results in undefined behavior.

### 3.7. BNE

- Summary: Branch if two GPRs are not equal
- Assembly: `bne rs1, rs2, addr`
- Format: S-type, S-immediate
- Encoding: opcode = `0100`
- Semantics:

```
if ( R[rs1] != R[rs2] )
  PC <- addr
else
  PC <- PC + 2
```

The encoded immediate `imm` is calculated during assembly such that `PC + sext(imm) = addr`. TinyRV1 requires the BNE target address to always be two-byte aligned (i.e., the bottom bit must be zero). An unaligned BNE target address results in undefined behavior.

## 4. TinyRV1 "Privileged" ISA

TinyRV1 does not support any kind of distinction between user and privileged mode (which is why privileged is in quotes).

### 4.1. Reset Vector

On reset, `PC` will reset to an implementation-defined value. TinyRV1 defines this to be at `0x00`.

### 4.2. Address Map

TinyRV1 only supports the most basic form of address translation. Every logical address is directly mapped to the corresponding physical address. As mentioned above, TinyRV1 supports a 256B address space. By convention the first 128B are used for instructions and the second 128B are used for data. All other addresses are undefined.

```
      .--------------.
 0xff |              | \
 ...  |              | | 128B
 0x81 | data         | | (128x1B words)
 0x80 |              | /
      +--------------+
 0x7f |              | \
 ...  |              | | 128B
 0x01 | instructions | | (64x2B instructions)
 0x00 |              | / <- reset PC
      '--------------'
```

## 5. TinyRV1 Pseudo-Instructions

It is very important to understand the relationship between the "real" instructions presented in this manual and pseudo-instructions. There is one instruction we need to be careful with: `NOP`.

`NOP` is always a pseudo-instruction. It is always equivalent to the following use of the `ADDI` instruction:

```
addi x0, x0, 0
```

## 6. Acknowledgements

This ISA specification is based on the TinyRV1 ISA originally designed by Christopher Batten at Cornell University for use in ECE 2300 (Digital Logic and Computer Organization). The original TinyRV1 specification is available at the [ECE 2300 course website](https://cornell-ece2300.github.io/ece2300-mkdocs/ece2300-tinyrv1-isa/). The version described in this document is a modified 16-bit variant adapted for use in ECE 4740.
