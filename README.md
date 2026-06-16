# dotfiles

Dan's daily driver. Optimized for macOS and agentic development.

## Install

```sh
git clone https://github.com/seripap/dotfiles ~/dotfiles
cd ~/dotfiles
make brew     # install dependencies via Homebrew
make install  # symlink dotfiles into $HOME
```

`make install` is idempotent and refuses to overwrite real files (only symlinks). Back up any pre-existing `~/.zshrc`, `~/.vimrc`, etc. before running.

## Layout

| Path | Purpose |
| --- | --- |
| `.zshrc` | Shell config — PATH, history, aliases, fzf, pure prompt, zoxide, `ask`, `caf` |
| `.vimrc` | Neovim config — plugins via vim-plug, Go/JS/TS, oceanic-next |
| `.gitconfig` | Git aliases, difftastic as external diff, SSH commit signing |
| `.gitignore` | Global gitignore (referenced by `.gitconfig`) |
| `coc-settings.json` | coc.nvim language server settings |
| `.claude/CLAUDE.md` | Claude Code agent profile (preferences, house style, workflow rules) |
| `.claude/skills/` | Personal Claude skills (e.g. `devbox-browser`); symlinked into `~/.claude/skills` by `make install` |
| `.ssh/config` | SSH defaults (ControlMaster, keepalive). Real hosts go in `~/.ssh/config.local` (gitignored). Zed remote dev + `devbox` inherit this |
| `bin/devbox` | Client-side connector — run long-lived commands inside a durable tmux session on your sandbox |
| `bin/devbox-playwright` | Launch a Playwright browser server on the devbox; drive it from local tests over an ssh-tunneled WebSocket |
| `bin/devbox-shot` | One-shot screenshot / page-health probe against the devbox browser server (used by the `devbox-browser` Claude skill) |
| `scripts/setup-server.sh` | Provisions a Mac into an always-on dev sandbox (run on the server) |
| `bin/` | Personal scripts on `$PATH` |
| `Brewfile` | Homebrew dependencies (`brew bundle`) — shell, search, diff, neovim, k8s (k9s/kubectx/stern), dev workflow (gh/direnv/uv/ruff), AWS, gdal |
| `Makefile` | `install`, `uninstall`, `brew`, `test` targets |

## `ask` — quick Claude lookups against terminal output

Interactive shells are auto-recorded via `script(1)` to `$TMPDIR/claude_session_<pid>.log`. Logs are removed when the shell exits cleanly; a startup sweep also reaps anything older than 1 day in case a shell was killed. The `ask` function feeds the recent scrollback to `claude -p` so you can ask questions about whatever just printed.

```sh
$ ls -l
...
$ ask how many files here?
$ ask any of these look suspicious?
$ ask "with quotes still works"
```

Notes:
- Requires the `claude` CLI on `$PATH` (uses your existing Claude subscription).
- A `noglob` alias means unquoted prompts containing `?`, `*`, `[...]` stay literal.
- A braille spinner runs while Claude thinks; output prints when done.
- Tunables: `CLAUDE_ASK_LINES` (default `300`) controls how much scrollback is sent. Set `CLAUDE_NO_RECORD=1` before opening a shell to disable recording for that session.
- TUIs (vim, less, fzf) write a lot of escape codes; ANSI stripping handles most of it but their output won't be pristine.

### Skipping sensitive commands

Prefix a command with a space and it gets truncated from the session log after it runs — the same convention `HIST_IGNORE_SPACE` uses for shell history:

```sh
$  export DB_PASSWORD=hunter2    # leading space → wiped from log
$  aws sts assume-role ...       # same
$ ls -l                          # no leading space → recorded normally
```

### Cleanup

```sh
ask-clean   # remove all session logs (current shell's log is reset to empty)
```

Logs are also auto-removed when the shell exits cleanly, and a startup sweep reaps anything older than 1 day in case a shell crashed.

## `caf` — keep the Mac awake

Wraps macOS `caffeinate -di` in a backgrounded process with a pidfile, so the awake state survives the shell that started it. RPROMPT shows a yellow `caffinated` tag while active.

