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

uninstall:
	@for f in $(HOME_FILES); do \
		if [ -L "$$HOME/$$f" ]; then \
			rm "$$HOME/$$f" && echo "unlink $$f"; \
		fi; \
	done
	@if [ -L "$$HOME/.config/coc/coc-settings.json" ]; then \
		rm "$$HOME/.config/coc/coc-settings.json" && echo "unlink coc-settings.json"; \
	fi

brew:
	brew bundle --file=Brewfile

test:
	shellcheck scripts/*.sh
