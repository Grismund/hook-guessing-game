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
SOLUTION_FILE="$REPO_ROOT/SOLUTION.md"

if [ ! -f "$SOLUTION_FILE" ]; then
    secret=$(( RANDOM % 100 + 1 ))
    printf '%s' "$secret" > "$SOLUTION_FILE"
fi

exit 0
