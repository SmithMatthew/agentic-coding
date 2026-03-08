#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
# Truncate to last 3 directory components
short_cwd=$(echo "$cwd" | awk -F'/' '{n=NF; if(n<=3) print $0; else print ".../" $(n-2) "/" $(n-1) "/" $n}')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ANSI color codes
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

# Get git branch (skip optional locks)
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Build directory + branch segment
if [ -n "$branch" ]; then
  dir_branch=$(printf "%s (${GREEN}%s${RESET})" "$short_cwd" "$branch")
else
  dir_branch="$short_cwd"
fi

# Colored model segment (dull orange)
model_colored=$(printf "${ORANGE}%s${RESET}" "$model")

# Colored context segment
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 75 ]; then
    ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="$ORANGE"
  else
    ctx_color="$GREEN"
  fi
  ctx_segment=$(printf "Context: ${ctx_color}%s%%${RESET} used" "$used")
  printf "%s | %s | %s" "$dir_branch" "$model_colored" "$ctx_segment"
else
  printf "%s | %s" "$dir_branch" "$model_colored"
fi
