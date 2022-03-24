autoload -U colors && colors  # Load colors
setopt autocd                 # Automatically cd into typed directory
stty stop undef               # Disable ctrl-s to freeze terminal
source "$ZDOTDIR/aliases"     # Load aliases

# Change prompt
[ $EUID -ne 0 ] &&
  PS1="%{$fg[green]%}[%B%{$fg[green]%}%n%{$fg[yellow]%}@%{$fg[cyan]%}%m %{$fg[magenta]%}%~%b%{$fg[green]%}]%{$reset_color%}$ " ||
  PS1="%{$fg[red]%}[%B%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[cyan]%}%m %{$fg[magenta]%}%~%b%{$fg[red]%}]%{$reset_color%}# "

# History settings
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space

# Search in history while typing
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^k" history-beginning-search-backward-end
bindkey "^j" history-beginning-search-forward-end

# Ignore case & hidden files completion
autoload -U compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
if [[ $TTY =~ "/dev/pts/[0-9]*" ]] then
  function zle-keymap-select () {
      case $KEYMAP in
          vicmd) echo -ne '\e[1 q';;      # block
          viins|main) echo -ne '\e[5 q';; # beam
      esac
  }
  zle -N zle-keymap-select
  zle-line-init() {
      zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
      echo -ne "\e[5 q"
  }
  zle -N zle-line-init
  echo -ne '\e[5 q' # Use beam shape cursor on startup.
  preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
fi

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\r'

# Edit line in vim with ctrl-e
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

# Load syntax highlighting (should be last)
source ~/.local/share/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 
