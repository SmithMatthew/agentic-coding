# Claude Code Setup

My personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration. Browse and copy whatever is useful to you.

## Files

| File | Description |
|------|-------------|
| `settings.json` | Claude Code user settings — sets the default model, enables a custom status line, and configures hooks for notifications and tab titles |
| `statusline-command.sh` | Shell script that powers the status line, showing the working directory, git branch, model name, and context window usage with color-coded indicators |
| `notify.sh` | Terminal-agnostic notification script — sets the tab title to "NEEDS APPROVAL" and sends a desktop notification if the terminal isn't focused. Supports iTerm2, Terminal.app, VS Code, WezTerm, Ghostty, Alacritty, and Linux via `notify-send` |
| `reset-tab-title.sh` | Restores the tab title saved by `notify.sh` |

## Usage

Run the install script:

```sh
sh install.sh
```

This copies the scripts to `~/.claude/` and merges the hooks and status line config into your existing `settings.json` (backing it up first). Any existing hooks you have are preserved.

Then restart Claude Code. The status line will appear at the bottom of your terminal showing:

- **Directory** — last 3 path components of the working directory
- **Git branch** — in green, when inside a repo
- **Model** — the active model name in orange
- **Context usage** — percentage used, color-coded green/orange/red

## Requirements

The statusline script uses `jq` to parse the JSON input from Claude Code. Install it if you don't have it:

```sh
# macOS
brew install jq
```
