#!/usr/bin/env bash
set -euo pipefail

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
    secret=$(( RANDOM % 100 + 1 ))
    printf '%s' "$secret" > "$SOLUTION_FILE"
fi

if [ ! -f "$GUESS_FILE" ]; then
    printf '' > "$GUESS_FILE"
fi

exit 0
