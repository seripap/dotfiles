# dotfiles

Dan's daily driver.

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
| `.zshrc` | Shell config — PATH, history, aliases, fzf, pure prompt, zoxide, `ask` |
| `.vimrc` | Neovim config — plugins via vim-plug, Go/JS/TS, oceanic-next |
| `.gitconfig` | Git aliases, diff-so-fancy + difft, SSH commit signing |
| `.gitignore` | Global gitignore (referenced by `.gitconfig`) |
| `coc-settings.json` | coc.nvim language server settings |
| `.claude/CLAUDE.md` | Claude Code agent profile (preferences, house style, workflow rules) |
| `bin/` | Personal scripts on `$PATH` |
| `Brewfile` | Homebrew dependencies (`brew bundle`) |
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
