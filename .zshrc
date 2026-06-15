#  ~/.zshrc — Dan's shell config
#  Symlinked from ~/dotfiles/.zshrc by `make install`.
#  Per-machine secrets/identity go in ~/.extra (gitignored).

# ---------- Claude session recording ----------
# Auto-record interactive sessions via script(1) so `ask` can read previous output.
# - Set CLAUDE_NO_RECORD=1 to opt out for a specific shell.
# - Prefix a command with a space to keep it out of the session log (mirrors HIST_IGNORE_SPACE).
if [ -z "$CLAUDE_SCRIPT_ACTIVE" ] && [ -z "$CLAUDE_NO_RECORD" ] \
   && [ -t 0 ] && [ -t 1 ] && command -v script >/dev/null 2>&1; then
  # Sweep stale logs from shells that didn't clean up (>1 day old)
  find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'claude_session_*.log' -mtime +1 -delete 2>/dev/null
  export CLAUDE_SCRIPT_ACTIVE=1
  # Captured BEFORE script(1) takes the PTY, so `claude` (and any other TUI that
  # gets mangled by BSD script's PTY proxy) can redirect stdio straight to the
  # real Ghostty TTY and bypass the recording layer.
  export CLAUDE_ORIG_TTY="$(tty 2>/dev/null || true)"
  export CLAUDE_SESSION_LOG="${TMPDIR:-/tmp}/claude_session_$$.log"
  # PID of the shell that *owns* the log — only this shell deletes on EXIT.
  # Sub-shells (flox activate, turbo dev, direnv, ...) inherit CLAUDE_SESSION_LOG
  # but must NOT clean it up when they exit. Without this, every sub-shell exit
  # would rm the log and break `ask` in the parent.
  export CLAUDE_SCRIPT_OWNER_PID=$$
  : > "$CLAUDE_SESSION_LOG"  # start fresh; -a below opens in O_APPEND mode
  exec script -F -a -q "$CLAUDE_SESSION_LOG" "$SHELL"
fi

