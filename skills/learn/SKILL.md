---
name: learn
description: Capture knowledge from codebase exploration. Triggers on "learn how...", "document how...", "how does X work".
---

# Learn

Explore codebase → capture understanding → save as searchable knowledge.
## Step 1: Explore

Use Task tool with `subagent_type=Explore` to understand the topic.

**Parallel exploration:** For complex topics, run multiple Explore agents in parallel (one message, multiple Task calls) — e.g., explore architecture + explore patterns + explore usage.

## Step 2: Compound

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

1. Preview knowledge using format above
2. `AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel
3. If Yes:
   ```bash
   npx intent-turso knowledge create --stdin << 'EOF'
   ...knowledge content...
   EOF
   ```

---

## Reference

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