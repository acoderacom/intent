---
description: Configure Intent task manager (Linear/GitHub/Jira/Asana/Local)
---

# Intent Setup

## Step 1: Select Task Manager

`AskUserQuestion` → "Which task manager?" → Linear | GitHub Issues | Jira | Asana | Local

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

### GitHub

```
Tool: Bash
Command: gh auth status
```

```
Tool: Bash
Command: gh repo list --limit 10
```

```
Tool: AskUserQuestion
Options: repo names from above
```

### Jira

```
Tool: ToolSearch
Parameter: query = "select:mcp__jira__list_projects"
```

Then call the returned Jira tool, then AskUserQuestion.

Only if tool not found → see [install.md](../references/install.md)

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

## Step 3: Write CLAUDE.md

```markdown
## Intent Config
- Task Manager: {Linear|GitHub|Jira|Asana|Local}
- {Team|Repo|Project|Workspace/Project|Path}: {name} (ID: {id})

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
| GitHub | `gh issue create` | `gh issue view` | `gh issue edit` | `gh issue comment` | `gh issue list` |
| Jira | `mcp__jira__create_issue` | `mcp__jira__get_issue` | `mcp__jira__update_issue` | `mcp__jira__add_comment` | `mcp__jira__search_issues` |
| Asana | `mcp__asana__asana_create_task` | `mcp__asana__asana_get_task` | `mcp__asana__asana_update_task` | `mcp__asana__asana_create_task_story` | `mcp__asana__asana_search_tasks` |
| Local | Write `.intent/tickets/[id].md` | Read file | Edit file | Append to file | Glob `.intent/tickets/*.md` |

## Step 4: Confirm

Say: "Intent configured for {Task Manager}."
