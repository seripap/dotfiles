#!/bin/sh

echo "Installing VIM Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# echo "Installing sshb0t"
# docker run -d --restart always \
#     --name sshb0t \
#     -v ${HOME}/.ssh/authorized_keys:/root/.ssh/authorized_keys \
#     r.j3ss.co/sshb0t --user seripap --keyfile /root/.ssh/authorized_keys

# echo "Linking vimrc"
# ln -s .vimrc $HOME/.vimrc

# echo "Linking .zshrc"
# ln -s .zshrc $HOME/.zshrc
