#!/bin/sh
# Save the current tab title and set it to "NEEDS APPROVAL"
printf '\e[22;0t\e]0;⚠️ NEEDS APPROVAL\a' > /dev/tty

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
