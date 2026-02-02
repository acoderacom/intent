---
description: Configure Intent for this project
---

# Intent Setup

## Step 1: Check Prerequisites

```bash
npx intent-turso --version
```

If fails → guide user to [install.md](../references/install.md), then return here.

## Step 2: Choose Database Mode

`AskUserQuestion`: "Where to store Intent data?"
- **Local (Recommended)** → SQLite file in `.intent/local.db`, no account needed
- **Cloud** → Turso Cloud, requires account and credentials

## Step 3: Create Config

```bash
mkdir -p .intent
```

Add to `.gitignore`:
```bash
echo ".intent/.env" >> .gitignore
echo ".intent/*.db" >> .gitignore
```

### If Local:

Create `.intent/.env` automatically:
```bash
npx intent-turso init --url "file:.intent/local.db"
```

### If Cloud:

Tell user to create `.intent/.env` manually with their credentials:

```env
TURSO_URL="libsql://your-db.turso.io"
TURSO_AUTH_TOKEN="your-token"
```

**IMPORTANT:** Do NOT ask for credentials in chat. User must create file manually.

After user confirms `.env` created:
```bash
npx intent-turso init
```

## Step 4: Verify

```bash
npx intent-turso ticket list
```

## Step 5: Add Permissions

Check if `.claude/settings.local.json` exists, then add permission:

```json
{
  "permissions": {
    "allow": ["Bash(npx intent-turso *)"]
  }
}
```

## Step 6: Write CLAUDE.md

Append to project's `CLAUDE.md`:

### If Local:
```markdown
## Intent Config
- Task Manager: Turso
- Database: Local SQLite (`.intent/local.db`)
```

### If Cloud:
```markdown
## Intent Config
- Task Manager: Turso
- Database: Turso Cloud (configured via `.intent/.env`)
```

### Both modes - add adapter:
```markdown
### Adapter
| Action | Command |
|--------|---------|
| Create | `npx intent-turso ticket create --stdin` (heredoc) |
| Fetch | `npx intent-turso ticket get <id>` |
| Update status | `npx intent-turso ticket update <id> --status <status>` |
| Update plan | `npx intent-turso ticket update <id> --plan-stdin` (heredoc) |
| Complete all | `npx intent-turso ticket update <id> --status "Done" --complete-all` |
| Complete selective | `npx intent-turso ticket update <id> --complete-task 0,1 --complete-dod 0,2` |
| Comment | `npx intent-turso ticket update <id> --comment '<text>'` |
| List | `npx intent-turso ticket list [--status <status>]` |

### Knowledge Operations
| Action | Command |
|--------|---------|
| Search | `npx intent-turso search "<query>" --limit 5 [--ticket-type <type>]` |
| Extract | `npx intent-turso extract <ticket-id>` |
| Recalculate confidence | `npx intent-turso knowledge recalculate [--dry-run]` |
```

## Step 7: Confirm

Say: "Intent configured. Use `/intent:new` to create tickets."
