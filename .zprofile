#!/bin/zsh

export PATH="$PATH:$HOME/.local/bin"
export EDITOR="nvim"

# Move stuff from $HOME
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export LESSHISTFILE="-"
export MYSQL_HISTFILE="/dev/null"

# `less` syntax highlighting
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export LESS=' -R '

# Login message
echo "Uptime: $(uptime -p)"
echo "Load Average: $(cat /proc/loadavg | cut -d' ' -f1-3)"
