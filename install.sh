#!/bin/sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# echo "Linking vimrc"
# ln -s .vimrc $HOME/.vimrc

# echo "Linking .zshrc"
# ln -s .zshrc $HOME/.zshrc
