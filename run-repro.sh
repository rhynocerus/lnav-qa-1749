#!/usr/bin/env bash
set -euo pipefail

RUNS="${1:-30}"

cmake -S . -B build
ctest --test-dir build

LOG="build/Testing/Temporary/LastTest.log"

echo
echo "Open this file in another terminal:"
echo "    lnav $LOG"
echo
echo "Then press ENTER here."
read -r

mkdir -p evidence
: > evidence/ctest-runs.log

for i in $(seq 1 "$RUNS"); do
    echo "========== RUN $i =========="

    ctest --test-dir build --output-on-failure

    stat \
      --printf="run=$i inode=%i size=%s mtime=%y\n" \
      "$LOG" | tee -a evidence/ctest-runs.log

    sleep 2
done

echo
echo "===== INODE SUMMARY ====="

awk '{
    for (i=1; i<=NF; i++)
        if ($i ~ /^inode=/)
            print $i
}' evidence/ctest-runs.log | sort | uniq -c
