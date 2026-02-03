# Intent Plugin

## Intent Config
- Task Manager: Turso
- Database: Local SQLite (`.intent/local.db`)

### Setup Commands
| Command | Description |
|---------|-------------|
| `npx intent-turso init` | Create database tables |
| `npx intent-turso status` | Check Turso connection |
| `npx intent-turso ui` | Start web UI |

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
| Delete | `npx intent-turso ticket delete <id>` |

### Knowledge Operations
| Action | Command |
|--------|---------|
| Search | `npx intent-turso search "<query>" [--limit N] [--namespace] [--category] [--ticket-type] [--tags] [--min-score]` |
| Extract | `npx intent-turso extract <ticket-id>` |
| Create | `npx intent-turso knowledge create --stdin` (heredoc) |
| Get | `npx intent-turso knowledge get <id>` |
| List | `npx intent-turso knowledge list [--namespace] [--category] [--scope] [--source] [--status active\|inactive\|all]` |
| Update | `npx intent-turso knowledge update <id> [--title] [--content] [--category] [--tags] [--scope] [--confidence]` |
| Deactivate | `npx intent-turso knowledge deactivate <id>` |
| Recalculate | `npx intent-turso knowledge recalculate [--dry-run]` |