# Inner (script-wrapped) shell setup
if [ -n "$CLAUDE_SCRIPT_ACTIVE" ] && [ -n "$CLAUDE_SESSION_LOG" ]; then
  # EXIT traps don't survive `exec`, so register cleanup here — but ONLY the
  # original script(1)-wrapped shell should delete the log. Sub-shells that
  # source .zshrc (flox, turbo, direnv) inherit the env vars; their EXIT
  # would otherwise rm the file out from under us.
  if [ "$CLAUDE_SCRIPT_OWNER_PID" = "$$" ] || [ -z "$CLAUDE_SCRIPT_OWNER_PID" ]; then
    trap 'rm -f "$CLAUDE_SESSION_LOG"' EXIT
  fi

  # Leading-space commands get truncated from the log after they run.
  # Works because script -a opens with O_APPEND — external truncation is safe.
  typeset -g _CLAUDE_OFFSET=0
  _claude_save_offset() {
    # Guard: if the log went missing (sub-shell race, manual rm, etc.), no-op
    # silently instead of letting zsh's redirect-open error reach the prompt.
    [ -f "$CLAUDE_SESSION_LOG" ] || { _CLAUDE_OFFSET=0; return; }
    _CLAUDE_OFFSET=$(wc -c <"$CLAUDE_SESSION_LOG" 2>/dev/null | tr -d ' ')
    [ -z "$_CLAUDE_OFFSET" ] && _CLAUDE_OFFSET=0
  }
  _claude_maybe_redact() {
    [ -z "$_CLAUDE_REDACT_NEXT" ] && return
    [ -f "$CLAUDE_SESSION_LOG" ] || { unset _CLAUDE_REDACT_NEXT; return; }
    perl -e 'truncate $ARGV[0], $ARGV[1]' "$CLAUDE_SESSION_LOG" "$_CLAUDE_OFFSET" 2>/dev/null
    unset _CLAUDE_REDACT_NEXT
  }
  _claude_mark_redact() {
    case "$1" in ' '*) typeset -g _CLAUDE_REDACT_NEXT=1 ;; esac
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _claude_maybe_redact   # truncate first (using old offset)
  add-zsh-hook precmd _claude_save_offset    # then save offset for the next command
  add-zsh-hook preexec _claude_mark_redact

  # Re-source Ghostty's shell integration. The `exec script $SHELL` above starts
  # a fresh zsh that bypasses Ghostty's ZDOTDIR-based auto-injection, so OSC 7
  # (cwd reporting) stops firing — which breaks new-tab/window cwd inheritance.
  # The integration script is explicitly designed to be sourced manually.
  if [ -n "$GHOSTTY_RESOURCES_DIR" ] \
     && [ -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
  fi
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

# Tool-specific completions (load after compinit, before syntax-highlighting)
command -v gh      >/dev/null 2>&1 && eval "$(gh completion -s zsh)"
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  compdef __start_kubectl ks                # make `ks` autocomplete like `kubectl`
fi
command -v flox >/dev/null 2>&1 && eval "$(flox completions zsh 2>/dev/null)"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# direnv — per-dir env via .envrc
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ---------- Aliases ----------
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l --git --group-directories-first --icons=auto'
  alias la='eza -la --git --group-directories-first --icons=auto'
  alias l='eza --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --git-ignore --icons=auto'
else
  alias ll='ls -lhG'
  alias la='ls -lhAG'
  alias l='ls -CFG'
fi
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
alias vi='nvim'
alias map='xargs -n1'                                                  # `find . -name foo | map dirname`
alias flush='dscacheutil -flushcache && killall -HUP mDNSResponder'    # macOS DNS cache flush
alias pubip='dig +short myip.opendns.com @resolver1.opendns.com'
alias week='date +%V'                                                  # ISO week number
alias serve='python3 -m http.server'
alias devhelp='~/dotfiles/bin/devbox-banner'                            # re-show devbox cheatsheet + resource snapshot

# ---------- Functions ----------
mkd() { mkdir -p "$@" && cd "$_" || return; }
tmpd() { local d; d=$(mktemp -d) && cd "$d" || return; }
getcertnames() {                                                       # dump CN + SANs from a TLS cert
  local d=$1
  [ -z "$d" ] && { echo "usage: getcertnames <domain>" >&2; return 1; }
  echo | openssl s_client -showcerts -servername "$d" -connect "$d:443" 2>/dev/null \
    | openssl x509 -text -certopt no_header,no_serial,no_version,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux
}
# `caf` / `uncaf` — keep Mac awake until told otherwise.
# Bare `caf` toggles. Explicit: `caf on`, `caf off`, `caf status`.
# Persists across shells via a pidfile; RPROMPT shows `caf` in yellow when active.
_CAF_PIDFILE="${TMPDIR:-/tmp}/caffeinate-$USER.pid"
_caf_active() { [ -f "$_CAF_PIDFILE" ] && kill -0 "$(cat "$_CAF_PIDFILE" 2>/dev/null)" 2>/dev/null; }
caf() {
  case "${1:-toggle}" in
    on|start)
      if _caf_active; then
        echo "already caffeinated (pid $(cat "$_CAF_PIDFILE"))"
        return 0
      fi
      # silence zsh's "[4] 12345" / "[4] + done" job-control chatter
      setopt LOCAL_OPTIONS NO_MONITOR NO_NOTIFY
      nohup caffeinate -di >/dev/null 2>&1 &
      echo $! > "$_CAF_PIDFILE"
      disown
      echo "caffeinated (pid $(cat "$_CAF_PIDFILE"))"
      ;;
    off|stop)
      if _caf_active && kill "$(cat "$_CAF_PIDFILE")" 2>/dev/null; then
        rm -f "$_CAF_PIDFILE"
        echo "uncaffeinated"
      else
        [ -f "$_CAF_PIDFILE" ] && rm -f "$_CAF_PIDFILE"   # stale
        echo "not caffeinated"
      fi
      ;;
    toggle) _caf_active && caf off || caf on ;;
    status)
      if _caf_active; then
        echo "caffeinated (pid $(cat "$_CAF_PIDFILE"))"
      else
        [ -f "$_CAF_PIDFILE" ] && rm -f "$_CAF_PIDFILE"
        echo "not caffeinated"
      fi
      ;;
    *) echo "usage: caf [on|off|toggle|status]" >&2; return 1 ;;
  esac
}
uncaf() { caf off; }

extract() {                                                            # DTRT for any archive type
  local f=$1
  [ -z "$f" ] && { echo "usage: extract <archive>" >&2; return 1; }
  [ ! -f "$f" ] && { echo "extract: $f: no such file" >&2; return 1; }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf "$f" ;;
    *.tar.gz|*.tgz)   tar xzf "$f" ;;
    *.tar.xz|*.txz)   tar xJf "$f" ;;
    *.tar.zst)        tar --zstd -xf "$f" ;;
    *.tar)            tar xf "$f" ;;
    *.bz2)            bunzip2 "$f" ;;
    *.gz)             gunzip "$f" ;;
    *.xz)             unxz "$f" ;;
    *.zst)            unzstd "$f" ;;
    *.zip|*.jar)      unzip "$f" ;;
    *.7z)             7z x "$f" ;;
    *.rar)            unrar x "$f" ;;
    *.Z)              uncompress "$f" ;;
    *) echo "extract: unsupported format: $f" >&2; return 1 ;;
  esac
}

# ---------- zoxide (smarter cd) ----------
# `z foo` jumps to a directory matching `foo`; `zi` opens an interactive picker.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

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

