---
name: hew
description: Hew — deterministic 5-phase workflow with Three Mind checkpoints, domain-aware review, and coverage gates. Activate with /hew or when the user says "build this", "make this", "implement this", "get this done".
---

# Hew

Five phases. External verifiers. Human checkpoints. One task, one commit.

## Commands

```
/hew questions [--task "goal"]    Phase 1 — clarify scope
/hew research [--context ./docs]  Phase 2 — gather context
/hew planning                     Phase 3 — create roadmap
/hew context                      Phase 4 — generate PROJECT.md
/hew build [quick|strict] [--limit N]  Phase 5 — execute (default: 5 tasks)
/hew full [quick|strict]         Run all phases end-to-end
/hew checkpoint                   Force a Three Mind checkpoint now
/hew status                       Show current phase and progress
```

## Modes

| Mode | Pipeline | Gate |
|------|----------|------|
| default | Write → Test → Review → Fix → Verify → Done | Coverage ≥80% |
| quick | Write → Test → Verify → Done | None |
| strict | Write → Test → Review → Fix → Verify → Done | Coverage ≥90% |

## Phases

### 1. Questions
Clarify what success looks like. Ask: who is the user, what does done mean, what are the hard constraints, what is explicitly out of scope. Extract any issue references (`fixes #42`, `closes RM-123`).

→ Output: `QUESTIONS.md`

### 2. Research
Gather context without writing code. Find existing patterns, similar implementations, relevant docs. No code written here.

→ Output: `RESEARCH.md`

### 3. Planning
Translate questions + research into an actionable roadmap. Milestones (max 5). Atomic tasks per milestone. Every task has a verifiable success criterion.

→ Output: `ROADMAP.md`
⏸ **Pause here. Ask human to approve the roadmap before proceeding.**

### 4. Context
Generate a project overview: stack, constraints, conventions, glossary.

→ Output: `PROJECT.md`

### 5. Build
Execute tasks from ROADMAP using the pipeline for the current mode. **Default: 5 tasks per session, then checkpoint.**

For each task:
```
1. Write   — implement the task + tests
2. Test    — run test suite (exit 0 = pass)
3. Review  — domain-aware checklist (skip in quick mode)
4. Fix     — address review findings, return to Test
5. Verify  — type-check + lint + coverage (gate: see mode)
6. Done    — commit and move to next task
```

After every 5 tasks (or `--limit N`): run a **Three Mind checkpoint**.

### Domain-Aware Review (Phase 5, Review stage)

Detect spec keywords and inject relevant checklist items:

| Keywords | Checklist |
|----------|-----------|
| auth, password, login, token | Security: injection, hashing, token safety, session expiry |
| api, fetch, http, request | API: error handling, timeouts, retry logic, response validation |
| file, fs, read, write, save | I/O: error recovery, missing files, encoding, race conditions |
| async, promise, await | Async: error propagation, unhandled rejections, cancellation |
| ui, component, render, dom | UI: a11y, loading/empty/error states, responsive breakpoints |
| db, database, sql, query | Data: injection, transactions, connection pooling, migrations |

## Three Mind Checkpoint

| Mind | Horizon | Asks |
|------|---------|------|
| Strategic | Years | Are we building the right thing? Does this align with the goal? |
| Tactical | Quarters | Are we building it the right way? Architecture holding up? |
| Operational | Days | What is broken? What's the next blocker? |

Present each mind as a **scannable verdict**: ✅ on track / ⚠️ watch / 🔴 blocked, with a one-sentence note.

Then offer:
- **[c] Continue** — looks good, keep going
- **[p] Pivot** — adjust roadmap based on findings
- **[r] Refocus** — pause build, address a specific concern
- **[e] Edit roadmap** — modify remaining tasks
- **[d] Done** — run final review and ship
- **[a] Abort** — stop the project

## Completion Banner

When the workflow finishes, output this format:

```
✅ <project-name> is complete

📁 Location: <project-dir>/
🧪 Tests: All passing
📊 Coverage: <pct>% ✓ (≥<threshold>% required)

Linked: fixes #42, closes RM-123
```

## Failure: POSTMORTEM

If the build fails after max iterations (no convergence), generate:

```
## ⚠️ Workflow Failed — Post-Mortem

**Project**: <name>  |  **Iterations**: N/M
**Mode**: <mode>  |  **Coverage threshold**: <pct>%

### Timeline
- ✅ Write: ...
- ❌ Review: ...

### Root Cause
Last failure: **<stage>** — <detail>
```

## Verifiers

Run on every commit. Detect the project's stack and use the right tools:

```
1. Type-check  (tsc, mypy, rustc --check, go build, etc.)
2. Tests       (jest, pytest, cargo test, go test, etc.)
3. Lint        (eslint, ruff, clippy, golangci-lint, etc.)
```

**Any failure → stop, fix the issue, re-run from step 1. Commit only when all pass.**

## Files This Skill Creates

| File | Phase |
|------|-------|
| `QUESTIONS.md` | 1 |
| `RESEARCH.md` | 2 |
| `ROADMAP.md` | 3 |
| `PROJECT.md` | 4 |
| `README.md` | 5 (on completion) |
| `POSTMORTEM.md` | 5 (on failure) |

## Git Commits

Structured prefixes per stage:

```
wip: <project> — <task description>
test: <project> — all passing
fix: <project> — address review feedback
chore: <project> — workflow complete
```

## Anti-Patterns Prevented

| Anti-Pattern | How |
|--------------|-----|
| AI judges its own output | External verifiers decide pass/fail |
| Scope creep | Questions phase + human gate after planning |
| Unverified code shipped | Verifier loop before every commit |
| Drift from requirements | Strategic Mind flags misalignment |
| No failure trace | POSTMORTEM captures timeline + root cause |
