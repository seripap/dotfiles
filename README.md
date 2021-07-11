# Dan's Dotfiles

### wa wa wee wa

## Dependencies

- fzf (autoloaded)
- [silver searcher](https://github.com/ggreer/the_silver_searcher) for Ag
- [rg](https://github.com/BurntSushi/ripgrep)
- diff-so-fancy (brew install diff-so-fancy)
- brew install ctags-exuberant

## How to

1. Create symlink
2. `:PlugInstall`
3. ...
4. Profit

```
$ git clone https://github.com/seripap/dotfiles
$ ln -s ~/dotfiles/.vimrc ~/.vimrc
$ ln -s ~/dotfiles/.gitconfig ~/.gitconfig
$ ln -s /Users/dseripap/dotfiles/coc-settings.json /Users/dseripap/.vim/coc-settings.json
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
- `<C-hjkl>` are mapped to `<C-w> <C-w> hjkl`
