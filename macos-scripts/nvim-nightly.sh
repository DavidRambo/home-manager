#!/bin/bash

cd
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
xattr -c nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
# ./nvim-macos-arm64/bin/nvim

# Script to install neovim nightly

# if [ ! -d $HOME/.local/neovim ];
# then
#     mkdir $HOME/.local/neovim
# fi

# cd ~/repos || mkdir ~/repos && cd ~/repos

# cd neovim || (git clone https://github.com/neovim/neovim.git && cd neovim)

# rm -r build/

# git pull

# make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim/"

# make install
