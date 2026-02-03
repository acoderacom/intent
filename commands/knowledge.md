---
description: Capture knowledge from codebase exploration ("learn how...", "document how...", "how does X work")
---

# Knowledge Discovery

Explore codebase → capture understanding → save as searchable knowledge.

## Prerequisites (BLOCKING)

1. Read `CLAUDE.md` for `## Intent Config`
2. Requires Turso adapter
3. If not configured → `/intent:setup` first

## Step 1: Explore

Use Task tool with `subagent_type=Explore` to understand the topic.

**Parallel exploration:** For complex topics, run multiple Explore agents in parallel (one message, multiple Task calls) - e.g., explore architecture + explore patterns + explore usage.

## Step 2: Capture

### Knowledge Format

```markdown
# {Title}

**Namespace:** {project-namespace}
**Category:** architecture|pattern|truth|principle
**Source:** discovery
**Confidence:** {see Confidence Defaults}
**Scope:** global|new-only
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

1. Preview knowledge using format above
2. `AskUserQuestion`: "Save this knowledge?" → Yes | Edit | Cancel
3. After confirm, create using command above

---

## Reference

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
