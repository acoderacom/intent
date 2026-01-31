# Turso Ticket Format

Tickets are stored in Turso database. Use `intent-turso` CLI for all operations.

## Adapter Commands

| Action | Command |
|--------|---------|
| Create | `intent-turso ticket create --stdin` (pipe markdown) |
| Fetch | `intent-turso ticket get <id>` |
| Update | `intent-turso ticket update <id> --status <status>` |
| Comment | `intent-turso ticket update <id> --comment '<text>'` |
| List | `intent-turso ticket list [--status <status>]` |

## Creating Tickets

Pipe the ticket markdown directly via heredoc:

```bash
intent-turso ticket create --stdin << 'EOF'
# [INT-YYYYMMDD-slug] Title

**Status:** Backlog

**Intent:** what user wants

**Context:** relevant files, patterns

**Constraints:** Use: [list] | Avoid: [list]

**Assumptions:** AI guesses to validate

**Tasks**
- [ ] Task 1
- [ ] Task 2

**Definition of Done**
- [ ] Criterion 1
- [ ] Criterion 2

**Change Class:** A - reason
EOF
```

## Status Values

- `Backlog` (default on create)
- `In Progress`
- `In Review`
- `Done`

## Updating Tickets

```bash
# Update status
intent-turso ticket update INT-20260131-slug --status "In Progress"

# Add comment
intent-turso ticket update INT-20260131-slug --comment "Started implementation"

# Mark task complete (0-based index)
intent-turso ticket update INT-20260131-slug --complete-task 0
```

## Knowledge Extraction (Step 6)

After ticket is Done, extract learnings:

1. `intent-turso extract {ticket-id}` → returns proposals
2. `AskUserQuestion`: "Extract knowledge?" → Accept all | Select | Skip
3. For accepted: `intent-turso knowledge create ...`

### Create Knowledge

Pipe markdown via heredoc:

```bash
intent-turso knowledge create --stdin << 'EOF'
# Pattern Title

**Namespace:** project-name
**Category:** pattern
**Origin Type:** discovery
**Confidence:** 0.8
**Scope:** new-only
**Tags:** tag1, tag2

## Content

Why:
[Rationale]

When:
[Conditions]

Pattern:
[The approach]
EOF
```

### Update Knowledge

```bash
intent-turso knowledge update <id> \
  --content "..." \
  --scope new-only \
  --tags tag1 tag2
```

### Structured Content Format

Content MUST use explicit sections (machine-readable):

**Pattern:**
```
Why:
[Rationale for this pattern]

When:
[Conditions to apply]

Pattern:
[The actual pattern/approach]
```

**Truth:**
```
Fact:
[The validated fact]

Verified:
[How/when validated]
```

**Principle:**
```
Rule:
[The rule to follow]

Why:
[Rationale]

Applies:
[Scope: new code only, all code, etc.]
```

**Architecture:**
```
Component:
[Component name]

Responsibility:
[What it does]

Interfaces:
[How to interact with it]
```

### Origin Type

| Type | Source | `--origin-type` | `--origin` |
|------|--------|-----------------|------------|
| `ticket` | Extracted from ticket | auto | `INT-xxx` |
| `discovery` | AI explored codebase | `discovery` | - |
| `manual` | User input | `manual` (default) | - |

### Decision Scope

| Scope | Meaning |
|-------|---------|
| `new-only` | Apply to new code only |
| `backward-compatible` | Must not break existing behavior |
| `global` | Applies universally |
| `legacy-frozen` | Do not modify without migration |

### Search Knowledge

```bash
# Semantic search
intent-turso search "how do we handle auth" --limit 5

# Filter by namespace/category
intent-turso search "authentication" --namespace myproject --category principle
```

## Config

Stored in `.intent/.env`:

```env
TURSO_URL="libsql://your-db.turso.io"
TURSO_AUTH_TOKEN="your-token"
```

## CLAUDE.md Config (Turso)

```markdown
## Intent Config
- Task Manager: Turso
- Database: intent-db (libsql://intent-db-org.turso.io)

### Adapter
| Action | Tool |
|--------|------|
| Create | `intent-turso ticket create --stdin` |
| Fetch | `intent-turso ticket get {id}` |
| Update | `intent-turso ticket update {id}` |
| Comment | `intent-turso ticket update {id} --comment '{...}'` |
| List | `intent-turso ticket list` |
| Extract | `intent-turso extract {id}` |
| Search | `intent-turso search "{query}"` |
```
