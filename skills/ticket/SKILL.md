---
name: ticket
description: Create and execute development tickets. Triggers on "I want...", "Add/Build/Create...", ticket IDs (INT-*), or "create ticket". Covers features, components, and behavior changes.
---

# Intent-First Development

Turn user intent into validated tickets. AI executes, human reviews, knowledge compounds.

**Mental Model:** Ticket = Contract (WHAT & WHY) | Plan = Playbook (HOW) | Knowledge = Memory (LEARNED)

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. If missing → `/intent:setup` first
3. **No config = no proceed**

## Step 1: Context (search only)

Read `CLAUDE.md`. Search knowledge → `npx intent-turso search "<intent>" --limit 5`

Use `--ticket-type` filter when intent matches a specific type.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**Do NOT explore codebase yet** - knowledge informs exploration strategy in Step 3.

**Quick mode check:** If intent is **Class A AND has no notable constraints** (not touching auth, payments, shared APIs, or schema) → suggest `/ticket-quick` instead. A single-file change to a critical module is NOT quick.

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. For multiple approaches lead with recommended option, explain trade-offs in descriptions. Gather enough to fill the ticket — don't over-ask for Class A work.

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

**Tasks** (→ = depends on previous, ∥ = parallelizable)
- [ ] Task 1 description
- [ ] → Task 2 description (depends on Task 1)
- [ ] ∥ Task 3 description (parallel with Task 2)

**Definition of Done**
- [ ] Criterion 1
- [ ] Criterion 2

**Change Class:** A|B|C - [reason]

## Plan

**Files to Edit:** file1.ts, file2.ts

**Tasks → Steps:**
- task: [ticket task 1]
  - Implementation step
- task: [ticket task 2]
  - Implementation step

**Definition of Done → Verification:**
- dod: [ticket DoD 1] | verify: How to verify
- dod: [ticket DoD 2] | verify: How to verify

**Decisions:** (implementation-level only, not ticket decisions)
- choice: What | reason: Why

**Trade-offs:** (omit if none)
- considered: [alternative] | rejected: [reason]
- limitation: [what might break at scale]

**Rollback:** (required for Class B/C, omit for Class A)
- How to undo changes if execution goes wrong
- Reversibility: full|partial|none

**Irreversible Actions:** (required for Class C, omit if none for A/B)
- Description of action that can't be undone

**Edge Cases:** (required for Class C, omit if none for A/B)
- Condition that might cause issues
```

### Create Ticket

```bash
npx intent-turso ticket create --stdin << 'EOF'
# [INT-YYYYMMDD-HHMMSS] {intent summary}
**Status:** Backlog
...ticket fields...

## Plan
...plan fields (REQUIRED)...
EOF
```
```

### Steps

1. **NOW explore codebase** (knowledge found → start from patterns/files, else broad)
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
2. For each task (respecting dependency order):
   - `TaskUpdate` → `in_progress` → implement → `completed`
   - **On task failure:** see Failure Protocol below
3. Use `TaskList` for next task

### Failure Protocol

When a task fails during execution:

1. **Can you fix it without changing the plan?** → Fix it, continue.
2. **Is the plan itself wrong?** → Stop. `AskUserQuestion`: explain what failed and why. Options: Revise plan | Abort (see Abort Protocol).
3. **Blocked on something external?** → Stop. Update ticket status to `Blocked`. `AskUserQuestion`: describe blocker.

### Abort Protocol

When the user says "stop" or execution reveals the ticket itself is wrong:

1. Stop all in-progress work immediately
2. `AskUserQuestion`: "Abort this ticket?"
   - **Revert & close** → update ticket status to `Abandoned`, note reason, let user handle reverting files
   - **Pause & keep** → leave changes in place, update ticket status to `Paused`, note where execution stopped and why
   - **Pivot** → create new ticket informed by what was learned, link to original, update original status to `Superseded`
3. **Always** extract knowledge from the failure (see Step 6, gotcha category)

## Step 5: Review (MANDATORY)

1. Update ticket status to `In Review`
2. Run code checks (test, lint, typecheck, build)
3. On failure, assess severity:
   - Test/lint fixes only → fix and re-run
   - Reveals plan flaw → trigger Failure Protocol
4. `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval: `npx intent-turso ticket update <id> --status "Done" --complete-all`

## Step 6: Knowledge Extraction

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

{Use format from Content Format by Category}
```

### Create Knowledge

```bash
npx intent-turso knowledge create --stdin << 'EOF'
...knowledge content...
EOF
```

### Steps

1. Review `extractProposals` from Step 5's "Done" response
2. **If ticket was aborted/failed:** always propose at least one gotcha knowledge entry capturing what went wrong
3. `AskUserQuestion`: "Extract this knowledge?" → Accept all | Select items | Skip
4. For accepted items, create using command above

---

## Reference

### Status Values

`Backlog` → `In Progress` → `In Review` → `Done`

Extended: `Blocked` (waiting on external), `Paused` (stopped intentionally), `Abandoned` (aborted, won't resume), `Superseded` (replaced by new ticket)

### Ticket Types

| Type | Inferred From |
|------|---------------|
| `feature` | Add, create, build, implement, new |
| `bugfix` | Fix, bug, error, broken, crash, fail |
| `refactor` | Refactor, restructure, clean up, optimize |
| `docs` | Document, readme, comment, explain |
| `chore` | Update deps, migrate, config, CI/CD |
| `test` | Test, spec, coverage, e2e |

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
| Architecture | 0.85 |
| Pattern | 0.8 |
| Principle | 0.75 |
| Gotcha | 0.85 |

### Content Format by Category

**Architecture:**
```
Component:
{name}

Responsibility:
{what it does}

Interfaces:
{how to interact}
```

**Pattern:**
```
Why:
{rationale}

When:
{conditions to apply}

Pattern:
{the approach}
```

**Truth:**
```
Fact:
{verified fact}

Verified:
{how/where verified}
```

**Principle:**
```
Rule:
{the rule}

Why:
{rationale}

Applies:
{scope}
```

**Gotcha:**
```
Attempted:
{what was tried}

Failed Because:
{root cause — be specific}

Instead:
{what to do instead}

Symptoms:
{how you'd recognize this problem}
```