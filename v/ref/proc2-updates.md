# Proc2 Update — Encoding & Equations

## State Encoding

`s3 = state[3]`, `s2 = state[2]`, `s1 = state[1]`, `s0 = state[0]`. Reset value = F0 = `0101`.

| State | Slot | Bin    |
|-------|------|--------|
| A0    | 0    | 0000   |
| WB    | 1    | 0001   |
| JR    | 2    | 0010   |
| B0    | 3    | 0011   |
| B1    | 4    | 0100   |
| F0    | 5    | 0101   |
| F1    | 6    | 0110   |
| D     | 7    | 0111   |
| AI    | 8    | 1000   |
| S0    | 9    | 1001   |
| S1    | 10   | 1010   |
| L0    | 11   | 1011   |
| L1    | 12   | 1100   |
| L2    | 13   | 1101   |
| JA0   | 14   | 1110   |
| JA1   | 15   | 1111   |

## Instruction Opcodes

| Inst  | Opcode (= first-state) |
|-------|-------------------------|
| ADD   | 0000                    |
| JR    | 0010                    |
| BNE   | 0011                    |
| ADDI  | 1000                    |
| SW    | 1001                    |
| LW    | 1011                    |
| JAL   | 1110                    |

## Signal Equations

| Signal       | SOP form                                                                  | Optimized form (compound gates)                                  | Cells |
|--------------|---------------------------------------------------------------------------|------------------------------------------------------------------|-------|
| `op1_sel`    | `s2`                                                                      | wire                                                             | 0     |
| `pc_sel`     | `s1 & ~s3`                                                                | `NOR2(~s1, s3)` or AND2 with one inv                             | 1     |
| `op2_sel[1]` | `s2 \| s3`                                                                | OR2 (or `NAND2(~s2, ~s3)` + INV upstream)                        | 1     |
| `op2_sel[0]` | `s1 & ~s0`                                                                | AND2 with inv (or `NOR2(~s1, s0)`)                               | 1     |
| `wb_sel`     | `inst[12]`                                                                | wire                                                             | 0     |
| `immgen_sel` | `inst[15] & (inst[13] \| ~inst[12])`                                      | `AOI21(~inst[13], inst[12], ~inst[15])` + INV (≡ original)       | 1–2   |
| `addr_sel`   | `~s0`                                                                     | INV                                                              | 1     |
| `idmem_type` | `~s2`                                                                     | INV                                                              | 1     |
| `addr_en`    | `s0 & s3 & ~s2`                                                           | AND3 (or `NAND3` + INV)                                          | 1     |
| `rf_wen`     | `s0 & ~s1 & ~s2 & ~s3`                                                    | `s0 & NOR3(s1,s2,s3)` = AND2 + NOR3                              | 2     |
| `fetch_en`   | `s1 & s2 & ~s0 & ~s3`                                                     | `AND2(s1,s2) & NOR2(s0,s3)`                                      | 3     |
| `ab_en`      | `s0 & s1 & s2 & ~s3`                                                      | AND4 (3 ones, 1 inv)                                             | 1     |
| `pc_en`      | `(s0&s1&s2&s3) \| (s1&~s0&~s3) \| (s2&~s0&~s3)`                           | `AND4(...) \| (NOR2(s0,s3) & OR2(s1,s2))`                        | 5     |
| `wd_en`      | `(s0&s2&s3&~s1) \| (s1&s2&s3&~s0) \| (~s0&~s1&~s2)`                       | `NOR3(s0,s1,s2) \| (AND2(s2,s3) & XOR2(s0,s1))`                  | 5     |
| `idmem_val`  | `(s0&s2&~s1&~s3) \| (s1&s3&~s0&~s2) \| (s2&s3&~s0&~s1)`                   | `(s0&s2 & NOR2(s1,s3)) \| (~s0&s3 & XOR2(s1,s2))`                | 5     |
| `ns_sel[1]`  | `~s3&s2&s0 \| ~s3&s2&s1 \| s3&s2&~s0 \| s3&~s2&s0 \| (~s3&~s2&s1&s0 & ~eq)` | `(~s3&s2&(s0\|s1)) \| (s3 & XOR2(s2,s0)) \| (NOR2(s3,s2)&s1&s0&~eq)` | 7 |
| `ns_sel[0]`  | `~s2&~s1&~s0 \| s2&s1&s0 \| s2&s3&s0`                                     | `NOR3(s0,s1,s2) \| (s2 & s0 & OR2(s1,s3))`                       | 4     |

### Compound-gate forms used

- **NOR2/NOR3** — replaces `~A & ~B [& ~C]` with one cell.
- **NAND2/NAND3** — replaces `~(A & B [& C])` with one cell (output is inverted).
- **AOI21** — `~((A & B) \| C)` in one cell. Used in `immgen_sel`.
- **XOR2** — collapses paired terms like `A&~B \| ~A&B` into one cell. Useful in `wd_en`, `idmem_val`, `ns_sel[1]`.
- **OR2/AND2/AND3/AND4** — base library cells.
- All output polarities are non-inverted (SOP form). Where a NAND/NOR is shown, it's because its native output happens to be the function we want (e.g., `NOR3(s0,s1,s2) = ~s0 & ~s1 & ~s2`).

## Next-State Mux4

```
next_state = mux4(
  in0 = 4'b0101,        // F0
  in1 = 4'b0001,        // WB
  in2 = state + 1,      // 4-bit incrementer
  in3 = inst[15:12],    // dispatch
  sel = {ns_sel[1], ns_sel[0]}
)
```
