---
description: Configure Intent task manager (Linear/Asana/Local/Turso)
---

# Intent Setup

## Step 1: Select Task Manager

Use `AskUserQuestion` with EXACTLY these 4 options (do NOT omit any):

```
Question: "Which task manager?"
Options:
1. Linear
2. Asana
3. Local (file-based)
4. Turso (Cloud + Knowledge)
```

## Step 2: Load & Fetch

### Linear

Execute these exact tool calls in order:

```
Tool: ToolSearch
Parameter: query = "select:mcp__linear__list_teams"
```

```
Tool: mcp__linear__list_teams
Parameters: (none)
Result: {teams: [{id, name}, ...]}
```

```
Tool: AskUserQuestion
Options: team names from above result
```

Only if mcp__linear__list_teams not found → see [install.md](../references/install.md)

### Asana

```
Tool: ToolSearch
Parameter: query = "select:mcp__asana__asana_list_workspaces"
```

```
Tool: mcp__asana__asana_list_workspaces
Parameters: (none)
Result: {workspaces: [{gid, name}, ...]}
```

```
Tool: AskUserQuestion
Options: workspace names from above result
```

Then ask for project:

```
Tool: mcp__asana__asana_search_projects
Parameters: workspace = {selected_workspace_gid}
```

```
Tool: AskUserQuestion
Options: project names from above result
```

Only if mcp__asana__asana_list_workspaces not found → see [install.md](../references/install.md)

### Local

Create folder: `mkdir -p .intent/tickets`

### Turso

1. Check CLI: `npx intent-turso --version`
2. If not installed → see [install.md](../references/install.md)
3. Guide user to create `.intent/.env` (do NOT ask for credentials in chat):

```
mkdir -p .intent
echo "Create .intent/.env with:
TURSO_URL=\"libsql://your-db.turso.io\"
TURSO_AUTH_TOKEN=\"your-token\"

Get credentials: https://turso.tech or turso CLI"
```

4. After user confirms `.env` created:
   - Create tables: `npx intent-turso init`
   - Verify: `npx intent-turso ticket list`
5. Add permission to `.claude/settings.local.json`:
   ```json
   {
     "permissions": {
       "allow": ["Bash(npx intent-turso:*)"]
     }
   }
   ```

## Step 3: Write CLAUDE.md

```markdown
## Intent Config
- Task Manager: {Linear|Asana|Local|Turso}
- {Team|Workspace/Project|Path|Database}: {name} (ID: {id})

### Adapter
| Action | Tool |
|--------|------|
| Create | {tool} |
| Fetch | {tool} |
| Update | {tool} |
| Comment | {tool} |
| List | {tool} |
```

### Adapter Tool Mappings

| Manager | Create | Fetch | Update | Comment | List |
|---------|--------|-------|--------|---------|------|
| Linear | `mcp__linear__create_issue` | `mcp__linear__get_issue` | `mcp__linear__update_issue` | `mcp__linear__create_comment` | `mcp__linear__list_issues` |
| Asana | `mcp__asana__asana_create_task` | `mcp__asana__asana_get_task` | `mcp__asana__asana_update_task` | `mcp__asana__asana_create_task_story` | `mcp__asana__asana_search_tasks` |
| Local | Write `.intent/tickets/[id].md` | Read file | Edit file | Append to file | Glob `.intent/tickets/*.md` |
| Turso | `intent-turso ticket create --stdin` | `intent-turso ticket get {id}` | `intent-turso ticket update {id}` | `intent-turso ticket update {id} --comment '{...}'` | `intent-turso ticket list` |

### Turso Knowledge Operations (Additional)

| Action | Tool |
|--------|------|
| Extract | `intent-turso extract {ticket-id}` |
| Search | `intent-turso search "{query}"` |

## Step 4: Confirm

Say: "Intent configured for {Task Manager}."
