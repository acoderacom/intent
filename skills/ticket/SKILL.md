---
name: ticket
description: Create and execute development tickets. Triggers on "I want...", "Add/Build/Create...", ticket IDs (INT-*), spec IDs (SPEC-*), "create ticket", "work on", "fetch ticket", "get ticket".
---

# Smart Intent Development — Ticket

Intent → Work → Test → Compound

## Prerequisites (BLOCKING)

Read `CLAUDE.md` for `## Intent Config`. Missing → `/setup` first. **No config = no proceed.**

## Routing

| Input | Detection | Action |
|-------|-----------|--------|
| New intent | "I want...", "Add...", "create ticket" | Step 1 |
| Spec ID | `SPEC-*` | Fetch spec → break into tickets |
| AI ticket ID | `INT-YYYYMMDD-HHMMSS` | Fetch → resume from status |
| Manual ticket | `INT-*-manual` suffix | Fetch → Enrich → Execute |

### From Spec

1. `npx intent-turso spec get <id>`
2. Read the ticket breakdown and sequence from the spec
3. For each ticket in the breakdown, run Steps 1-3 (Context, Clarify, Capture) — the spec provides intent and constraints, but each ticket still needs its own codebase exploration and plan
4. `AskUserQuestion`: "Create all tickets?" → All | One at a time | Revise
5. Create tickets, proceed to execute first ticket

### Manual Ticket Enrichment

1. `npx intent-turso ticket get <id>`
2. Run Steps 1-3 to fill gaps (Plan, Change Class, Constraints, etc.)
3. `npx intent-turso ticket update <id> --plan-stdin << 'EOF' ... EOF`
4. Proceed to Step 4

## Step 1: Context (search only)

```bash
npx intent-turso search "<intent>" --limit 5
```

Use `--ticket-type` filter when intent matches a specific type.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**Don't explore codebase yet** — knowledge informs exploration in Step 3.

**Quick mode:** Class A + no critical constraints (auth, payments, APIs, schema) → suggest `/task`. A single-file change to a critical module is NOT quick.

## Step 2: Clarify

`AskUserQuestion` — one question at a time, 2-4 options each. Lead with recommended option, explain trade-offs in descriptions. Gather enough to fill the ticket — don't over-ask for Class A work.

Be ready to go back and clarify if something doesn't make sense.

## Step 3: Capture and Plan

### Ticket Format

```markdown
# [INT-YYYYMMDD-HHMMSS] {intent summary}

**Status:** Backlog
**Type:** feature|bugfix|refactor|docs|chore|test (AI-inferred from intent)
**Intent:** [what user wants]
**Context:** [relevant files, patterns]
**Constraints:** Use: [list] | Avoid: [list]
**Assumptions:** [AI's guesses - surfaces misalignment]

**Tasks** (→ = sequential, ∥ = parallel)
- [ ] Task 1 description
- [ ] → Task 2 description
- [ ] ∥ Task 3 description

**Definition of Done**
- [ ] Criterion 1
- [ ] Criterion 2

**Change Class:** A|B|C - [reason]

## Plan

**Files to Edit:** file1.ts, file2.ts

**Tasks → Steps:**
- task: [task 1]
  - Implementation step
- task: [task 2]
  - Implementation step

**Definition of Done → Verification:**
- dod: [DoD 1] | verify: [how]
- dod: [DoD 2] | verify: [how]

**Decisions:**
- choice: [what] | reason: [why]

**Trade-offs:** (omit if none)
- considered: [alternative] | rejected: [reason]
- limitation: [what might break at scale]

**Rollback:** (Class B/C only)
- [how to undo] | Reversibility: full|partial|none

**Irreversible Actions:** (Class C only)
- [description]

**Edge Cases:** (Class C only)
- [condition]
```

### Create Ticket

**Plan section is required for all tickets.**

```bash
npx intent-turso ticket create --stdin << 'EOF'
# [INT-YYYYMMDD-HHMMSS] {intent summary}
**Status:** Backlog
...ticket fields...

## Plan
...plan fields...
EOF
```

### Steps

