# Claude Code Configuration

Specialized agents and MCP integrations for enhanced development workflows.

## Project Structure

```
.claude/
├── agents/          # Specialized writing assistants
│   ├── blog-writing.md
│   └── commit-push.md
├── commands/        # Research and development tools
│   ├── crypto-research.md
│   ├── find-paper.md
│   ├── search-papers.md
│   ├── weekly-report.md
│   └── wpaper.md
└── settings.json    # Claude Code configuration
```

## Specialized Agents

| Agent           | Function            | Purpose                                          |
| --------------- | ------------------- | ------------------------------------------------ |
| `/blog-writing` | Content enhancement | Blog readability, structure, technical tutorials |
| `/commit-push`  | Git automation      | Conventional commits, changelog management       |

## Research Commands

| Command            | Function              | Purpose                                           |
| ------------------ | --------------------- | ------------------------------------------------- |
| `/crypto-research` | Cryptography research | IACR integration, trend analysis, paper discovery |
| `/search-papers`   | Academic search       | Multi-platform paper discovery and metadata       |
| `/find-paper`      | Paper retrieval       | Targeted academic paper location                  |
| `/wpaper`          | Academic writing      | Rigorous standards, methodology descriptions      |
| `/weekly-report`   | Progress tracking     | Weekly summary generation                         |

## MCP Servers

| Server            | Type  | Command               | Purpose                                               | Repository                                              |
| ----------------- | ----- | --------------------- | ----------------------------------------------------- | ------------------------------------------------------- |
| `all-in-mcp`      | stdio | `uv run all-in-mcp`   | Academic paper search, PDF processing, research tools | [GitHub](https://github.com/jiahaoxiang2000/all-in-mcp) |
| `github-repo-mcp` | stdio | `npx github-repo-mcp` | GitHub repository integration and management          | [GitHub](https://github.com/Ryan0204/github-repo-mcp)   |

## settings.json

The settings.json detail see https://docs.anthropic.com/en/docs/claude-code/settings.
