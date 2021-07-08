eval "$(mcfly init bash)"

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zmodload zsh/zprof
export KEYID="0xE93C88B4F422B029"

. /usr/local/etc/profile.d/z.sh
alias server='open http://localhost:8000 && python -m http.server'
alias oath='ykman oath code $(ykman oath list | fzf)'
alias xsv='/Users/dseripap/local/xsv/target/release/xsv'

alias bd=". bd -si"
export ZSH=/Users/dseripap/.oh-my-zsh
alias killgpg="gpgconf --kill gpg-agent"
alias imgcat="~/bin/imgcat"
alias ks="kubectl"

export BAT_THEME="Dracula"

# setaws sets AWS credentials based on AWS_PROFILE
function setaws() {
	readonly acc=${1:?"Missing account; valid accs: fs, dan, danfsf, datas, s3sign, afc, afca"}
	echo "Setting AWS to $acc"
	export AWS_PROFILE=$acc
	export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
	export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
}

ZSH_THEME="dracula"
plugins=(docker brew docker-compose)

source $ZSH/oh-my-zsh.sh

if type rg &> /dev/null; then
	export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS='-m --height 50% --border'
    # Dracula fzf theme
    #export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
fi

function processInPort() {
    lsof -i tcp:$1
}

export NVM_DIR="$HOME/.nvm"

# NVM has tons of performance issue if running at start time, only load nvm when needed
nvm() {
  echo "NVM not loaded! Loading now..."
  unset -f nvm
  export NVM_PREFIX=$(brew --prefix nvm)
  [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
  nvm "$@"
}

export GOPATH="/Users/dseripap/go"

alias g="git"
alias pip=/usr/local/bin/pip3
alias python=python3
export PATH="/usr/local/sbin:$PATH"
