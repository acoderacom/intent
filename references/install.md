# MCP Install Guides

Show only when MCP tool call fails with "tool not found".

## GitHub

GitHub CLI (`gh`) is typically pre-installed. Verify:
```bash
gh auth status
```

If not installed: https://cli.github.com/

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

## Jira

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-jira"],
      "env": {
        "JIRA_HOST": "https://company.atlassian.net",
        "JIRA_EMAIL": "<email>",
        "JIRA_API_TOKEN": "<token>"
      }
    }
  }
}
```

Get token: Atlassian Account → Security → API tokens

Restart Claude Code after adding.

## Asana

Run this command:

```bash
claude mcp add --transport sse asana https://mcp.asana.com/sse
```

This uses Asana's hosted MCP server with OAuth authentication. You'll be prompted to authorize when first using Asana tools.

Restart Claude Code after adding.

## Turso

Install the intent-turso CLI globally:

```bash
npm install -g intent-turso
```

Or use npx (no install required):

```bash
npx intent-turso --version
```

### Get Turso Credentials

1. Create a database at https://turso.tech (free tier available)
2. Install Turso CLI: `curl -sSfL https://get.tur.so/install.sh | bash`
3. Login: `turso auth login`
4. Create database: `turso db create intent-db`
5. Get URL: `turso db show intent-db --url`
6. Get token: `turso db tokens create intent-db`

### Initialize

```bash
intent-turso init --url "libsql://your-db.turso.io" --token "your-token"
```

This creates `.intent/turso.json` with your credentials.

**Note:** Add `.intent/turso.json` to `.gitignore` to keep credentials secure.

### Environment Variables (Alternative)

Instead of `--url` and `--token`, you can set:

```bash
export TURSO_URL="libsql://your-db.turso.io"
export TURSO_AUTH_TOKEN="your-token"
```
