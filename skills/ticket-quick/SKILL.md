---
name: ticket-quick
description: Quick execution mode for confident, low-risk changes. Triggers on "quick fix", "just do it", "simple change", or explicit "quick ticket". Skips ceremony, preserves knowledge.
---

# Quick Mode

Skip ceremony, preserve knowledge. For confident, low-risk changes.

**When to use:** Simple fixes, obvious changes, user is confident.
**When NOT to use:** Complex features, unclear requirements, Class B/C changes → switch to `/ticket`.

## Step 1: Context (search only)

Search knowledge → `npx intent-turso search "<intent>" --limit 3`

Use `--ticket-type` filter when intent matches a specific type.

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
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle|gotcha
**Source:** discovery
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

1. `AskUserQuestion`: "Quick fix done. Extract knowledge?" → Yes | Skip
2. If Yes, create using command above

---

## Reference

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