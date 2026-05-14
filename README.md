# Claude Code Configuration

Personal Claude Code configuration: slash commands, hooks, keybindings, and global settings.

## Project Structure

```
.claude/
├── commands/             # User-defined slash commands
│   └── commit-message.md
├── hooks/                # Event hook scripts
│   └── claude-attn.sh
├── plugins/              # Installed plugins and marketplaces
├── keybindings.json      # Custom key bindings
├── settings.json         # Claude Code configuration
├── settings.local.json   # Local-only overrides (gitignored)
└── .mcp.json             # MCP server definitions
```

## Slash Commands

| Command           | Purpose                                                          |
| ----------------- | ---------------------------------------------------------------- |
| `/commit-message` | Generate emoji + Conventional Commits messages and commit safely |

## Hooks

`hooks/claude-attn.sh` is wired into multiple events via `settings.json` to surface attention requests via `notify-send` and tmux window markers.

| Event              | Trigger                                           |
| ------------------ | ------------------------------------------------- |
| `Notification`     | Permission prompts (matcher: `permission_prompt`) |
| `Stop`             | Assistant finishes a turn — clears pending marker |
| `StopFailure`      | Assistant turn fails                              |
| `UserPromptSubmit` | User submits a prompt                             |

In tmux, the hook sets a per-window `@claude_pending` option and auto-focuses the pane when it is the only pending window.

## Settings Highlights

- `model`: `opus`
- `theme`: `dark-daltonized`
- `editorMode`: `normal`
- `effortLevel`: `high`
- `autoCompactEnabled`: `false`
- `skipAutoPermissionPrompt`: `true`
- `permissions.defaultMode`: `auto`
- `enableAllProjectMcpServers`: `true`
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

See https://docs.anthropic.com/en/docs/claude-code/settings for the full settings reference.

## MCP Servers

No MCP servers are currently configured in `.mcp.json`. Project-level MCP servers are auto-enabled via `enableAllProjectMcpServers`.
