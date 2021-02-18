# Load colors
autoload -U colors && colors

# Change prompt
[ $EUID -ne 0 ] &&
  PS1="%{$fg[green]%}[%B%{$fg[green]%}%n%{$fg[yellow]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%~%b%{$fg[green]%}]%{$reset_color%}$ " ||
  PS1="%{$fg[red]%}[%B%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%~%b%{$fg[red]%}]%{$reset_color%}# "

# History settings
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.

# Search in history while typing
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^k" history-beginning-search-backward-end
bindkey "^j" history-beginning-search-forward-end

# Load aliases
source "$HOME/.config/aliases"

# Automatically cd into typed directory
setopt autocd

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=5

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Colored man pages
function man() {
	env \
		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
		LESS_TERMCAP_me=$(tput sgr0) \
		LESS_TERMCAP_mb=$(tput blink) \
		LESS_TERMCAP_us=$(tput setaf 2) \
		LESS_TERMCAP_ue=$(tput sgr0) \
		LESS_TERMCAP_so=$(tput smso) \
		LESS_TERMCAP_se=$(tput rmso) \
		PAGER="${commands[less]:-$PAGER}" \
		man "$@"
}

# Load syntax highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
