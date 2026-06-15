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
| `pmset disablesleep` | Without it, a closed lid kills your jobs. |

## Common moves

```sh
devbox                              # interactive: land in tmux
devbox run "claude -p 'go fix X'"   # fire-and-forget; window named "claude"
devbox status                       # which sessions/windows exist on the box
devbox ssh uptime                   # raw ssh passthrough, no tmux

DEVBOX_HOST=otherbox devbox ...     # point at a different server
DEVBOX_SESSION=experiments devbox   # use a different tmux session name
```

`devbox` is self-aware: if you ssh into the box (or open Zed's remote terminal) and run `devbox` there, it skips the ssh layer and talks to local tmux directly.
`scripts/setup-server.sh` handles the mechanical parts. 

The rest is physical / policy and needs your hands.

### What the script handles

| Step | What |
| --- | --- |
| Remote Login | `systemsetup -setremotelogin on` (skip with `--no-remote-login`) |
| Power management | `pmset -a sleep 0 disablesleep 1 disksleep 0 hibernatemode 0 standby 0 autorestart 1 tcpkeepalive 1 womp 1 powernap 1` (skip with `--no-sleep-config`) |
| Toolchain | Homebrew + `Brewfile` (incl. tmux, neovim, gh, ripgrep, …) |
| Dotfiles | `make install` symlinks everything |
| Terminfo | Installs the bundled `xterm-ghostty` so tmux from a Ghostty client works |
| Reachability hint | Prints the exact `~/.ssh/config.local` block to paste on your laptop |

### What you still do by hand

#### 1. Lid handling

A closed MBP normally drops wifi unless it's in real clamshell mode (external display + power + USB peripheral). `disablesleep 1` keeps the system awake, but wifi still throttles. Two reliable fixes:

- **Easiest:** leave the lid open, brightness to 1, screen-saver to "Never". The display can sleep; the system stays up.
- **Best:** plug in ethernet (USB-C → Gigabit dongle if needed). Wired bypasses the wifi power-saving issue entirely.

#### 2. Network reachability

You want a stable name that works from anywhere, not just on the LAN.

- **Tailscale** (recommended). `brew install --cask tailscale`, sign in once, `tailscale up`. You now have `<hostname>.your-tailnet.ts.net` reachable from any device on your tailnet, NAT-traversal handled, encrypted by default. Use that hostname in `~/.ssh/config.local`.
- **DHCP reservation** on your router. Pin the MBP's MAC to a stable LAN IP. Belt to Tailscale's suspenders. Useful even with Tailscale if you also want raw-IP access on LAN.

#### 3. SSH keepalive (server side)

Pairs with the `ServerAliveInterval` already in `~/.ssh/config`. On the server:

```sh
sudo tee /etc/ssh/sshd_config.d/keepalive.conf >/dev/null <<'EOF'
ClientAliveInterval 60
ClientAliveCountMax 10
EOF
sudo launchctl kickstart -k system/com.openssh.sshd
```

Keeps idle ssh sessions from being dropped by intermediate NATs.

#### 4. Boot resilience

When the box reboots itself (power blip, kernel panic, software update), you want sshd reachable again without sitting at the keyboard. With FileVault on (which you should keep), the disk is locked at the pre-boot stage and sshd normally isn't reachable until someone unlocks it at the console. Modern macOS has a real answer for this.

**macOS Tahoe (26+) on Apple Silicon: ssh unlock at pre-boot.** When Remote Login is enabled (the script does this), the pre-boot environment runs an SSH listener you can connect to with your account password. It unlocks the data volume, drops the connection briefly while the OS finishes booting, then sshd comes up normally and you reconnect.

```sh
ssh user@devbox          # connects to pre-boot sshd
# you'll see a prompt indicating the Mac is locked
# enter your account password (NOT an ssh key — keys don't work pre-unlock)
# connection closes, OS finishes booting
ssh user@devbox          
```

Constraints:
- Apple Silicon only (no Intel support).
- The Mac has to reach the network at pre-boot. Works over wired ethernet (open or unauthenticated) and previously-joined WPA2-PSK wifi. Does **not** work over WPA3/Enterprise wifi. Tailscale doesn't help here (it needs the OS running).
- All FileVault-enabled users can unlock via pre-boot ssh. Add users with `sudo fdesetup add -usertoadd <name>` if needed.
- Refs: [Apple KB 124963](https://support.apple.com/en-us/124963), [Der Flounder writeup](https://derflounder.wordpress.com/2025/10/11/unlocking-filevault-via-ssh-on-macos-tahoe/), `man apple_ssh_and_filevault`.

**Older macOS or Intel: `fdesetup authrestart`.** One-shot: authenticate now, the next reboot proceeds without prompting. Useful when you know a reboot is coming (kernel update, manual maintenance). Doesn't help with unplanned reboots.

```sh
sudo fdesetup authrestart    # prompts for FileVault password, schedules next reboot
```

**Other boot-time stuff:**
- **Enable Automatic Login** in System Settings → Users & Groups → "Automatically log in as" → pick your user. Not required for sshd alone, but launchd user agents, iCloud Drive, and similar need a real user session.
- `autorestart 1` (already set by the script) auto-powers-on after a power failure.

#### 5. Verify

```sh
sw_vers -productVersion   # macOS 26+ gets you pre-boot ssh unlock for FileVault
pmset -g                  # confirm sleep flags, autorestart, tcpkeepalive, womp, powernap
systemsetup -getremotelogin
sudo sshd -T | grep -i clientalive
fdesetup status           # FileVault should be On
tailscale status          # if using tailscale
ls ~/.terminfo/x/xterm-ghostty
```