```sh
caf          # toggle (default)
caf on       # start — prevents display + idle sleep
caf off      # stop
caf status   # report state
uncaf        # alias for `caf off`
```

State lives in `$TMPDIR/caffeinate-$USER.pid`. Stale pidfiles (after reboot, force-kill) are auto-cleaned by `kill -0` checks.

## Remote development sandbox

See [REMOTE.md](REMOTE.md) for the architecture diagram.

### On the server 

```sh
git clone https://github.com/seripap/dotfiles ~/dotfiles
cd ~/dotfiles
./scripts/setup-server.sh   # enables SSH, disables sleep, brew bundle, make install
```

It's idempotent. It enables Remote Login and `pmset` never-sleep (both need
`sudo`; skip with `--no-remote-login` / `--no-sleep-config`), installs the
toolchain (incl. tmux), links the dotfiles, and prints the exact
`~/.ssh/config.local` block to paste on your laptop. Install Tailscale on the box
for a stable name with no port-forwarding, and the `claude` CLI if you want to
run agents there.

### On the client 

Add the host to `~/.ssh/config.local` (the template in `~/.ssh/config` carries
the ControlMaster + keepalive defaults), then:

```sh
devbox                              # land in the durable tmux session
devbox run "claude -p 'go fix it'"  # fire-and-forget; keeps running if you close the lid
devbox status                       # what's running on the server right now
devbox ssh uptime                   # raw ssh passthrough
```

Override the target with `DEVBOX_HOST=otherbox devbox ...`. Zed remote dev
(`zed ssh://devbox/path`) reuses the same `~/.ssh/config`, so no duplicate setup.

### Headless browser tests on the devbox

`devbox-playwright` runs a Playwright browser server on the devbox so your
laptop's test code can drive a real browser remotely. Browser process and any
state live on the box (survives lid-close via tmux); the wsEndpoint reaches
you through an ssh tunnel, so nothing is exposed off-host.

```sh
devbox-playwright start      # install on devbox (first run), launch in tmux, open ssh tunnel
devbox-playwright status     # tunnel + remote window state
devbox-playwright endpoint   # ws://127.0.0.1:5544/pw
devbox-playwright stop       # tear down tunnel + tmux window
```

```ts
import { chromium } from 'playwright';
const browser = await chromium.connect(process.env.PW_WS_ENDPOINT);
```

Requires `bun` on the devbox. Env: `DEVBOX_HOST`, `DEVBOX_PW_PORT` (default
`5544`), `DEVBOX_PW_BROWSER` (`chromium` | `firefox` | `webkit`). First run
downloads the browser binary into `~/.devbox-playwright` on the box; later
starts are just the tmux window plus the tunnel.

For ad-hoc use (and so Claude Code can see what a page actually looks like),
`bin/devbox-shot` wraps the connect+navigate+screenshot dance:

```sh
devbox-shot shot https://example.com          # PNG path on stdout
devbox-shot shot https://example.com out.png
devbox-shot check https://example.com         # JSON: status, title, console errors, failed requests
```

It auto-starts the server + tunnel on first call. The companion skill at
`~/.claude/skills/devbox-browser/SKILL.md` teaches Claude when to reach for it
("screenshot the page", "did it render", "any console errors").

## macOS Tahoe — native window tiling

| Shortcut | Action |
| --- | --- |
| `Fn` + `Ctrl` + `F` | Fill (maximize, keeps menu bar + Dock visible) |
| `Ctrl` + `Cmd` + `F` | True fullscreen (dedicated Space, hides everything) |
| `Fn` + `Ctrl` + `←` / `→` / `↑` / `↓` | Snap to half |
| `Fn` + `Ctrl` + `C` | Center |
| `Fn` + `Ctrl` + `R` | Revert to original size |

## Secrets and per-machine config

Anything not safe to commit goes in `~/.extra` (gitignored). `.zshrc` sources it at the end if present:

```sh
# ~/.extra
export OPENAI_API_KEY=...
export GH_TOKEN=...
```

## Targets

```sh
make help       # list targets
make install    # symlink into $HOME
make uninstall  # remove symlinks
make brew       # brew bundle
make test       # shellcheck scripts/
```
