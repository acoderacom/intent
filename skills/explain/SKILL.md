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

`AskUserQuestion`: "Save as knowledge?" → Yes | Skip

```bash
npx intent-turso knowledge create --stdin << 'EOF'
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle
**Source:** discovery
**Confidence:** 0.75
**Scope:** global
**Tags:** {relevant-tags}

## Content

{formatted content}
EOF
```
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
