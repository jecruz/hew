---
name: hew
description: Hew — deterministic 5-phase workflow with Three Mind checkpoints, domain-aware review, code review gates, and coverage gates. Activate with /hew or when the user says "build this", "make this", "implement this", "get this done".
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
| default | Write → Test → Domain Review → Code Review → Fix → Re-verify → Done | 0 BLOCKERs, Coverage ≥80% |
| quick | Write → Test → Verify → Done | None |
| strict | Write → Test → Domain Review → Code Review → Fix → Re-verify → Done | 0 BLOCKERs, Coverage ≥90% |

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
1. Write         — implement the task + tests
2. Test          — run test suite (exit 0 = pass). If fail → fix → retest until green
3. Domain Review — keyword-aware checklist (skip in quick mode)
4. Code Review   — severity-classified review of changed files only (skip in quick mode)
5. Fix           — address all BLOCKER findings. WARNINGs noted for backlog
6. Re-verify     — type-check + test + lint + coverage (gate: see mode). Must pass
7. Done          — commit and move to next task
```

After every 5 tasks (or `--limit N`): run a **Three Mind checkpoint**.

### Domain Review (Phase 5, Stage 3)

Detect spec keywords and inject relevant checklist items:

| Keywords | Checklist |
|----------|-----------|
| auth, password, login, token | Security: injection, hashing, token safety, session expiry |
| api, fetch, http, request | API: error handling, timeouts, retry logic, response validation |
| file, fs, read, write, save | I/O: error recovery, missing files, encoding, race conditions |
| async, promise, await | Async: error propagation, unhandled rejections, cancellation |
| ui, component, render, dom | UI: a11y, loading/empty/error states, responsive breakpoints |
| db, database, sql, query | Data: injection, transactions, connection pooling, migrations |

### Code Review (Phase 5, Stage 4)

Review only the changed files (diff-only). Classify every finding by severity:

| Severity | Icon | Rule |
|----------|------|------|
| **BLOCKER** | 🔴 | Must fix before commit. Bugs, security holes, broken logic. |
| **WARNING** | 🟡 | Should fix. Code smells, magic numbers, poor naming. Deferred to backlog. |
| **INFO** | 🔵 | Consider. Missing docs, optimization opportunities. Optional. |

General review checklist:
- Error handling: every promise/call has a catch or propagates
- Naming: variables, functions, files are clear and idiomatic
- DRY: no copy-pasted logic within the diff
- Dead code: no unreachable branches or unused imports
- Types: no `any` without justification, no unsafe casts
- Logging: errors are logged, not swallowed
- Tests: new logic has corresponding test coverage

Output format:
```
🔍 Code Review — 3 files changed
🔴 BLOCKER — src/bot.ts:42 — unhandled promise in streamResponse
🟡 WARNING — src/db.ts:15 — magic number 4096, extract to constant
🔵 INFO — src/main.ts — consider adding startup health check
```

**Gate: 0 BLOCKERs required before commit.** If BLOCKERs exist, fix them and re-run Re-verify.

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

```
✅ <project-name> is complete

📁 Location: <project-dir>/
🧪 Tests: All passing
📊 Coverage: <pct>% ✓ (≥<threshold>% required)

Linked: fixes #42, closes RM-123
```

## Failure: POSTMORTEM

```
## ⚠️ Workflow Failed — Post-Mortem

**Project**: <name>  |  **Iterations**: N/M
**Mode**: <mode>  |  **Coverage threshold**: <pct>%

### Timeline
- ✅ Write: ...
- ❌ Code Review: 2 BLOCKERs unresolved

### Root Cause
Last failure: **<stage>** — <detail>
```

## Verifiers

Detect the project's stack and use the right tools:

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

```
wip: <project> — <task description>
test: <project> — all passing
fix: <project> — address review feedback
chore: <project> — workflow complete
```

## Anti-Patterns Prevented

| Anti-Pattern | How |
|--------------|-----|
| AI judges its own output | External verifiers + code review decide pass/fail |
| Scope creep | Questions phase + human gate after planning |
| Unverified code shipped | Verifier loop + 0 BLOCKER gate before every commit |
| Drift from requirements | Strategic Mind flags misalignment |
| No failure trace | POSTMORTEM captures timeline + root cause |
| Silent bugs merged | Code review catches logic errors before commit |
