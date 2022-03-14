eval "$(mcfly init zsh)"
fpath+=$HOME/.zsh/pure

autoload -Uz compinit
autoload -U promptinit; promptinit
prompt pure
prompt_newline='%666v'
PROMPT=" $PROMPT"

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zmodload zsh/zprof
export KEYID="0xE93C88B4F422B029"

. /Users/dseripap/local/cli/z.sh

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

ZSH_THEME=""
plugins=(docker brew docker-compose)

source $ZSH/oh-my-zsh.sh

if type rg &> /dev/null; then
	  export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS="-m --height 50% --border"
    # Dracula fzf theme
    export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
    #export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#--color=dark
#--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
#--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
#'
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

export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="/opt/homebrew/opt/mysql-client/bin:/usr/local/sbin:$PATH:${GOPATH}/bin:${GOROOT}/bin:~/.qsh/bin:/Users/dseripap/.composer/vendor/bin:/Users/dseripap/.cargo/bin"

alias g="git"

function killPort() {
  readonly PORT_NUMBER=${1:?"Specify port number to kill"}
  lsof -i tcp:${PORT_NUMBER} | awk 'NR!=1 {print $2}' | xargs kill
}
ctags=/opt/homebrew/bin/ctags
alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
