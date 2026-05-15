# ⚒ Hew

> **hew** /hyo͞o/ — *v.* to shape or form with decisive, deliberate strikes. To conform, adhere, or hold true to a standard.

A disciplined, checkpointed development workflow for AI coding agents. Hew guides an agent through five phases — questions, research, planning, context, build — with human checkpoints, domain-aware code review, and coverage gates.

**Works with any CLI.** One install, use everywhere.

## Install

```bash
# npm (global)
npm install -g @jecruz/hew
hew-install --claude --codex --pi --hermes --all

# Or just for Claude
hew-install --claude

# Or from git
git clone https://github.com/jecruz/hew.git /tmp/hew && bash /tmp/hew/install.sh
```

### Supported CLIs

| Flag | Target |
|------|--------|
| `--claude` | Claude Code (`~/.claude/skills/hew/`) |
| `--codex` | Codex CLI (`~/.codex/skills/hew/`) |
| `--pi` | Pi (`~/.pi/agent/extensions/hew.js`) |
| `--hermes` | Hermes (`~/.hermes/skills/hew/`) |
| `--all` | All of the above |

```bash
hew-install --global --claude        # Global install for Claude
hew-install --local --codex           # Project-local for Codex
hew-install --uninstall --claude      # Remove
```

## Usage

```
/hew questions [--task "goal"]    Clarify scope and constraints
/hew research [--context ./docs]  Gather context, no code
/hew planning                     Create roadmap with milestones
/hew context                      Generate PROJECT.md
/hew build [quick|strict]         Execute tasks (default: 5 per session)
/hew full [quick|strict]          Run all phases end-to-end
/hew checkpoint                   Force a Three Mind checkpoint
/hew status                       Show current phase and progress
```

## Modes

| Mode | Pipeline | Gate |
|------|----------|------|
| `default` | Write → Test → Review → Fix → Verify → Done | Coverage ≥80% |
| `quick` | Write → Test → Verify → Done | None |
| `strict` | Write → Test → Review → Fix → Verify → Done | Coverage ≥90% |

## How It Works

### Five Phases

1. **Questions** — Clarify what success looks like before writing code
2. **Research** — Gather context from the codebase without building
3. **Planning** — Translate into a roadmap with milestones and atomic tasks
4. **Context** — Generate project overview and conventions
5. **Build** — Execute tasks via a Write → Test → Review → Fix → Verify pipeline

### Three Mind Checkpoints

Every 5 tasks, Hew pauses for a checkpoint from three perspectives:

| Mind | Horizon | Concern |
|------|---------|---------|
| Strategic | Years | Are we building the right thing? |
| Tactical | Quarters | Are we building it the right way? |
| Operational | Days | What is broken right now? |

### Domain-Aware Review

The review stage detects spec keywords and injects relevant checklist items:

| Keywords | Checklist |
|----------|-----------|
| auth, password, login, token | Security: injection, hashing, token safety |
| api, fetch, http, request | API: error handling, timeouts, response validation |
| file, fs, read, write, save | I/O: error recovery, missing files, encoding |
| async, promise, await | Async: error propagation, unhandled rejections |
| ui, component, render, dom | UI: accessibility, loading/error states, responsive |
| db, database, sql, query | Data: injection, transactions, connection pooling |

## Philosophy

- **AI never judges its own output.** The compiler, test suite, and linter judge it.
- **Every commit is verified.** Type-check → test → lint. Any failure stops the commit.
- **One task, one commit.** Atomic, reviewable, revertible.
- **Human gates at key decisions.** Pause after planning. Checkpoint during build.

## Anti-Patterns Prevented

| Anti-Pattern | How Hew Prevents It |
|--------------|---------------------|
| AI judges its own output | External verifiers decide pass/fail |
| Scope creep | Questions phase + human gate after planning |
| Unverified code shipped | Verifier loop before every commit |
| Drift from requirements | Strategic Mind flags misalignment |
| No failure trace | POSTMORTEM captures timeline + root cause |

## License

MIT
