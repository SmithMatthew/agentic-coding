# Claude Code Setup

My personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration. Browse and copy whatever is useful to you.

## Files

| File | Description |
|------|-------------|
| `settings.json` | Claude Code user settings — sets the default model and enables a custom status line |
| `statusline-command.sh` | Shell script that powers the status line, showing the working directory, git branch, model name, and context window usage with color-coded indicators |

## Usage

Copy the files to your Claude Code config directory:

```sh
cp settings.json ~/.claude/settings.json
cp statusline-command.sh ~/.claude/statusline-command.sh
```

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
