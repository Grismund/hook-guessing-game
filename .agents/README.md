# .agents/

This directory contains AI-related configuration for the Lab 2 demo.

## Contents

| Path | Purpose |
|------|---------|
| `secret.txt` | Unused legacy file. The secret is now generated dynamically by the `preToolUse` hook. |
| `hooks/pre-guess-hook.sh` | Bash preToolUse hook (macOS / Linux). Fires before each tool call; generates a random secret in `SOLUTION.md` when the agent is about to write `GUESS.md`. |
| `hooks/pre-guess-hook.ps1` | PowerShell equivalent for Windows. |
| `hooks/guess-hook.sh` | Bash postToolUse hook. Reads `GUESS.md` and `SOLUTION.md`, returns HIGHER / LOWER / CORRECT feedback, and deletes `SOLUTION.md` on a correct guess. |
| `hooks/guess-hook.ps1` | PowerShell equivalent for Windows. |

## How it works

1. The AI agent is prompted to guess a number and write it to `GUESS.md`.
2. Before writing, the `preToolUse` hook detects that `GUESS.md` is the target and generates a random secret (1–100), storing it in `SOLUTION.md`. If `SOLUTION.md` already exists (mid-game re-guess), the secret is not regenerated.
3. After writing, the `postToolUse` hook reads both `GUESS.md` and `SOLUTION.md` and outputs a JSON `additionalContext` message with HIGHER, LOWER, or CORRECT feedback.
4. Feedback is injected back to the model so it can refine its guess.
5. When the agent guesses correctly, the hook deletes `SOLUTION.md`, ending the game.
6. The `postToolUse` hook is a no-op when `SOLUTION.md` does not exist, so it silently skips all tool calls outside an active game.

> **Note on exit codes:** Both hooks always `exit 0`. The `additionalContext` field in the JSON output is always injected back to the model regardless of exit code. Non-zero exit codes on `preToolUse` hooks are **fail-closed** and would block the tool call entirely, which is not what we want.