# Caffeinated indicator in RPROMPT.
# pure sets RPROMPT once at setup with embedded var refs — cache it here so our
# hook can rebuild RPROMPT from a fixed base instead of mutating in place
# (which accumulated "caf caf caf" each precmd).
typeset -g _CAF_RPROMPT_BASE="$RPROMPT"
_caf_rprompt() {
  if _caf_active; then
    RPROMPT="%F{yellow}caffinated%f${_CAF_RPROMPT_BASE:+ $_CAF_RPROMPT_BASE}"
  else
    RPROMPT="$_CAF_RPROMPT_BASE"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _caf_rprompt

# ---------- Claude quick-ask ----------
# `ask <q>` — ask Claude about recent terminal output (recorded by script(1) above).
# Pipes still work too: `ls -l | claude -p "..."`
# Tunable: CLAUDE_ASK_LINES (default 300) = how much scrollback to feed Claude.
# `ask-clean` — remove all claude_session_*.log files (including the current one,
# which gets re-created empty so recording continues).
ask-clean() {
  local dir="${TMPDIR:-/tmp}"
  local count
  count=$(find "$dir" -maxdepth 1 -name 'claude_session_*.log' 2>/dev/null | wc -l | tr -d ' ')
  find "$dir" -maxdepth 1 -name 'claude_session_*.log' -delete 2>/dev/null
  [ -n "$CLAUDE_SESSION_LOG" ] && : > "$CLAUDE_SESSION_LOG"
  echo "ask-clean: removed $count session log(s)"
}

# `claude` — bypass script(1) for interactive Claude Code sessions. BSD script
# on macOS garbles the cursor-positioning sequences Ink uses to redraw the
# @-mention picker, which makes the prompt area visibly shift on every keystroke.
# Routing stdio to the original Ghostty TTY (captured pre-script) sidesteps it.
# Pipes and one-shot `claude -p` fall through to the normal path so `ask` and
# other automation keep working. Interactive sessions are NOT recorded.
claude() {
  if [ -n "$CLAUDE_ORIG_TTY" ] && [ -e "$CLAUDE_ORIG_TTY" ] && [ -t 0 ] && [ -t 1 ]; then
    command claude "$@" <"$CLAUDE_ORIG_TTY" >"$CLAUDE_ORIG_TTY" 2>"$CLAUDE_ORIG_TTY"
  else
    command claude "$@"
  fi
}

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

  # Force line-buffered claude output if gstdbuf is available (brew install coreutils).
  # Falls back to default block buffering if not installed — output still works, just chunkier.
  local linebuf=()
  command -v gstdbuf >/dev/null 2>&1 && linebuf=(gstdbuf -oL)

  # Run claude in background, writing to tmpfile so we can both spin AND stream.
  # `env -u ANTHROPIC_API_KEY` drops any externally-injected key (e.g. fs-global
  # flox sources one from 1Password) so claude falls back to subscription auth.
  { tail -n "$lines" "$CLAUDE_SESSION_LOG" \
      | sed -E $'s/\x1b\\[[0-9;?]*[a-zA-Z]//g; s/\r$//' \
      | sed '$d' \
      | $linebuf env -u ANTHROPIC_API_KEY claude -p "$*" >"$tmpout" 2>&1 ; } &
  local pid=$!

  # Phase 1: braille spinner while we wait for claude's first byte
  local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  local i=1
  printf '\033[?25l'  # hide cursor
  local tail_pid=
  trap "kill $pid $tail_pid 2>/dev/null; printf '\r\033[K\033[?25h'; rm -f '$tmpout'" INT
  while kill -0 $pid 2>/dev/null && [ ! -s "$tmpout" ]; do
    printf '\r\033[36m%s\033[0m thinking…' "${frames[i]}"
    i=$(( i % 10 + 1 ))
    sleep 0.08
  done
  printf '\r\033[K\033[?25h'  # clear spinner line

  # Phase 2: stream output. tail -f from byte 0 until claude exits.
  tail -f -c +0 "$tmpout" 2>/dev/null &
  tail_pid=$!
  wait $pid 2>/dev/null
  local rc=$?
  sleep 0.1  # let tail drain any final bytes claude flushed on exit
  kill $tail_pid 2>/dev/null
  wait $tail_pid 2>/dev/null
  trap - INT
  rm -f "$tmpout"
  return $rc
}

# ---------- zsh plugins (must be near the bottom; syntax-highlighting goes LAST) ----------
# Tame autosuggestions: skip long lines (rendering looks disconnected), history-only.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=80
ZSH_AUTOSUGGEST_STRATEGY=(history)
if [ -n "$HOMEBREW_PREFIX" ]; then
  # fzf-tab MUST load after compinit and BEFORE autosuggestions/syntax-highlighting
  [ -f "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.plugin.zsh" ] && \
    . "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.plugin.zsh"
  [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    . "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    . "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ---------- Per-machine extras ----------
[ -f "$HOME/.extra" ] && . "$HOME/.extra"
