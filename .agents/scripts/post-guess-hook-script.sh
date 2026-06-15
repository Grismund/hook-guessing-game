#!/usr/bin/env bash
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUTPUTS_DIR="$REPO_ROOT/outputs"
SOLUTION_FILE="$OUTPUTS_DIR/SOLUTION.md"
GUESS_FILE="$OUTPUTS_DIR/GUESS.md"

LOG_FILE="$REPO_ROOT/outputs/hook-log.txt"
 echo "$(date +"%Y-%m-%dT%H:%M:%S") $(basename "$0") invoked" >> "$LOG_FILE"

# No active game — skip silently
[ ! -f "$SOLUTION_FILE" ] && exit 0

GUESS=$(cat "$GUESS_FILE" 2>/dev/null || true)
SOLUTION=$(cat "$SOLUTION_FILE")

[ -z "$GUESS" ] && exit 0

if (( GUESS == SOLUTION )); then
  rm -f "$SOLUTION_FILE"
  rm -f "$GUESS_FILE"
  echo "{\"additionalContext\": \"CORRECT! The number was $SOLUTION.\"}"
  exit 0
elif (( GUESS > SOLUTION )); then
  echo '{"additionalContext": "Your guess was too high. Guess lower!"}'
  exit 0
else
  echo '{"additionalContext": "Your guess was too low. Guess higher!"}'
  exit 0
fi