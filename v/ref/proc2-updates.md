# Proc2 Update — Encoding & Equations

## State Encoding

`s3 = state[3]`, `s2 = state[2]`, `s1 = state[1]`, `s0 = state[0]`. Reset = F0 = `0000` (DFFRE clears to 0 natively — no reset cells).

| State | Slot | Bin    |
|-------|------|--------|
| F0    | 0    | 0000   |
| F1    | 1    | 0001   |
| D     | 2    | 0010   |
| S0    | 3    | 0011   |
| S1    | 4    | 0100   |
| JR    | 5    | 0101   |
| A0    | 6    | 0110   |
| B0    | 7    | 0111   |
| B1    | 8    | 1000   |
| JA0   | 9    | 1001   |
| JA1   | 10   | 1010   |
| L0    | 11   | 1011   |
| L1    | 12   | 1100   |
| L2    | 13   | 1101   |
| AI    | 14   | 1110   |
| WB    | 15   | 1111   |

## Instruction Opcodes (= first-state slot)

| Inst  | Opcode |
|-------|--------|
| ADDI  | 1110   |
| ADD   | 0110   |
| LW    | 1011   |
| SW    | 0011   |
| JR    | 0101   |
| JAL   | 1001   |
| BNE   | 0111   |

## Signal Equations

`~x` is available as a shared INV off the corresponding state FF (or FF q_n output).

| Signal       | Equation                                                                  | Cells per signal |
|--------------|---------------------------------------------------------------------------|------------------|
| `op1_sel`    | `~((s0 & s1) \| s2)`                                                      | **AOI21 = 1**    |
| `pc_sel`     | `~s3`                                                                     | INV (free if FF q_n) |
| `op2_sel[1]` | `s3 \| ~s2`                                                               | OR2 = 1          |
| `op2_sel[0]` | `s0 & ~s1`                                                                | AND2 = 1         |
| `addr_sel`   | `s2`                                                                      | wire             |
| `idmem_type` | `s2 & ~s3`                                                                | AND2 = 1         |
| `addr_en`    | `s0 & s1 & ~s2`                                                           | AND3 = 1         |
| `rf_wen`     | `s0 & s1 & s2 & s3`                                                       | AND4 = 1         |
| `fetch_en`   | `s0 & ~s1 & ~s2 & ~s3`                                                    | AND4 = 1         |
| `ab_en`      | `s1 & ~s0 & ~s2 & ~s3`                                                    | AND4 = 1         |
| `pc_en`      | `(s0 & ~s1 & ~s3) \| (s3 & ~s0 & ~s2)`                                    | 2 AND3 + OR2 = 3 |
| `wd_en`      | `(s0 & s3 & ~s1) \| (s1 & s2 & ~s0)`                                      | 2 AND3 + OR2 = 3 |
| `idmem_val`  | `~((~s2 & s3) \| (s0 \| s1))` = `AOI21(~s2, s3, OR2(s0,s1))`              | **OR2 + AOI21 = 2** |
| `ns_sel[0]`  | `(s1 & ~s0) \| (s0 & s2 & s3 & ~s1)`                                      | AND2 + AND4 + OR2 = 3 |
| `ns_sel[1]`  | `AOI21(~s0, s3, s2) \| AND4(s2, s3, ~s0, ~s1) \| (AND4(~s3, s2, s1, s0) & ~eq)` | **AOI21 + AND4 + AND4 + AND2 + OR3 = 5** |

### AOI21-collapsed signals

Three signals collapse from a multi-cell SOP to a single AOI21 cell:

- **`op1_sel`** = `AOI21(s0, s1, s2)` — was AND2 + NOR2 (2 cells), now 1.
- **`idmem_val`** = `AOI21(~s2, s3, OR2(s0, s1))` — was AND2 + OR2 + AND2 (3 cells), now 2 (OR2 feeds the c-input).
- **`ns_sel[1]`** g1 term = `AOI21(~s0, s3, s2)` — was OR2 + AND2 (2 cells), now 1.

Net savings: **3 cells**.

### Inst-derived signals (in datapath, not ctrl)

| Signal       | Equation                            | Cells |
|--------------|-------------------------------------|-------|
| `imm_type`   | `inst[15]`                          | wire  |
| `wb_sel`     | `inst[13] & ~inst[14]`              | AND2 = 1 |

## Next-State Mux4

```
next_state = mux4(
  in0 = 4'b0000,        // F0 (reset)
  in1 = 4'b1111,        // WB
  in2 = state + 1,      // Incrementer_4b
  in3 = inst[15:12],    // dispatch
  sel = {ns_sel[1], ns_sel[0]}
)
```

State register: `state <= rst ? 4'b0000 : next_state` — single 4-bit DFFRE bank (4 cells).

---

## Cells Required

### Inverter

- **INV** — for `~s0`, `~s1`, `~s2`, `~s3` (state bits, 4 instances; can be shared via FF q_n outputs).
- **INV** — for `~inst[14]` (used by `wb_sel`, 1 instance).

Total: **5 INVs** (or as few as 1 if FF q_n outputs are used for state inverters).

### AND gates

- **AND2** — `op2_sel[0]`, `idmem_type`, `wb_sel`, plus `ns_sel[1]` eq-gated AND2.  Total: **4 AND2**.
- **AND3** — `addr_en`, `pc_en` (2×), `wd_en` (2×).  Total: **5 AND3**.
- **AND4** — `rf_wen`, `fetch_en`, `ab_en`, `ns_sel[0]`, `ns_sel[1]` (2 terms).  Total: **6 AND4**.

### OR gates

- **OR2** — `op2_sel[1]`, `idmem_val` (feeds AOI21 c-input), `pc_en`, `wd_en`, `ns_sel[0]`.  Total: **5 OR2**.
- **OR3** — `ns_sel[1]` (final merge of three groups).  Total: **1 OR3**.

### Compound gates (AOI / OAI)

- **AOI21** — `~((a & b) | c)`. Used by `op1_sel`, `idmem_val`, `ns_sel[1]` (g1 term).  Total: **3 AOI21**.

### Sequential / structural

- **DFFRE** — state register, 4 instances. Reset to 0 (= F0) natively.
- **Mux4_4b** — next-state mux, 1 instance.
- **Incrementer_4b** — `state + 1`, 1 instance.

### Notes for schematic translation

- **OR4 / AND4 framing**: equations use ANDn / ORn directly. The implementer maps each ANDn/ORn to a 2-stage NAND/NOR cascade in the schematic (e.g., AND2 = NAND2 + INV, or NAND-NAND in SOP merges).
- **AOI21** collapses 3 signals (`op1_sel`, `idmem_val`, `ns_sel[1]` g1-term) — saves 3 cells total.
- No XOR/XNOR cells are required.
- No NOR2 needed — AOI21 absorbed the only NOR2 use (`op1_sel`).
