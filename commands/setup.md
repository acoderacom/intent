---
description: Configure Intent for this project
---

# Intent Setup

## Step 1: Check Prerequisites

```bash
npx intent-turso --version
```

If fails → guide user to [install.md](../references/install.md), then return here.

## Step 2: Create `.intent/.env`

```bash
mkdir -p .intent
echo ".intent/.env" >> .gitignore
```

Tell user to create `.intent/.env` manually with their credentials:

```env
TURSO_URL="libsql://your-db.turso.io"
TURSO_AUTH_TOKEN="your-token"
```

**IMPORTANT:** Do NOT ask for credentials in chat. User must create file manually.

## Step 3: Initialize Database

After user confirms `.env` created:

```bash
npx intent-turso init
npx intent-turso ticket list
```

## Step 4: Add Permissions

Check if `.claude/settings.local.json` exists, then add permission:

```json
{
  "permissions": {
    "allow": ["Bash(npx intent-turso *)"]
  }
}
```

## Step 5: Write CLAUDE.md

Append to project's `CLAUDE.md`:

```markdown
## Intent Config
- Task Manager: Turso
- Database: Turso Cloud (configured via `.intent/.env`)

### Adapter
| Action | Command |
|--------|---------|
| Create | `npx intent-turso ticket create --stdin` |
| Fetch | `npx intent-turso ticket get {id}` |
| Update | `npx intent-turso ticket update {id}` |
| Comment | `npx intent-turso ticket update {id} --comment '{...}'` |
| List | `npx intent-turso ticket list` |

### Knowledge Operations
| Action | Command |
|--------|---------|
| Extract | `npx intent-turso extract {ticket-id}` |
| Search | `npx intent-turso search "{query}"` |
```

## Step 6: Confirm

Say: "Intent configured. Use `/intent:ticket` to create tickets."
