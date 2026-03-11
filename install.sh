#!/bin/sh
set -e

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
STATUSLINE_SCRIPT="$CLAUDE_DIR/statusline-command.sh"
NOTIFY_SCRIPT="$CLAUDE_DIR/notify.sh"
RESET_TAB_SCRIPT="$CLAUDE_DIR/reset-tab-title.sh"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check for jq
if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required but not installed."
  echo "Install it with: brew install jq"
  exit 1
fi

# Ensure ~/.claude directory exists
mkdir -p "$CLAUDE_DIR"

# Copy scripts
cp "$SCRIPT_DIR/statusline-command.sh" "$STATUSLINE_SCRIPT"
echo "Copied statusline-command.sh to $STATUSLINE_SCRIPT"
cp "$SCRIPT_DIR/notify.sh" "$NOTIFY_SCRIPT"
echo "Copied notify.sh to $NOTIFY_SCRIPT"
cp "$SCRIPT_DIR/reset-tab-title.sh" "$RESET_TAB_SCRIPT"
echo "Copied reset-tab-title.sh to $RESET_TAB_SCRIPT"

# Extract hooks and statusLine from repo settings, fixing the hardcoded path
REPO_SETTINGS=$(jq '{hooks, statusLine}' "$SCRIPT_DIR/settings.json" \
  | sed "s|/Users/smith/.claude/|$HOME/.claude/|g")

if [ -f "$SETTINGS_FILE" ]; then
  # Back up existing settings
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.bak"
  echo "Backed up existing settings to $SETTINGS_FILE.bak"

  # Merge hooks and statusLine into existing settings
  MERGED=$(jq -s '.[0] * .[1]' "$SETTINGS_FILE" - <<EOF
$REPO_SETTINGS
EOF
  )
  echo "$MERGED" > "$SETTINGS_FILE"
  echo "Merged hooks and statusLine into $SETTINGS_FILE"
else
  # Create new settings file with just hooks and statusLine
  echo "$REPO_SETTINGS" > "$SETTINGS_FILE"
  echo "Created $SETTINGS_FILE"
fi

echo ""
echo "Installation complete! Restart Claude Code to apply changes."
echo ""
echo "Installed:"
echo "  - Status line script: $STATUSLINE_SCRIPT"
echo "  - Notification script: $NOTIFY_SCRIPT"
echo "  - Tab title reset script: $RESET_TAB_SCRIPT"
echo "  - Hooks and status line config: $SETTINGS_FILE"
