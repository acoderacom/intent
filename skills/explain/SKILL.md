---
name: explain
description: Explain concepts, patterns, or decisions by searching the knowledge base FIRST. Triggers on "explain...", "why do we...", "how does X work", "what is our approach to...". IMPORTANT - This skill requires searching knowledge before any codebase exploration. If knowledge found, answer from knowledge only.
---

# Explain

Answer questions about concepts, patterns, architecture, or decisions.

## Step 1: Search Knowledge (BLOCKING)

Search knowledge → `npx intent-turso search "<intent>" --limit 5`

Extract key terms from user's question for query.

**Semantic Search:** ≥0.45 relevant, ≥0.55 strong match.

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

{Use format from Content Format by Category}
```

### Create Knowledge

```bash
npx intent-turso knowledge create --stdin << 'EOF'
...knowledge content...
EOF
```

### Steps

1. `AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel
2. If Yes, create using command above

---

## Reference

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