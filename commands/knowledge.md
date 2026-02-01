---
description: Capture knowledge from codebase exploration ("learn how...", "document how...", "how does X work")
disable-model-invocation: true
---

# Knowledge Discovery

Explore codebase → capture understanding → save as searchable knowledge.

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. Requires Turso adapter
3. If not configured → `/intent:setup` first

## Step 1: Explore

Use Task tool with `subagent_type=Explore` to understand the topic.

## Step 2: Capture

1. Preview (single output):

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** {architecture|pattern|truth|principle}
**Origin Type:** discovery
**Confidence:** {see table below}
**Scope:** {global|new-only}
**Tags:** {kebab-case, comma-separated}

## Content

{Use format from "Content Format by Category" section}
```

2. `AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel
3. **Wait for confirmation before creating anything**

After confirm:
4. Pipe the previewed markdown to CLI:

```bash
npx intent-turso knowledge create --stdin << 'EOF'
{paste previewed markdown here}
EOF
```

## Content Format by Category

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

## Confidence Defaults

| Category | Default |
|----------|---------|
| Truth | 0.9 |
| Architecture | 0.85 |
| Pattern | 0.8 |
| Principle | 0.75 |
