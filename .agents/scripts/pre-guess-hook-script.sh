#!/usr/bin/env bash
set -euo pipefail

 LOG_FILE="$(cd "$(dirname "$0")/../.." && pwd)/outputs/hook-log.txt"
 echo "$(date +"%Y-%m-%dT%H:%M:%S") $(basename "$0") invoked" >> "$LOG_FILE"

raw=$(cat 2>/dev/null || true)

if [ -z "$raw" ]; then
    exit 0
fi

if ! echo "$raw" | grep -qi "GUESS\.md"; then
    exit 0
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUTPUTS_DIR="$REPO_ROOT/outputs"
SOLUTION_FILE="$OUTPUTS_DIR/SOLUTION.md"
GUESS_FILE="$OUTPUTS_DIR/GUESS.md"

if [ ! -f "$SOLUTION_FILE" ]; then
    solution=$(( RANDOM % 100 + 1 ))
    printf '%s' "$solution" > "$SOLUTION_FILE"
fi

if [ ! -f "$GUESS_FILE" ]; then
    printf '' > "$GUESS_FILE"
fi

exit 0
