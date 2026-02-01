---
name: ticket
description: Create and execute development tickets. Triggers on "I want...", "Add/Build/Create...", ticket IDs (INT-*), or "create ticket". Covers features, components, and behavior changes.
---

# Intent-First Development

Turn user intent into validated tickets, AI execute - Human review.

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. If missing → `/intent:setup` first
3. **No config = no proceed**

## Step 1: Context

Read `CLAUDE.md`, check project state.

**Turso only**: Search knowledge → `npx intent-turso search "<intent>" --limit 3`
Include relevant knowledge in the ticket's Context field.

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. Focus on purpose, constraints, definition of done. For multiple approaches lead with recommended option, explain trade-offs in descriptions.

Stop if: unclear after 2 questions, or needs explicit trade-off choice.

## Step 3: Capture

### Ticket Format

Title: `[INT-YYYYMMDD-HHMMSS] {intent summary}`

Body:
```markdown
**Status:** Backlog

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

### How to Save

| Adapter | Method |
|---------|--------|
| Linear | `mcp__linear__create_issue` with title + body |
| Turso | `npx intent-turso ticket create --stdin << 'EOF'` with `# Title` + body |

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

1. Fetch ticket, `EnterPlanMode`
2. Build plan from ticket structure:
   - **Files:** List files to modify
   - **Tasks → Steps:** For EACH ticket task, add implementation steps
   - **DoD → Verification:** For EACH ticket DoD, specify how to verify
   - **Decisions:** Choices made (what + why), defaults assumed, irreversible actions
3. By class: A = auto | B = propose | C = explicit approval
4. After approval, save plan (Turso):
   ```bash
   npx intent-turso ticket update <id> --plan-stdin << 'EOF'
   **Files:** file1.ts, file2.ts

   **Tasks → Steps:**
   - task: Implement API endpoint
     - Create route handler
     - Add validation
   - task: Add unit tests
     - Test success case
     - Test error handling

   **DoD → Verification:**
   - dod: API returns correct data | verify: Run integration tests
   - dod: No TypeScript errors | verify: npx tsc --noEmit

   **Decisions:**
   - choice: Use cursor pagination | reason: Better for large datasets
   EOF
   ```
6. `ExitPlanMode`

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
5. After approval (one command):
   - Turso: `npx intent-turso ticket update <id> --status "Done" --complete-all`
   - Linear: `mcp__linear__update_issue` with state + update description checkboxes

## Step 7: Knowledge Extraction (Turso only)

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
**Origin Type:** ticket|discovery|manual
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

## Reference: Adapter Commands

### Linear

| Action | Tool |
|--------|------|
| Create | `mcp__linear__create_issue` |
| Fetch | `mcp__linear__get_issue` |
| Update | `mcp__linear__update_issue` |
| Comment | `mcp__linear__create_comment` |
| List | `mcp__linear__list_issues` |

### Turso

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
| Search | `npx intent-turso search "<query>" --limit 5` |
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
