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

Read `CLAUDE.md`. Search knowledge → `npx intent-turso search "<intent>" --limit 3`

Use `--ticket-type` filter when intent matches a specific type.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**Do NOT explore codebase yet** - knowledge informs exploration strategy in Step 3.

**Quick mode check:** If intent is simple (single file, obvious fix, low risk) → suggest `/ticket-quick` instead.

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. Focus on purpose, constraints, definition of done. For multiple approaches lead with recommended option, explain trade-offs in descriptions.

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

**Tasks**
- [ ] Task 1 description
- [ ] Task 2 description

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

### Create Ticket

```bash
npx intent-turso ticket create --stdin << 'EOF'
# [INT-YYYYMMDD-HHMMSS] {intent summary}
**Status:** Backlog
...full ticket content including ## Plan section...
EOF
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
2. For each task: `TaskUpdate` → `in_progress` → implement → `completed`
3. Use `TaskList` for next task

## Step 5: Review (MANDATORY)

1. Update ticket status to `In Review`
2. Run code checks (test, lint, typecheck, build)
3. Fix failures → re-run
4. `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval: `npx intent-turso ticket update <id> --status "Done" --complete-all`

## Step 6: Knowledge Extraction

### Knowledge Format

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle
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
2. `AskUserQuestion`: "Extract this knowledge?" → Accept all | Select items | Skip
3. For accepted items, create using command above

## Step 7: Capture Patterns to CLAUDE.md

Ask: "Any patterns to add to CLAUDE.md?"

---

## Reference

### Commands

| Action | Command |
|--------|---------|
| Create | `npx intent-turso ticket create --stdin` (heredoc) |
| Fetch | `npx intent-turso ticket get <id>` |
| Update status | `npx intent-turso ticket update <id> --status <status>` |
| Update plan | `npx intent-turso ticket update <id> --plan-stdin` (heredoc) |
| Complete all | `npx intent-turso ticket update <id> --status "Done" --complete-all` |
| Complete selective | `npx intent-turso ticket update <id> --complete-task 0,1 --complete-dod 0,2` |
| Comment | `npx intent-turso ticket update <id> --comment '<text>'` |
| List | `npx intent-turso ticket list [--status <status>]` |
| Delete | `npx intent-turso ticket delete <id>` |
| Search | `npx intent-turso search "<query>" --limit 5 [--ticket-type <type>]` |
| Extract | `npx intent-turso extract <ticket-id>` |
| Recalculate confidence | `npx intent-turso knowledge recalculate [--dry-run]` |

### Status Values

`Backlog` → `In Progress` → `In Review` → `Done`

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
| A | Single file, tests, docs | Auto |
| B | Cross-module, APIs, deps | Propose |
| C | Schema, auth, payments | Approval |

### Confidence Defaults

| Category | Default |
|----------|---------|
| Truth | 0.9 |
| Architecture | 0.85 |
| Pattern | 0.8 |
| Principle | 0.75 |

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
