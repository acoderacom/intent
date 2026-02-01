---
name: ticket
description: Create and execute development tickets. Triggers on "I want...", "Add/Build/Create...", ticket IDs (INT-*), or "create ticket". Covers features, components, and behavior changes.
---

# Intent-First Development

Turn user intent into validated tickets, AI execute - Human review.

**Mental Model:** Ticket = Contract (WHAT & WHY) | Plan = Playbook (HOW) | Knowledge = Memory (LEARNED)

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. If missing → `/intent:setup` first
3. **No config = no proceed**

## Step 1: Context

Read `CLAUDE.md`, check project state.

Search knowledge → `npx intent-turso search "<intent>" --limit 3`
Include relevant knowledge in the ticket's Context field.
Use `--ticket-type` filter when intent matches a specific type (e.g., bugfix intent → search bugfix knowledge).

**Semantic Search Notes:**
- Scores in 0.35–0.65 range are useful (relative, not absolute)
- ≥0.45 = relevant | ≥0.55 = strong match
- Do NOT discard results solely due to low absolute score

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. Focus on purpose, constraints, definition of done. For multiple approaches lead with recommended option, explain trade-offs in descriptions.

Stop if: unclear after 2 questions, or needs explicit trade-off choice.

## Step 3: Capture

### Ticket Format

Title: `[INT-YYYYMMDD-HHMMSS] {intent summary}`

Body:
```markdown
**Status:** Backlog

**Type:** feature|bugfix|refactor|docs|chore|test (AI-inferred from intent)

**Intent:** [what user wants]

**Context:** [relevant files, patterns]

**Constraints:** Use: [list] | Avoid: [list]

**Assumptions:** [AI's guesses - surfaces misalignment]

**Tasks**
- [ ] Task 1 description
- [ ] Task 2 description

**Definition of Done**
- [ ] Criterion 1
- [ ] Criterion 2

**Change Class:** A|B|C - [reason]
```

### Ticket Types (AI-inferred)

| Type | Inferred From |
|------|---------------|
| `feature` | Add, create, build, implement, new |
| `bugfix` | Fix, bug, error, broken, crash, fail |
| `refactor` | Refactor, restructure, clean up, optimize |
| `docs` | Document, readme, comment, explain |
| `chore` | Update deps, migrate, config, CI/CD |
| `test` | Test, spec, coverage, e2e |

### How to Save

```bash
npx intent-turso ticket create --stdin << 'EOF'
# [INT-YYYYMMDD-HHMMSS] Title
...body...
EOF
```

### Capture Steps

1. Preview ticket using format above
2. `AskUserQuestion`: "Create this ticket?" → Yes, continue | Just create ticket | No, let me clarify
3. **Wait for confirmation before creating anything**
4. After confirm:
   - Create ticket via adapter
   - Create tasks via `TaskCreate`
   - Set dependencies via `TaskUpdate`
   - If "Just create ticket" → stop here

## Step 4: Plan

### Plan Format

```markdown
**Files to Edit:** file1.ts, file2.ts

**Tasks → Steps:**
- task: [ticket task 1]
  - Implementation step
- task: [ticket task 2]
  - Implementation step

**DoD → Verification:**
- dod: [ticket DoD 1] | verify: How to verify
- dod: [ticket DoD 2] | verify: How to verify

**Decisions:** (implementation-level only, not ticket decisions)
- choice: What | reason: Why

**Trade-offs:** (omit if none)
- considered: [alternative] | rejected: [reason]
- limitation: [what might break at scale]

**Irreversible Actions:** (required for Class C, omit if none for A/B)
- Description of action that can't be undone

**Edge Cases:** (required for Class C, omit if none for A/B)
- Condition that might cause issues
```

### Plan Steps

1. Fetch ticket, `EnterPlanMode`
2. Output plan using format above
3. `AskUserQuestion`: "Approve this plan?" → Yes, continue | Revise | Cancel
4. **Wait for approval before saving**
5. After approval (MANDATORY before ExitPlanMode):
   - **ALWAYS** save plan: `npx intent-turso ticket update <id> --plan-stdin`
   - If "Cancel" → stop here
6. `ExitPlanMode`

By class: A = auto | B = propose | C = explicit approval

Stop if: Class C or irreversible changes.

## Step 5: Execute

1. Update ticket status to `In Progress`
2. For each task: `TaskUpdate` → `in_progress` → implement → `completed`
3. Use `TaskList` for next task

## Step 6: Review (MANDATORY)

1. Set status to `In Review`
2. Run code checks (test, lint, typecheck, build)
3. Fix failures → re-run
4. `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval: `npx intent-turso ticket update <id> --status "Done" --complete-all`

## Step 7: Knowledge Extraction

**Auto-extract:** When status is set to "Done", the update response includes `extractProposals`.

1. Parse `extractProposals` from the update response (no separate command needed)
2. Present proposals to user:
   - `AskUserQuestion`: "Extract this knowledge?" → Accept all | Select items | Skip
3. For accepted items, create via heredoc:

```bash
npx intent-turso knowledge create --stdin << 'EOF'
# Knowledge Title

**Namespace:** project-name
**Category:** pattern|truth|principle|architecture
**Source:** ticket|discovery|manual
**Origin Ticket:** INT-YYYYMMDD-HHMMSS (if source=ticket)
**Origin Ticket Type:** feature|bugfix|refactor|docs|chore|test (if source=ticket)
**Confidence:** 0.8
**Scope:** new-only|global|backward-compatible|legacy-frozen
**Tags:** tag1, tag2

## Content

Why:
[Rationale]

When:
[Conditions]

Pattern:
[The approach]
EOF
```

## Step 8: Capture Patterns to CLAUDE.md

Ask: "Any patterns to add to CLAUDE.md?"

---

## Reference: Commands

| Action | Command |
|--------|---------|
| Create | `npx intent-turso ticket create --stdin` (heredoc) |
| Fetch | `npx intent-turso ticket get <id>` |
| Update status | `npx intent-turso ticket update <id> --status <status>` |
| Save plan | `npx intent-turso ticket update <id> --plan-stdin` (heredoc) |
| Complete all | `npx intent-turso ticket update <id> --status "Done" --complete-all` |
| Complete selective | `npx intent-turso ticket update <id> --complete-task 0,1 --complete-dod 0,2` |
| Comment | `npx intent-turso ticket update <id> --comment '<text>'` |
| List | `npx intent-turso ticket list [--status <status>]` |
| Search | `npx intent-turso search "<query>" --limit 5 [--ticket-type <type>]` |
| Extract | `npx intent-turso extract <ticket-id>` |
| Recalculate confidence | `npx intent-turso knowledge recalculate [--dry-run]` |

### Status Values

`Backlog` → `In Progress` → `In Review` → `Done`

---

## Change Classes

| Class | Examples | Action |
|-------|----------|--------|
| A | Single file, tests, docs | Auto |
| B | Cross-module, APIs, deps | Propose |
| C | Schema, auth, payments | Approval |
