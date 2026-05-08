#!/usr/bin/env python3
import re
import sys
import subprocess
import tempfile
from pathlib import Path

if len(sys.argv) != 4:
    print("usage: gen_program_hex.py <test-v-file> <task-name> <output-hex>")
    sys.exit(1)

test_file = Path(sys.argv[1])
task_name = sys.argv[2]
out_file = Path(sys.argv[3])

src = test_file.read_text()

m = re.search(
    rf"task\s+{re.escape(task_name)}\s*\(\s*\)\s*;(.*?)endtask",
    src,
    flags=re.S,
)

if not m:
    raise SystemExit(f"Could not find task {task_name} in {test_file}")

body = m.group(1)

asm_calls = re.findall(
    r"asm\s*\(\s*'h([0-9a-fA-F]+)\s*,\s*\"([^\"]+)\"\s*\)",
    body,
)

if not asm_calls:
    raise SystemExit(f"No asm(...) calls found in task {task_name}")

lines = [
    '`include "/home/dnb68/processor/v/ref/tinyrv1.v"',
    "",
    "module Top;",
    "  TinyRV1 tinyrv1();",
    "  reg [15:0] word;",
    "",
    "  initial begin",
]

for addr, inst in asm_calls:
    lines.append(f'    word = tinyrv1.asm(8\'h{addr}, "{inst}");')
    lines.append(f'    $display("HEXWORD {int(addr,16):02x} %04h", word);')

lines += [
    "    $finish;",
    "  end",
    "endmodule",
    "",
]

with tempfile.NamedTemporaryFile("w", suffix=".sv", delete=False) as f:
    sv_path = Path(f.name)
    f.write("\n".join(lines))

cmd = [
    "/opt/cadence/XCELIUM2403/tools.lnx86/bin/64bit/xrun",
    "-64bit",
    "-sv",
    str(sv_path),
]

result = subprocess.run(
    cmd,
    cwd="/home/dnb68/processor",
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
)

words_by_index = {}

for line in result.stdout.splitlines():
    mm = re.search(r"HEXWORD\s+([0-9a-fA-F]+)\s+([0-9a-fA-F]{4})", line)
    if mm:
        byte_addr = int(mm.group(1), 16)
        word = mm.group(2).lower()
        words_by_index[byte_addr >> 1] = word

if not words_by_index:
    print(result.stdout)
    raise SystemExit("xrun did not produce any clean HEXWORD lines")

max_idx = max(words_by_index)

words = []
for i in range(max_idx + 1):
    words.append(words_by_index.get(i, "0000"))

out_file.parent.mkdir(parents=True, exist_ok=True)
out_file.write_text("\n".join(words) + "\n")

print(f"Wrote {out_file}")
for i, word in enumerate(words):
    print(f"{2*i:02x}: {word}")
