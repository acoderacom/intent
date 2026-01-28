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
