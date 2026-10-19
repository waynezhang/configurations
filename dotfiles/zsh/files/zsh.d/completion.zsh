zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu yes select
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*:descriptions' format '[%d]'

FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"


# complete `z` from the zoxide database (frecency order) instead of cwd only
function _z_frecent() {
  local -a dirs
  if [[ $PREFIX == [/~.]* ]]; then
    _path_files -/
    return
  fi
  dirs=("${(@f)$(zoxide query -l -- "${(@)words[2,CURRENT-1]}" "$PREFIX" 2>/dev/null)}")
  (( ${#dirs} )) || return 1
  (( ${#dirs} > 1 )) && compstate[insert]=menu
  # shorten $HOME to ~ (-Q: don't quote the tilde, so quote the rest by hand)
  dirs=("${(@)${(@)dirs/#$HOME\//~/}/#$HOME/~}")
  dirs=("${(@)dirs/#\~\/(#b)(*)/~/${(q)match[1]}}")
  compadd -U -Q -V frecent -- "${dirs[@]}"
}
