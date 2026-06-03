# .agents/

This directory contains AI-related configuration for the Lab 2 demo.

## Contents

| Path | Purpose |
|------|---------|
| `secret.txt` | The secret number the AI must guess. Change this before playing. |
| `hooks/guess-hook.sh` | Bash hook script (macOS / Linux). Reads `GUESS.md`, compares to `secret.txt`, and returns HIGHER / LOWER / CORRECT feedback. |
| `hooks/guess-hook.ps1` | PowerShell equivalent for Windows. |

## How it works

1. The player edits `secret.txt` to set their secret number.
2. The AI agent is prompted to guess a number and write it to `GUESS.md`.
3. The `postToolUse` hook fires after every file-write tool call.
4. The hook script reads the guess from `GUESS.md` and outputs a JSON `additionalContext` message.
5. A **non-zero exit code** causes Copilot CLI to inject the context back to the model so it can refine its guess.
6. The loop continues until the AI guesses correctly (exit code 0).
