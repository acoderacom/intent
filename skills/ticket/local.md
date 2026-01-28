# Local Ticket Format

Folder `.intent/tickets/` exists from setup. Just write the file.

File: `.intent/tickets/INT-YYYYMMDD-{slug}.md`

Example: `INT-20260128-add-dark-mode.md`

```markdown
# [INT-YYYYMMDD-{slug}] {intent summary}

**Status:** Backlog

**Intent:** [what user wants]

**Context:** [relevant files, patterns]

**Constraints:** Use: [list] | Avoid: [list]

**Assumptions:** [AI's guesses - surfaces misalignment]

**Tasks**
- [ ] Task 1 description
- [ ] Task 2 description

**Definition of Done**
- [ ] Criterion 1
- [ ] Criterion 2

**Change Class:** A|B|C - [reason]
```

## Status Updates

Use `Read(.intent/tickets/{id}.md)` then `Edit`:
- Status: `**Status:** Backlog` → `**Status:** In Progress` → `**Status:** In Review` → `**Status:** Done`
- Tasks/DoD: `- [ ]` → `- [x]`
