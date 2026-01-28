# IFD For Claude Code

Intent-First Development for Claude Code. Turn user intent into validated tickets, then execute.

## Philosophy

**Capture before code.** Most AI coding failures happen because of misalignment - the AI builds the wrong thing. IFD fixes this by making alignment explicit before any code is written.

The ticket format is designed to surface misalignment early:

| Field | Purpose |
|-------|---------|
| **Intent** | What user wants, not how to build it |
| **Context** | Ground the work in project reality |
| **Constraints** | Boundaries: use this, avoid that |
| **Assumptions** | AI's guesses - the alignment check |
| **Tasks** | Concrete steps, reviewable before execution |
| **Definition of Done** | Know when you're done, not when AI thinks you're done |
| **Change Class** | Risk level determines review depth |

The **Assumptions** field is the key innovation. Instead of AI silently making decisions, it surfaces guesses for human validation. Catch the "I thought you meant..." moment *before* code exists.

**AI executes. Human reviews.** Not full autonomy. Collaboration with clear checkpoints.

## What It Does

Instead of jumping straight into code, Intent captures what you want to build as a ticket first:

1. **Clarify** - Ask focused questions to understand requirements
2. **Capture** - Create a validated ticket with tasks and done criteria
3. **Plan** - Surface decisions, defaults, and irreversible changes
4. **Execute** - Work through tasks systematically
5. **Review** - Run checks, get approval, mark done

## Install

```bash
claude plugin add /path/to/intent
```

## Setup

```bash
/intent:setup
```

Choose your task manager:
- **Local** - Markdown files in `.intent/tickets/`
- **Linear** - Requires Linear MCP server
- **GitHub** - Uses `gh` CLI
- **Jira** - Requires Jira MCP server
- **Asana** - Requires Asana MCP server

## Usage

Express intent naturally:

```
I want to add dark mode
```

Or invoke directly:

```
/intent:new add user authentication
```

### Options When Creating Tickets

| Option | What Happens |
|--------|--------------|
| Yes, continue | Create ticket → Plan → Execute → Review |
| Just create ticket | Create ticket → Stop (backlog it) |
| No, let me clarify | Revise before creating |

## Ticket Format (Local)

```
.intent/tickets/INT-20260128-add-dark-mode.md
```

## Change Classes

| Class | Examples | Action |
|-------|----------|--------|
| A | Single file, tests, docs | Auto-execute |
| B | Cross-module, APIs, deps | Propose first |
| C | Schema, auth, payments | Explicit approval |

## Derived From

[superpowers](https://github.com/obra/superpowers) by Jesse Vincent

## License

MIT - See [LICENSE](LICENSE)
