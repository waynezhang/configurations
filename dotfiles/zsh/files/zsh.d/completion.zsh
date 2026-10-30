zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu yes select
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' query-string prefix
# zsh-z adds fuzzy matches with compadd -U, so they don't share the typed prefix
zstyle ':fzf-tab:complete:(z|zshz):*' query-string input
zstyle ':fzf-tab:*' show-group quiet

# carapace filters candidates itself and is case-sensitive by default
export CARAPACE_MATCH=1

FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
