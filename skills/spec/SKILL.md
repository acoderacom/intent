---
name: spec
description: Write a spec for big features. Triggers on "spec", "plan feature", "big feature", "break down", "design system". Output is a saved spec — tickets come later via /ticket.
---

# Spec — Big Intent, Captured

Write a comprehensive spec and save it. **No tickets, no execution.** Tickets are created later via `/ticket` using the spec as input.

**When to use:**
- The intent is too big to hold in one ticket
- You need to think before building — scope is unclear, trade-offs exist
- Multiple modules, services, or concerns are involved
- You want to capture the vision and get alignment before any code

**When NOT to use:**
- You already know what to build → `/ticket`
- Single unit of work, even if complex → `/ticket`
- Quick fix, obvious change → `/task`

## Prerequisites (BLOCKING)

Read `CLAUDE.md` for `## Intent Config`. Missing → `/setup` first. **No config = no proceed.**

## Step 1: Context (search only)

```bash
npx intent-turso search "<intent>" --limit 5
```

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**No codebase exploration.** Spec works at the intent level, not the code level.

## Step 2: Clarify

If critical information is missing, ask before writing.

`AskUserQuestion` — one question at a time, 2-4 options each. Lead with recommended option.

Focus on:
- **Scope boundaries** — what's in, what's out
- **Key decisions** — choices that affect the breakdown
- **Target users** — who is this for
- **Constraints** — dependencies, existing systems

Don't over-ask. Capture the big picture — details get resolved per-ticket.

## Step 3: Capture

Review full conversation context. Extract requirements, constraints, preferences. Synthesize into a structured spec. Adapt depth based on available information — not all sections required, include what's relevant.

### Spec Format

```markdown
# [SPEC-YYYYMMDD-HHMMSS] {spec name}

## Summary
[Concise overview (2-3 paragraphs). Core value proposition. Goal statement.]

## Target Users (if relevant)
- [Primary user personas]
- [Key needs and pain points]

## Scope
**In Scope:**
- [ ] Item 1
- [ ] Item 2

**Out of Scope:**
- [ ] Item 1
- [ ] Item 2

## User Stories (if user-facing)
- As a [user], I want to [action], so that [benefit]

## Key Decisions
- decision: [what] | reason: [why]

## Ticket Breakdown

### 1. {ticket title}
- **Type:** feature|bugfix|refactor|docs|chore|test
- **Intent:** [what this ticket accomplishes]
- **Change Class:** A|B|C
- **Dependencies:** none | ticket #N

### 2. {ticket title}
- **Type:** feature|bugfix|refactor|docs|chore|test
- **Intent:** [what this ticket accomplishes]
- **Change Class:** A|B|C
- **Dependencies:** none | ticket #N

## Sequence

{ticket #} → {ticket #} → {ticket #}
                         ↘ {ticket #} (parallel)

**Critical path:** [which tickets block everything]

## Success Criteria
- [What "done" looks like for the whole feature]

## Risks & Mitigations (if applicable)
- risk: [what] | mitigation: [how]

## Future Considerations (if applicable)
- [Post-MVP enhancements]
```

### Save Spec

```bash
npx intent-turso spec create --stdin << 'EOF'
# [SPEC-YYYYMMDD-HHMMSS] {spec name}
...spec fields...
EOF
```

### Steps

1. Output Spec using format above
2. Highlight assumptions made due to missing information
3. `AskUserQuestion`: "Save this spec?"
   - **Save** → save using command above
   - **Revise** → adjust, re-present
4. Confirm saved with ID. Suggest: "Use `/ticket SPEC-YYYYMMDD-HHMMSS` to start creating tickets from this spec."
