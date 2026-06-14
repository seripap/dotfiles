.PHONY: help install uninstall brew test

DOTFILES := $(shell pwd)
HOME_FILES := .zshrc .vimrc .gitconfig .gitignore

help:
	@echo "Available targets:"
	@echo "  install    Symlink dotfiles into \$$HOME"
	@echo "  uninstall  Remove dotfile symlinks from \$$HOME"
	@echo "  brew       Install dependencies from Brewfile"
	@echo "  test       Lint shell files with shellcheck"

install:
	@for f in $(HOME_FILES); do \
		if [ -e "$$HOME/$$f" ] && [ ! -L "$$HOME/$$f" ]; then \
			echo "skip $$f (exists, not a symlink) — back it up and rerun"; \
		else \
			ln -sfn "$(DOTFILES)/$$f" "$$HOME/$$f" && echo "link $$f"; \
		fi; \
	done
	@mkdir -p "$$HOME/.config/coc"
	@ln -sfn "$(DOTFILES)/coc-settings.json" "$$HOME/.config/coc/coc-settings.json" && echo "link coc-settings.json"
	@mkdir -p "$$HOME/.ssh" && chmod 700 "$$HOME/.ssh"
	@if [ -e "$$HOME/.ssh/config" ] && [ ! -L "$$HOME/.ssh/config" ]; then \
		echo "skip .ssh/config (exists, not a symlink) — fold hosts into ~/.ssh/config.local, then rerun"; \
	else \
		ln -sfn "$(DOTFILES)/.ssh/config" "$$HOME/.ssh/config" && echo "link .ssh/config"; \
	fi
	@mkdir -p "$$HOME/.claude"
	@for f in CLAUDE.md settings.json; do \
		if [ -e "$$HOME/.claude/$$f" ] && [ ! -L "$$HOME/.claude/$$f" ]; then \
			echo "skip .claude/$$f (exists, not a symlink) — back it up and rerun"; \
		else \
			ln -sfn "$(DOTFILES)/.claude/$$f" "$$HOME/.claude/$$f" && echo "link .claude/$$f"; \
		fi; \
	done
	@defaults write -g InitialKeyRepeat -int 15 && echo "set InitialKeyRepeat=15 (log out + back in to apply)"

uninstall:
	@for f in $(HOME_FILES); do \
		if [ -L "$$HOME/$$f" ]; then \
			rm "$$HOME/$$f" && echo "unlink $$f"; \
		fi; \
	done
	@if [ -L "$$HOME/.config/coc/coc-settings.json" ]; then \
		rm "$$HOME/.config/coc/coc-settings.json" && echo "unlink coc-settings.json"; \
	fi
	@if [ -L "$$HOME/.ssh/config" ]; then \
		rm "$$HOME/.ssh/config" && echo "unlink .ssh/config"; \
	fi
	@for f in CLAUDE.md settings.json; do \
		if [ -L "$$HOME/.claude/$$f" ]; then \
			rm "$$HOME/.claude/$$f" && echo "unlink .claude/$$f"; \
		fi; \
	done

brew:
	brew bundle --file=Brewfile

test:
	shellcheck scripts/*.sh
