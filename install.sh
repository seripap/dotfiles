#!/bin/sh

echo "Installing AWS CLI"
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip"
unzip /tmp/awscli-bundle.zip -d /tmp
/tmp/awscli-bundle/install -b /usr/bin/aws
rm -rf /tmp/awscli-bundle*

# echo "Linking vimrc"
# ln -s .vimrc $HOME/.vimrc

# echo "Linking .zshrc"
# ln -s .zshrc $HOME/.zshrc
