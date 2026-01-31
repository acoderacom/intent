---
description: Capture knowledge from codebase exploration ("learn how...", "document how...", "how does X work")
disable-model-invocation: true
---

# Knowledge Discovery

Explore codebase → extract understanding → save as knowledge.

## Prerequisites

1. Read `CLAUDE.md` for `## Intent Config`
2. Requires Turso adapter

## Step 1: Explore

Use Glob, Grep, Read to understand the topic. Identify:
- How it works
- Key files/components
- Interfaces

## Step 2: Preview

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** {architecture|pattern|truth|principle}
**Origin Type:** discovery
**Confidence:** {see table below}
**Scope:** {global|new-only}
**Tags:** {kebab-case tags}

## Content

{Structured content - see turso.md for format by category}
```

`AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel

## Step 3: Save

```bash
intent-turso knowledge create --stdin << 'EOF'
{previewed markdown}
EOF
```

## Content Format

See `turso.md` → Structured Content Format section.

## Confidence

| Category | Default |
|----------|---------|
| Truth | 0.9 |
| Architecture | 0.85 |
| Pattern | 0.8 |
| Principle | 0.75 |
