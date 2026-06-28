#!/usr/bin/env bash
# Toggle tmux between dark and light themes.
# Bound to prefix + T in tmux.conf

theme_file="$HOME/.tmux/.theme"
current=$(cat "$theme_file" 2>/dev/null || echo "dark")

if [ "$current" = "light" ]; then
  echo "dark" > "$theme_file"
else
  echo "light" > "$theme_file"
fi

tmux source-file "$HOME/.tmux.conf"