alias gu="git up"
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|QA|QA-mid)\s*$)" | command xargs -n 1 git branch -d'

alias vi="nvim"
alias vim="nvim"
alias ls='eza'
alias dg='dotr git'

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
function gud() { GIT_COMMITTER_DATE="$1" GIT_AUTHOR_DATE="$1" git commit --amend --no-edit --date "$1" }
function dockersize() { docker manifest inspect -v "$1" | jq -c 'if type == "array" then .[] else . end' |  jq -r '[ ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), ( [ ( .OCIManifest // .SchemaV2Manifest ).layers[].size ] | add ) ] | join(" ")' | numfmt --to iec --format '%.2f' --field 2 | sort | column -t ; }

setopt completealiases
