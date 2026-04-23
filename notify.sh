#!/bin/sh
input=$(cat)

# Debounce: if notify.sh was called within the last 2 seconds, exit early
# to prevent double notifications when both PreToolUse and Notification hooks fire
LOCK_FILE="/tmp/claude-notify-lock"
if [ -f "$LOCK_FILE" ]; then
  lock_age=$(( $(date +%s) - $(stat -f %m "$LOCK_FILE" 2>/dev/null || echo 0) ))
  if [ "$lock_age" -lt 2 ]; then
    exit 0
  fi
fi
touch "$LOCK_FILE"

# Extract cwd and compute short directory + git branch
cwd=$(echo "$input" | jq -r '.cwd // empty')
if [ -n "$cwd" ]; then
  short_cwd=$(echo "$cwd" | awk -F'/' '{n=NF; if(n<=3) print $0; else print ".../" $(n-2) "/" $(n-1) "/" $n}')
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    location="$short_cwd ($branch)"
  else
    location="$short_cwd"
  fi
  title="⚠️  | $location"
else
  title="⚠️ NEEDS APPROVAL"
fi

# Save the current tab title and set it to the approval title
printf '\e[22;0t\e]0;%s\a' "$title" > /dev/tty

# Determine the terminal app's process name for frontmost-check
case "$TERM_PROGRAM" in
  iTerm.app)       app_name="iTerm2" ;;
  Apple_Terminal)   app_name="Terminal" ;;
  vscode)          app_name="Code" ;;
  WezTerm)         app_name="WezTerm" ;;
  ghostty)         app_name="Ghostty" ;;
  Alacritty)       app_name="Alacritty" ;;
  *)               app_name="" ;;
esac

# Send a notification if the terminal is not frontmost
if [ "$(uname)" = "Darwin" ]; then
  if [ -n "$app_name" ]; then
    osascript -e "
      tell application \"System Events\"
        if not (name of first application process whose frontmost is true) is \"$app_name\" then
          display notification \"Claude is waiting for your approval\" with title \"Claude Code\" sound name \"Ping\"
        end if
      end tell
    "
  else
    # Unknown terminal — always notify as a safe fallback
    osascript -e 'display notification "Claude is waiting for your approval" with title "Claude Code" sound name "Ping"'
  fi
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "Claude Code" "Claude is waiting for your approval"
fi
