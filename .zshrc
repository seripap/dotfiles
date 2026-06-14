#  ~/.zshrc — Dan's shell config
#  Symlinked from ~/dotfiles/.zshrc by `make install`.
#  Per-machine secrets/identity go in ~/.extra (gitignored).

# ---------- PATH ----------
# Homebrew (Apple Silicon first, fall back to Intel)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/dotfiles/bin:$HOME/bin:$PATH"

# ---------- History ----------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# ---------- Defaults ----------
setopt AUTO_CD              # `cd` by typing a directory
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS # allow `# comments` at the prompt
export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8

# ---------- Completion ----------
autoload -Uz compinit && compinit -i
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ---------- Aliases ----------
alias ll='ls -lhG'
alias la='ls -lhAG'
alias l='ls -CFG'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias g='git'
alias gs='git s'           # uses the alias in .gitconfig
alias gd='git diff'
alias gco='git checkout'
alias gp='git pull'
alias gps='git push'
alias ks='kubectl'
alias bd='. bd -si'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias vim='nvim'

# ---------- z (jump) ----------
[ -f "$HOME/dotfiles/scripts/z.sh" ] && . "$HOME/dotfiles/scripts/z.sh"

# ---------- fzf ----------
if command -v fzf >/dev/null 2>&1; then
  [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && \
    . "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && \
    . "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ---------- Prompt (pure) ----------
if [ -d "$(brew --prefix 2>/dev/null)/share/zsh/site-functions" ]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi
PURE_PROMPT_SYMBOL='$'
autoload -U promptinit 2>/dev/null && promptinit && prompt pure 2>/dev/null

# ---------- Per-machine extras ----------
[ -f "$HOME/.extra" ] && . "$HOME/.extra"
