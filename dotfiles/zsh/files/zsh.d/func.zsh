alias gu="git up"
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|QA|QA-mid)\s*$)" | command xargs -n 1 git branch -d'

alias vi="nvim"
alias vim="nvim"
alias ls='eza'
alias dg='dotr git'

alias unq='xattr -r -d com.apple.quarantine'

alias wclaude='CLAUDE_CONFIG_DIR=~/.claude claude'
alias pclaude='CLAUDE_CONFIG_DIR=~/.claude-personal claude'

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
function gud() { GIT_COMMITTER_DATE="$1" GIT_AUTHOR_DATE="$1" git commit --amend --no-edit --date "$1" }

function dockersize() { docker manifest inspect -v "$1" | jq -c 'if type == "array" then .[] else . end' |  jq -r '[ ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), ( [ ( .OCIManifest // .SchemaV2Manifest ).layers[].size ] | add ) ] | join(" ")' | numfmt --to iec --format '%.2f' --field 2 | sort | column -t ; }
function compress_mp4() { ffmpeg -i $1 -crf 28 -preset fast $2 }
function fullwidth() { echo "$1" | sed 'y/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ０１２３４５６７８９/' }

function clock() { while true; do printf "\r%s" "$(date '+%Y-%m-%d %H:%M:%S')"; sleep 1; done }

function update_go_bins {
  pushd ~ > /dev/null
  local gobin="$(go env GOBIN)"
  local gobin="${gobin:-$(go env GOPATH)/bin}"
  print -rl ${gobin}/*(*) | while read file; do
    local name="${file:t}"
    if [[ "$name" == "go" || "$name" == "gofmt" ]]; then
      continue
    fi
    local pkg="$(go version -m "${file}" | head -n2 | tail -n1 | awk '{print $2}')"
    go install "${pkg}@latest"
  done
  popd > /dev/null
}

setopt completealiases
