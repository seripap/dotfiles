# Remote dev sandbox

Setup and usage live in [README.md](README.md#remote-development-sandbox).

```
       LAPTOP (Ghostty)                              SERVER 
  ┌──────────────────────────┐           ┌────────────────────────────────┐
  │                          │           │                                │
  │  $ devbox                │           │   ┌──────────────────────────┐ │
  │  $ devbox run <cmd>      │           │   │ tmux session "main"      │ │
  │  $ devbox status         │  ssh -t   │   │                          │ │
  │  $ devbox ssh <args>     │ ─────────►│   │   window: claude         │ │
  │                          │           │   │   window: build          │ │
  │  bin/devbox wraps:       │  (LAN or  │   │   window: ...            │ │
  │    ssh -t host           │  Tailnet) │   └──────────────────────────┘ │
  │    'zsh -lc              │           │              ▲                 │
  │      "tmux new -A -s     │           │              │ attach/create   │
  │         main"'           │           │              │                 │
  │                          │           │   pmset disablesleep           │
  │  ~/.ssh/config           │           │   Remote Login on              │
  │    Host devbox           │           │   brew: tmux, claude CLI       │
  │    ControlMaster auto    │           │   ~/dotfiles symlinked         │
  │                          │           │   ~/.terminfo/xterm-ghostty    │
  │                          │           │                                │
  │  Zed remote dev ───────────────────────► (reuses ~/.ssh/config)       │
  │  (ssh://devbox/path)     │           │                                │
  └──────────────────────────┘           └────────────────────────────────┘

     jobs in tmux survive:              one-time provision:
       disconnects                        ./scripts/setup-server.sh
       laptop sleep                       (run ON the server)
       closed lid
```

## Why each piece is there

| Piece | What it solves |
| --- | --- |
| `tmux` on the server | Long jobs (claude, builds, tests) survive ssh disconnect, laptop sleep, closed lid. |
| `bin/devbox` | One verb that attaches the session, launches detached commands in named windows, or lists what's running. |
| `ssh ControlMaster` | First call of the day prompts for auth; everything after is instant (and only one ssh connection on the wire). |
| `zsh -lc` on remote | Forces a login shell so `~/.zprofile` runs, putting `/opt/homebrew/bin` (tmux) on `$PATH`. Without this, `ssh host "tmux"` says "command not found." |
| `~/.terminfo/xterm-ghostty` | Ghostty's terminfo isn't in ncurses base. Without it tmux refuses to start with "missing or unsuitable terminal." `setup-server.sh` installs the bundled snapshot from `terminfo/xterm-ghostty.src`. |
| Tailscale (optional) | Stable hostname from anywhere, no port-forwarding, no exposing sshd to the internet. |
| `pmset disablesleep` | The "always-on" promise. Without it, a closed lid kills your jobs. |

## Common moves

```sh
devbox                              # interactive: land in tmux
devbox run "claude -p 'go fix X'"   # fire-and-forget; window named "claude"
devbox status                       # which sessions/windows exist on the box
devbox ssh uptime                   # raw ssh passthrough, no tmux

DEVBOX_HOST=otherbox devbox ...     # point at a different server
DEVBOX_SESSION=experiments devbox   # use a different tmux session name
```
