---
name: ticket
description: Create and execute development tickets. Triggers on "I want...", "Add/Build/Create...", ticket IDs (INT-*), or "create ticket". Covers features, components, and behavior changes.
---

# Intent-First Development

Turn user intent into validated tickets, AI execute - Human review.

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. If missing → `/intent:setup` first
3. Identify adapter: Local (`local.md`), Online (`online.md`), or Turso (`turso.md`)

## Step 1: Context

Read `CLAUDE.md`, check project state.

**Turso only**: Search knowledge → `intent-turso search "<intent>" --limit 3`
Include relevant knowledge in the ticket's Context field.

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. Focus on purpose, constraints, definition of done. For multiple approaches lead with recommended option, explain trade-offs in descriptions.

Stop if: unclear after 2 questions, or needs explicit trade-off choice.

## Step 3: Capture

1. Preview ticket (format per adapter file)
2. Use `AskUserQuestion`: "Create this ticket?" → Yes, continue | Just create ticket | No, let me clarify
3. **Wait for confirmation before creating anything**

After confirm:
4. Create ticket via adapter (for Turso: pipe markdown via `--stdin` heredoc)
5. Create tasks via `TaskCreate`
6. Set dependencies via `TaskUpdate`
7. If "Just create ticket" → stop here

## Step 4: Plan

1. Fetch ticket, `EnterPlanMode`
2. Surface: **Decisions** (choices + why) | **Defaults** (assumed) | **Irreversible** (migrations, deletions)
3. By class: A = auto | B = propose | C = explicit approval
4. Exit when approved

Stop if: Class C or irreversible changes.

## Step 5: Execute

1. Update ticket: `**Status:** In Progress` (use adapter Update tool)
2. For each task: `TaskUpdate` → `in_progress` → implement → `completed`
3. Use `TaskList` for next task

## Step 6: Review (MANDATORY)

1. Set `**Status:** In Review`
2. Run code checks (test, lint, typecheck, build)
3. Fix failures → re-run
4. `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval:
   - Set `**Status:** Done` (Turso: `intent-turso ticket update {id} --status Done`)
   - Mark all tasks `[x]` (Turso: `--complete-task 0`, `--complete-task 1`, ...)
   - Mark all DoD `[x]` (Turso: `--complete-dod 0`, `--complete-dod 1`, ...)

## Step 7: Knowledge Extraction (Turso only)

1. Run `intent-turso extract {ticket-id}`
2. Parse JSON, present proposals to user:
   - `AskUserQuestion`: "Extract this knowledge?" → Accept all | Select items | Skip
3. For accepted items, create with structured content (see `turso.md`):
   - `intent-turso knowledge create --title "..." --content "..." --namespace {ns} --category {cat} --origin {ticket-id}`

## Step 8: Capture Patterns

Ask: "Any patterns to add to CLAUDE.md?" 

## Change Classes

| Class | Examples | Action |
|-------|----------|--------|
| A | Single file, tests, docs | Auto |
| B | Cross-module, APIs, deps | Propose |
| C | Schema, auth, payments | Approval |
