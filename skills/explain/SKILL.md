---
name: explain
description: Explain concepts, patterns, or decisions by searching knowledge FIRST. Triggers on "explain...", "why do we...", "how does X work", "what is our approach to...". Search knowledge before any codebase exploration. If knowledge found, answer from knowledge only.
---

# Explain

Answer questions about concepts, patterns, architecture, or decisions.

## Step 1: Search Knowledge (BLOCKING)

```bash
npx intent-turso search "<intent>" --limit 5
```

Extract key terms from user's question for query.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong. Don't discard low scores.

## Step 2: Answer

**Knowledge found (score ≥0.45):**

Synthesize explanation from knowledge. Cite: "Based on [title]...". Include code locations if mentioned.

**No codebase exploration.** Knowledge is the authoritative answer. STOP here.

---

**No knowledge found (all scores <0.45):**

Explore codebase to answer. After answering, offer to capture as knowledge.

## Step 3: Capture (after exploration only)

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

1. `AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel
2. If Yes:
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