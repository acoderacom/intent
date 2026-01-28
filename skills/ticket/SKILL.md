---
name: ticket
description: Use when user expresses intent to add, build, implement, or change something ("I want to...", "We need...", "Add/Build/Create..."), describes a feature, references a ticket ID, or says "create/implement ticket". Covers creating features, building components, adding functionality, or modifying behavior.
---

# Intent-First Development

Turn user intent into validated tickets, AI execute - Human review.

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. If missing → invoke `/intent:setup`, then continue to Step 1
3. **No config = no proceed**

## Step 1: Context

Read `CLAUDE.md`, check project state. Use context for informed questions.

## Step 2: Clarify

Use `AskUserQuestion` - one question at a time, 2-4 options each. Focus on purpose, constraints, definition of done. For multiple approaches lead with recommended option, explain trade-offs in descriptions.

Stop if: unclear after 2 questions, or needs explicit trade-off choice.

## Step 3: Capture

1. Preview ticket using format from `local.md` (Local) or `online.md` (Online)
2. Use `AskUserQuestion`: "Create this ticket?" → Yes, continue | Just create ticket | No, let me clarify
3. **Wait for confirmation before creating anything**

After confirm:
4. Create ticket via adapter
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

1. Update ticket via adapter Update tool:
- Set `**Status:** In Review`
2. Run code checks (test, lint, typecheck, build)
3. Fix failures → re-run
4. Use `AskUserQuestion`: "Implementation complete. Please review." → Approve | Request changes
5. After approval → Update ticket: `**Status:** Done`
- Mark all tasks as `- [x]`
- Mark all DoD as `- [x]` 
6. Ask: "Any patterns to add to CLAUDE.md?" 

## Change Classes

| Class | Examples | Action |
|-------|----------|--------|
| A | Single file, tests, docs | Auto |
| B | Cross-module, APIs, deps | Propose |
| C | Schema, auth, payments | Approval |
