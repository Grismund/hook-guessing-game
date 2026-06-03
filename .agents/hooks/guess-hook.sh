#!/usr/bin/env bash
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GUESS=$(cat "$REPO_ROOT/GUESS.md")
SECRET=$(cat "$(dirname "$0")/../secret.txt")
if (( GUESS == SECRET )); then
  echo "{\"additionalContext\": \"CORRECT! The number was $SECRET.\"}"
  exit 0
elif (( GUESS > SECRET )); then
  echo '{"additionalContext": "LOWER"}'
  exit 0
else
  echo '{"additionalContext": "HIGHER"}'
  exit 0
fi