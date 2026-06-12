# Guess-the-Number: A Copilot CLI Hooks Demo

A minimal example of **preToolUse** and **postToolUse** hooks. The agent plays a binary-search guessing game — hooks intercept every write to `GUESS.md` and feed back `HIGHER`, `LOWER`, or `CORRECT` via `additionalContext`, without the agent ever seeing the solution.

---

## How Hooks Work

Place a `.json` file in `.github/hooks/`. Copilot CLI loads all files there automatically. Each hook runs a script that receives tool call context on **stdin** and can return `{"additionalContext": "..."}` on **stdout** — that string is appended to the tool result the agent reads.

```
  User: "guess"
        │
        ▼
  ┌─────────────────────────────┐
  │  Agent (skill loaded)       │
  │  → calls edit on GUESS.md   │
  └──────────────┬──────────────┘
                 │
                 ▼
  ┌─────────────────────────────┐   stdin: { toolName, toolArgs }
  │  preToolUse hook            │
  │  pre-guess-hook-script.ps1/.sh │   If GUESS.md in args and no SOLUTION.md:
  │                             │   → generate solution, write SOLUTION.md
  └──────────────┬──────────────┘   stdout: (nothing)
                 │
                 ▼ tool executes — GUESS.md written
                 │
  ┌─────────────────────────────┐   stdin: { toolName, toolArgs, toolResult }
  │  postToolUse hook           │
  │  post-guess-hook-script.ps1/.sh │   Read GUESS.md vs SOLUTION.md:
  │                             │   → HIGHER / LOWER / CORRECT (+ cleanup)
  └──────────────┬──────────────┘   stdout: {"additionalContext": "HIGHER"}
                 │
                 ▼
  ┌─────────────────────────────┐
  │  Agent sees "HIGHER"        │
  │  → adjusts range, loops     │
  └─────────────────────────────┘
```

---

## Repo Layout

```
dlp-week-5/
├── .github/hooks/
│   └── guess.json                ← hook config (auto-loaded)
├── .agents/
│   ├── scripts/
│   │   ├── pre-guess-hook-script.{ps1,sh}   ← preToolUse: lazy game init
│   │   └── post-guess-hook-script.{ps1,sh}  ← postToolUse: judge guess, emit verdict
│   └── skills/guess-number/
│       └── SKILL.md              ← tells the agent to write guesses to GUESS.md
└── outputs/
    ├── GUESS.md                  ← agent writes here (hook creates if absent)
    └── SOLUTION.md               ← secret number (runtime only, not committed)
```

---

## Hook Config

See [`.github/hooks/guess.json`](.github/hooks/guess.json).

Copilot CLI auto-loads every `.json` file in `.github/hooks/`. Each entry in `preToolUse` or `postToolUse` is a hook command with these fields:

| Field        | Purpose                                                          |
|--------------|------------------------------------------------------------------|
| `version`    | Config schema version (`1`)                                      |
| `type`       | `"command"` — run an external process                            |
| `bash`       | Command used on macOS/Linux                                      |
| `powershell` | Command used on Windows                                          |
| `cwd`        | Working directory for the script (relative to repo root)         |
| `timeoutSec` | Hard kill timeout; keep hooks well under this limit              |

---

## Try It Yourself

```
// open copilot CLI from the project root
// type "guess" to trigger the `guess-number` skill
```

---

## Key Takeaways

- Hooks fire on **every** tool call — filter by `toolName`/`toolArgs` and exit 0 for calls you don't care about.
- `additionalContext` in stdout steers the agent without touching the real tool result.
- Always exit 0 — a non-zero exit blocks the tool call entirely.
- Provide both `bash` and `powershell` for cross-platform support.
- Skills set agent intent; hooks shape agent knowledge.
