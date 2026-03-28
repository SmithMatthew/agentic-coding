#!/bin/sh
# Restore the previously saved tab title
printf '\e[23;0t' > /dev/tty
# Clean up the notification debounce lock so the next cycle works
rm -f /tmp/claude-notify-lock
