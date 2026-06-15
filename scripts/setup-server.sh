#!/usr/bin/env bash
# setup-server.sh — turn a Mac into your always-on dev sandbox.
#
# Run this ON the server (the Mac that stays on), not on your laptop:
#   git clone https://github.com/seripap/dotfiles ~/dotfiles
#   cd ~/dotfiles && ./scripts/setup-server.sh
#
# Idempotent: safe to re-run. Steps that need `sudo` say so and can be skipped
# with the flags below if you'd rather do them by hand.
#
#   --no-sleep-config   skip the pmset never-sleep tweak (needs sudo)
#   --no-remote-login   skip enabling Remote Login / SSH (needs sudo + Full Disk Access)
#
# After it finishes it prints the exact ~/.ssh/config.local block to paste on
# your laptop so `devbox` can reach this machine.

set -euo pipefail

do_sleep=1
do_login=1
for arg in "$@"; do
  case "$arg" in
    --no-sleep-config) do_sleep=0 ;;
    --no-remote-login) do_login=0 ;;
    -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; exit 1 ;;
  esac
done

say()  { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!! \033[0m %s\n' "$*" >&2; }

[ "$(uname -s)" = "Darwin" ] || { warn "this script targets macOS servers only"; exit 1; }

repo="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo"

# 1. Remote Login (SSH) — the entire "server" is just sshd.
if [ "$do_login" = 1 ]; then
  if [ "$(systemsetup -getremotelogin 2>/dev/null)" = "Remote Login: On" ]; then
    say "Remote Login already enabled"
  else
    say "Enabling Remote Login (SSH) — needs sudo"
    warn "if this fails, your terminal app needs Full Disk Access; or just enable"
    warn "  it in System Settings > General > Sharing > Remote Login"
    sudo systemsetup -setremotelogin on || warn "couldn't toggle Remote Login automatically — do it in System Settings"
  fi
fi

# 2. Power management for headless server use. Only sensible on a dedicated,
# plugged-in box. Skip with --no-sleep-config if this machine actually moves
# around.
#
#   sleep 0          no idle system sleep
#   disablesleep 1   lid-close doesn't trigger sleep either
#   disksleep 0      keep disks spinning (no first-read latency hiccup)
#   hibernatemode 0  no RAM-to-disk on sleep
#   standby 0        no auto-standby (deep sleep after N hours)
#   autorestart 1    power back on automatically after a power failure
#   tcpkeepalive 1   keep TCP connections alive during dark wake
#   womp 1           wake-on-magic-packet (LAN remote wake)
#   powernap 1       handle network activity during dark wake
if [ "$do_sleep" = 1 ]; then
  say "Configuring power management for headless server use (sudo)"
  warn "skip with --no-sleep-config if this is a machine you actually carry around"
  sudo pmset -a \
    sleep 0 \
    disablesleep 1 \
    disksleep 0 \
    hibernatemode 0 \
    standby 0 \
    autorestart 1 \
    tcpkeepalive 1 \
    womp 1 \
    powernap 1 \
    || warn "pmset failed — set 'Prevent sleeping' in System Settings > Energy"
fi

# 3. Homebrew + the toolchain (includes tmux, which devbox needs).
if ! command -v brew >/dev/null 2>&1; then
  say "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
say "Installing Brewfile dependencies (brew bundle)"
brew bundle --file="$repo/Brewfile"

# 4. Symlink the dotfiles into place.
say "Linking dotfiles (make install)"
make install

# 5. claude CLI — so background agents and the `ask` helper work on the server.
if command -v claude >/dev/null 2>&1; then
  say "claude CLI present"
else
  warn "claude CLI not found. Install it on the server if you want to run Claude here:"
  warn "  https://docs.claude.com/en/docs/claude-code/overview  (then run 'claude' once to auth)"
fi

# 6. xterm-ghostty terminfo. Ghostty's entry isn't in ncurses base, so when you
# ssh in from a Ghostty laptop you get "missing terminal: xterm-ghostty" and
# tmux refuses to start. Install the bundled snapshot into ~/.terminfo.
if infocmp -x xterm-ghostty >/dev/null 2>&1; then
  say "xterm-ghostty terminfo already installed"
elif [ -f "$repo/terminfo/xterm-ghostty.src" ]; then
  say "Installing xterm-ghostty terminfo"
  tic -x -o "$HOME/.terminfo" "$repo/terminfo/xterm-ghostty.src" \
    || warn "tic failed; ssh from Ghostty will hit 'missing terminal' errors"
else
  warn "no bundled terminfo at terminfo/xterm-ghostty.src, skipping"
fi

# 7. Reachability. Tailscale gives a stable name with no port-forwarding.
say "Checking reachability"
ts_host=""
if command -v tailscale >/dev/null 2>&1; then
  ts_host="$(tailscale status --json 2>/dev/null | sed -n 's/.*"DNSName": *"\([^"]*\)".*/\1/p' | head -1 | sed 's/\.$//')"
  [ -n "$ts_host" ] && say "Tailscale name: $ts_host"
else
  warn "Tailscale not installed. Recommended so you can reach this box from anywhere"
  warn "without exposing SSH to the internet:  brew install tailscale  (then 'tailscale up')"
fi

# Fallbacks if there's no tailnet name yet.
lan_host="$(scutil --get LocalHostName 2>/dev/null).local"
me="$(whoami)"
target="${ts_host:-$lan_host}"

cat <<EOF

$(say "Done. On your LAPTOP, add this to ~/.ssh/config.local:")

  Host devbox
    HostName $target
    User $me
    ForwardAgent yes

Then from the laptop:
  devbox            # land in the durable tmux session
  devbox run "claude -p 'go do the thing'"   # fire and forget; survives a closed lid
EOF
