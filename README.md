# Claude Code Configuration

Specialized agents and MCP integrations for enhanced development workflows.

## Project Structure

```
.claude/
├── agents/          # Specialized academic and writing assistants
│   ├── academic-search.md
│   ├── academic-writing.md
│   ├── blog-writing.md
│   ├── paper-research.md
│   └── weekly-report-writing.md
├── commands/        # Research and development tools
│   ├── find-paper.md
│   ├── search-papers.md
│   ├── weekly-report.md
│   └── wpaper.md
└── settings.json    # Claude Code configuration
```

## Specialized Agents

| Agent                    | Function               | Purpose                                           |
| ------------------------ | ---------------------- | ------------------------------------------------- |
| `/academic-search`       | Multi-platform search  | Comprehensive paper discovery across databases    |
| `/academic-writing`      | Academic standards     | Publication-ready prose with rigorous conventions |
| `/blog-writing`          | Content enhancement    | Blog readability, structure, technical tutorials  |
| `/paper-research`        | Systematic research    | Literature review with quality verification       |
| `/weekly-report-writing` | Progress documentation | Professional reports with academic language       |

## Research Commands

| Command          | Function          | Purpose                                      |
| ---------------- | ----------------- | -------------------------------------------- |
| `/search-papers` | Academic search   | Multi-platform paper discovery and metadata  |
| `/find-paper`    | Paper retrieval   | Targeted academic paper location             |
| `/wpaper`        | Academic writing  | Rigorous standards, methodology descriptions |
| `/weekly-report` | Progress tracking | Weekly summary generation                    |

## MCP Servers

| Server       | Type  | Command             | Purpose                                               | Repository                                              |
| ------------ | ----- | ------------------- | ----------------------------------------------------- | ------------------------------------------------------- |
| `all-in-mcp` | stdio | `uv run all-in-mcp` | Academic paper search, PDF processing, research tools | [GitHub](https://github.com/jiahaoxiang2000/all-in-mcp) |

## settings.json

The settings.json detail see https://docs.anthropic.com/en/docs/claude-code/settings.
