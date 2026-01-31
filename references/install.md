# MCP Install Guides

Show only when MCP tool call fails with "tool not found".

## Linear

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": {
        "LINEAR_API_KEY": "<key>"
      }
    }
  }
}
```

Get key: Linear → Settings → API → Personal API keys

Restart Claude Code after adding.

## Asana

Run this command:

```bash
claude mcp add --transport sse asana https://mcp.asana.com/sse
```

This uses Asana's hosted MCP server with OAuth authentication. You'll be prompted to authorize when first using Asana tools.

Restart Claude Code after adding.

## Turso

### 1. Install CLI

```bash
npm install -g intent-turso
```

Or use via npx: `npx intent-turso --version`

### 2. Get Credentials

**Option A: Turso Dashboard**
1. Create database at https://turso.tech (free tier)
2. Copy URL and create auth token from dashboard

**Option B: Turso CLI**
```bash
curl -sSfL https://get.tur.so/install.sh | bash
turso auth login
turso db create intent-db
turso db show intent-db --url        # Copy this
turso db tokens create intent-db     # Copy this
```

### 3. Create `.intent/.env`

```bash
mkdir -p .intent
```

Create `.intent/.env` manually (do NOT paste credentials in AI chat):

```env
TURSO_URL="libsql://your-db.turso.io"
TURSO_AUTH_TOKEN="your-token"
```

### 4. Initialize Database

```bash
intent-turso init
```

Creates tables if they don't exist.

### 5. Verify

```bash
intent-turso ticket list
```

**Security:** Add `.intent/.env` to `.gitignore`
