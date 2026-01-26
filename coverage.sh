
#!/usr/bin/env bash
# usage: coverage.sh <min_percent> [build_dir]
set -euo pipefail
MIN=${1:-70}
BDIR=${2:-build}
mkdir -p "$BDIR/coverage"
# Capture coverage
lcov --no-external --directory "$BDIR" --capture --output-file "$BDIR/coverage/coverage.info" >/dev/null 2>&1 || true
# Generate HTML (if available)
if command -v genhtml >/dev/null; then
  genhtml "$BDIR/coverage/coverage.info" --output-directory "$BDIR/coverage/html" >/dev/null 2>&1 || true
fi
# Extract total line coverage
PERCENT=$(lcov --summary "$BDIR/coverage/coverage.info" 2>/dev/null | awk '/lines/ {print $2}' | tr -d '%')
PERCENT=${PERCENT:-0}
echo "Total line coverage: ${PERCENT}% (min ${MIN}%)"
# Enforce threshold
awk -v p="$PERCENT" -v m="$MIN" 'BEGIN { if (p+0 < m+0) { exit 1 } }' || {
  echo "Coverage enforcement failed: ${PERCENT}% < ${MIN}%" >&2
  exit 2
}
