---
name: ticket-quick
description: Quick execution mode for confident, low-risk changes. Triggers on "quick fix", "just do it", "simple change", or explicit "/ticket-quick". Skips ceremony, preserves knowledge.
---

# Quick Mode

Skip ceremony, preserve knowledge. For confident, low-risk changes.

**When to use:** Simple fixes, obvious changes, user is confident.
**When NOT to use:** Complex features, unclear requirements, Class B/C changes → switch to `/ticket`.

## Step 1: Context (search only)

Search knowledge → `npx intent-turso search "<intent>" --limit 3`

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

**Do NOT explore codebase yet** - knowledge informs exploration in Step 2.

## Step 2: Execute

### Steps

1. **NOW explore codebase** (knowledge found → start from patterns/files, else broad)
2. Implement directly - no ticket, no task tracking
3. Run checks (test, lint, typecheck)
4. Fix failures → re-run

**Complexity check:** If unclear or risky → "This seems complex, switch to /ticket?"

## Step 3: Knowledge (optional)

### Knowledge Format

```markdown
# Knowledge Title

**Namespace:** project-name
**Category:** pattern|truth|principle
**Source:** discovery
**Confidence:** 0.7
**Scope:** new-only
**Tags:** quick-fix

## Content

Why:
[Rationale]

When:
[Conditions]

Pattern:
[The approach]
```

### Create Knowledge

```bash
npx intent-turso knowledge create --stdin << 'EOF'
...knowledge content...
EOF
```

### Steps

1. `AskUserQuestion`: "Quick fix done. Extract knowledge?" → Yes | Skip
2. If Yes, create using command above

---

## Reference

### Commands

| Action | Command |
|--------|---------|
| Search | `npx intent-turso search "<query>" --limit 5` |
| Create knowledge | `npx intent-turso knowledge create --stdin` |

### Quick vs Standard

| Aspect | Quick | Standard |
|--------|-------|----------|
| Knowledge search | ✓ | ✓ |
| Clarify questions | ✗ | ✓ |
| Ticket creation | ✗ | ✓ |
| Task tracking | ✗ | ✓ |
| Plan approval | ✗ | ✓ |
| Code checks | ✓ | ✓ |
| Human review | ✗ | ✓ (mandatory) |
| Knowledge extract | ✓ (optional) | ✓ |
