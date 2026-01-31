# Intent Plugin

## Intent Config
- Task Manager: Local
- Path: .intent/tickets/

### Adapter
| Action | Tool |
|--------|------|
| Create | Write `.intent/tickets/[id].md` |
| Fetch | Read file |
| Update | Edit file |
| Comment | Append to file |
| List | Glob `.intent/tickets/*.md` |
