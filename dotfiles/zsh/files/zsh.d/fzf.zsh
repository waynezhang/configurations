eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude tulsi-workspace --color=always'
export FZF_DEFAULT_OPTS="--ansi"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type directory --color=always'

bindkey -r '\ec'
bindkey '^Tf' fzf-file-widget

bindkey -r '^T'
bindkey '^Td' fzf-cd-widget
