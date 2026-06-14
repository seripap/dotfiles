#  ~/.zshrc — Dan's shell config
#  Symlinked from ~/dotfiles/.zshrc by `make install`.
#  Per-machine secrets/identity go in ~/.extra (gitignored).

# ---------- Claude session recording ----------
# Auto-record interactive sessions via script(1) so `ask` can read previous output.
# Set CLAUDE_NO_RECORD=1 to opt out for a specific shell.
if [ -z "$CLAUDE_SCRIPT_ACTIVE" ] && [ -z "$CLAUDE_NO_RECORD" ] \
   && [ -t 0 ] && [ -t 1 ] && command -v script >/dev/null 2>&1; then
  # Sweep stale logs from shells that didn't clean up (>1 day old)
  find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'claude_session_*.log' -mtime +1 -delete 2>/dev/null
  export CLAUDE_SCRIPT_ACTIVE=1
  export CLAUDE_SESSION_LOG="${TMPDIR:-/tmp}/claude_session_$$.log"
  exec script -F -q "$CLAUDE_SESSION_LOG" "$SHELL"
fi

# Inner (script-wrapped) shell: register cleanup. Set here, not before exec —
# EXIT traps don't survive process replacement.
if [ -n "$CLAUDE_SCRIPT_ACTIVE" ] && [ -n "$CLAUDE_SESSION_LOG" ]; then
  trap 'rm -f "$CLAUDE_SESSION_LOG"' EXIT
fi

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

# ---------- Claude quick-ask ----------
# `ask <q>` — ask Claude about recent terminal output (recorded by script(1) above).
# Pipes still work too: `ls -l | claude -p "..."`
# Tunable: CLAUDE_ASK_LINES (default 300) = how much scrollback to feed Claude.
# Allow unquoted prompts like `ask how many files?` — disables glob expansion of ?, *, [...]
alias ask='noglob _ask'
_ask() {
  # Silence zsh's "[2] 12345" / "[2] + done ..." job-control chatter
  setopt LOCAL_OPTIONS NO_MONITOR NO_NOTIFY
  if [ -z "$CLAUDE_SESSION_LOG" ] || [ ! -s "$CLAUDE_SESSION_LOG" ]; then
    echo "ask: no session log — recording is disabled or hasn't captured anything yet." >&2
    return 1
  fi
  local lines="${CLAUDE_ASK_LINES:-300}"
  local tmpout
  tmpout=$(mktemp -t claude_ask) || return 1

  # Run claude in background, buffer to a tmp file
  { tail -n "$lines" "$CLAUDE_SESSION_LOG" \
      | sed -E $'s/\x1b\\[[0-9;?]*[a-zA-Z]//g; s/\r$//' \
      | sed '$d' \
      | claude -p "$*" >"$tmpout" 2>&1 ; } &
  local pid=$!

  # Braille spinner while claude is working
  local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  local i=1
  printf '\033[?25l'  # hide cursor
  trap "kill $pid 2>/dev/null; printf '\r\033[K\033[?25h'; rm -f '$tmpout'" INT
  while kill -0 $pid 2>/dev/null; do
    printf '\r\033[36m%s\033[0m thinking…' "${frames[i]}"
    i=$(( i % 10 + 1 ))
    sleep 0.08
  done
  printf '\r\033[K\033[?25h'  # clear spinner, show cursor
  trap - INT

  wait $pid 2>/dev/null
  local rc=$?
  cat "$tmpout" 2>/dev/null
  rm -f "$tmpout"
  return $rc
}

# ---------- Per-machine extras ----------
[ -f "$HOME/.extra" ] && . "$HOME/.extra"
