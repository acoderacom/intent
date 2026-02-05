---
name: ticket-quick
description: Quick execution for confident, low-risk changes. Triggers on "quick fix", "just do it", "simple change", or "/ticket-quick". Skips ceremony, preserves knowledge.
---

# Quick Mode

Skip ceremony, preserve knowledge. For confident, low-risk changes.

**When to use:** Simple fixes, obvious changes, Class A only.
**When NOT to use:** Complex features, unclear requirements, Class B/C → `/ticket`.

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

## Step 3: Knowledge (optional)

### Knowledge Format

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle|gotcha
**Source:** discovery
**Confidence:** {see Confidence Defaults}
**Scope:** new-only|global|backward-compatible|legacy-frozen
**Tags:** {kebab-case, comma-separated}

## Content

{Use Content Formats from Reference}
```

### Steps

1. `AskUserQuestion`: "Quick fix done. Extract knowledge?" → Yes | Skip
2. If Yes:
   ```bash
   npx intent-turso knowledge create --stdin << 'EOF'
   ...knowledge content...
   EOF
   ```

---

## Reference

### Quick vs Standard

| Aspect | Quick | Standard |
|--------|-------|----------|
| Knowledge search | ✓ | ✓ |
| Clarify questions | ✗ | ✓ |
| Ticket/task tracking | ✗ | ✓ |
| Plan approval | ✗ | ✓ |
| Code checks | ✓ | ✓ |
| Human review | ✗ | ✓ (mandatory) |
| Knowledge extract | optional | ✓ |

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