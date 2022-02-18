# Dan's Dotfiles

Should work decently with vim and nvim.

## Dependencies

- fzf (autoloaded)
- [silver searcher](https://github.com/ggreer/the_silver_searcher) for Ag
- [rg](https://github.com/BurntSushi/ripgrep)
- diff-so-fancy (brew install diff-so-fancy)
- brew install ctags-exuberant

## How to

TODO: make an autoinstaller...

1. Create symlink
2. `:PlugInstall`
3. ...
4. Profit

```
$ git clone https://github.com/seripap/dotfiles
$ ln -s ~/dotfiles/.gitconfig ~/.gitconfig
# VIM
$ ln -s ~/dotfiles/.vimrc ~/.vimrc
# NVIM
$ ln -s ~/dotfiles/.vimrc ~/.config/nvim/init.vim
$ ln -s ~/dotfiles/lua/lsp-autocomplete.lua ~/.config/nvim/lua/lsp-autocomplete.lua
$ ln -s ~/dotfiles/lua/lsp-config.lua ~/.config/nvim/lua/lsp-config.lua
```

### .zshrc
```
if type rg &> /dev/null; then
   export FZF_DEFAULT_COMMAND='rg --files --hidden'
   export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
```

### Notes

- `<C-wsad>` are mapped to `hjkl`, because small keyboards
- Credits go to [jessfraz](https://github.com/jessfraz/.vim) for a bunch of the plugin configs
