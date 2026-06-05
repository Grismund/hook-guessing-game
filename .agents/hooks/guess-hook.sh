#!/usr/bin/env bash
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOLUTION_FILE="$REPO_ROOT/SOLUTION.md"

# No active game — skip silently
[ ! -f "$SOLUTION_FILE" ] && exit 0

GUESS=$(cat "$REPO_ROOT/GUESS.md" 2>/dev/null || true)
SECRET=$(cat "$SOLUTION_FILE")

[ -z "$GUESS" ] && exit 0

if (( GUESS == SECRET )); then
  rm -f "$SOLUTION_FILE"
  echo "{\"additionalContext\": \"CORRECT! The number was $SECRET.\"}"
  exit 0
elif (( GUESS > SECRET )); then
  echo '{"additionalContext": "LOWER"}'
  exit 0
else
  echo '{"additionalContext": "HIGHER"}'
  exit 0
fi