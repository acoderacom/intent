---
name: task
description: Quick execution for confident, low-risk changes. Triggers on "quick fix", "just do it", "simple change", or "/task". Skips ceremony, preserves knowledge.
---

# Task — Small Stuff, Just Do It

Skip ceremony, preserve knowledge. The lightweight entry point in the SID loop.

**When to use:** Simple fixes, obvious changes, Class A only.
**When NOT to use:** Complex features, unclear requirements, Class B/C → `/ticket`.

## Prerequisites (BLOCKING)

Read `CLAUDE.md` for `## Intent Config`. Missing → `/setup` first. **No config = no proceed.**

## Step 1: Context (search only)

```bash
npx intent-turso search "<intent>" --limit 3
```

Use `--ticket-type` filter when intent matches a specific type.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**Don't explore codebase yet** — knowledge informs exploration in Step 2.

## Step 2: Execute

1. **Now explore codebase** (knowledge found → start from patterns/files, else broad)
2. Implement directly — no ticket, no task tracking
3. Run checks (test, lint, typecheck)
4. Fix failures → re-run

**Complexity check:** If unclear or risky → "This seems complex, switch to /ticket?"
