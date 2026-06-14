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
| `.zshrc` | Shell config — PATH, history, aliases, fzf, pure prompt, z-jump |
| `.vimrc` | Neovim config — plugins via vim-plug, Go/JS/TS, oceanic-next |
| `.gitconfig` | Git aliases, diff-so-fancy + difft, SSH commit signing |
| `.gitignore` | Global gitignore (referenced by `.gitconfig`) |
| `coc-settings.json` | coc.nvim language server settings |
| `scripts/z.sh` | [rupa/z](https://github.com/rupa/z) directory jumper |
| `bin/` | Personal scripts on `$PATH` |
| `Brewfile` | Homebrew dependencies (`brew bundle`) |
| `Makefile` | `install`, `uninstall`, `brew`, `test` targets |

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