1. **Now explore codebase** (knowledge found → start from patterns/files, else broad)
2. Output Ticket using format above
3. Confirm by Change Class:
   - **Class A** → auto create ticket, proceed to execute
   - **Class B/C** → `AskUserQuestion`: "Create ticket and approve plan?" (Class C: note explicit approval required)
     - Yes, continue → create ticket, proceed to execute
     - Just create ticket → create ticket only, stop
     - Revise → adjust based on feedback
4. After confirm (or auto for Class A):
   - Create ticket using command above
   - Create tasks from ticket's **Tasks** via `TaskCreate`, set dependencies via `TaskUpdate`

## Step 4: Execute

1. Update ticket status to `In Progress`
2. For each task (respect dependency order):
   - `TaskUpdate` → `in_progress` → implement → `completed`
   - On failure → Failure Protocol
3. Use `TaskList` for next task

### Failure Protocol

1. **Fixable without changing the plan?** → Fix it, continue.
2. **Plan itself wrong?** → Stop. `AskUserQuestion`: explain what failed. Options: Revise plan | Abort.
3. **Blocked on something external?** → Status `Blocked`. `AskUserQuestion`: describe blocker.

### Abort Protocol

When user says "stop" or execution reveals the ticket is wrong:

1. Stop in-progress work immediately
2. `AskUserQuestion`: "Abort this ticket?"
   - **Revert & close** → status `Abandoned`, note reason, user handles reverting files
   - **Pause & keep** → status `Paused`, note where execution stopped and why
   - **Pivot** → new ticket informed by what was learned, original marked `Superseded`
3. **Always** extract gotcha knowledge from failures (Step 6)

## Step 5: Review (MANDATORY)

1. Update ticket status to `In Review`
2. Run code checks (test, lint, typecheck, build)
3. On failure, assess severity:
   - Test/lint fixes only → fix and re-run
   - Reveals plan flaw → trigger Failure Protocol
4. `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval: `npx intent-turso ticket update <id> --status "Done" --complete-all`

## Step 6: Compound

### Knowledge Format

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle|gotcha
**Source:** ticket
**Origin Ticket:** {ticket-id}
**Origin Ticket Type:** {ticket-type}
**Confidence:** {see Confidence Defaults}
**Scope:** new-only|global|backward-compatible|legacy-frozen
**Tags:** {kebab-case, comma-separated}

## Content

{Use Content Formats from Reference}
```

### Create Knowledge

```bash
npx intent-turso knowledge create --stdin << 'EOF'
...knowledge content...
EOF
```

### Steps

1. Review `extractProposals` from Step 5's "Done" response
2. **If ticket was aborted/failed:** always propose at least one gotcha entry
3. `AskUserQuestion`: "Extract this knowledge?" → Accept all | Select items | Skip
4. For accepted items, create using command above

---

## Reference

### Status Flow

`Backlog` → `In Progress` → `In Review` → `Done`

Extended: `Blocked` (waiting on external), `Paused` (stopped intentionally), `Abandoned` (aborted), `Superseded` (replaced by new ticket)

### Ticket Types

| Type | Inferred From |
|------|---------------|
| feature | add, create, build, implement, new |
| bugfix | fix, bug, error, broken, crash, fail |
| refactor | refactor, restructure, clean up, optimize |
| docs | document, readme, comment, explain |
| chore | deps, migrate, config, CI/CD |
| test | test, spec, coverage, e2e |

### Change Classes

| Class | Examples | Action |
|-------|----------|--------|
| A | Single file, tests, docs (not in critical paths) | Auto |
| B | Cross-module, APIs, deps | Propose |
| C | Schema, auth, payments | Approval |

### Confidence Defaults

| Category | Default |
|----------|---------|
| Truth | 0.9 |
| Architecture / Gotcha | 0.85 |
| Pattern | 0.8 |
| Principle | 0.75 |

### Content Formats

**Architecture:** `Component` / `Responsibility` / `Interfaces`

**Pattern:** `Why` / `When` / `Pattern`

**Truth:** `Fact` / `Verified`

**Principle:** `Rule` / `Why` / `Applies`

**Gotcha:** `Attempted` / `Failed Because` / `Instead` / `Symptoms`