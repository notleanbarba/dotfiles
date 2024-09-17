#!/bin/bash

CONFIG=$HOME/.config

apps=("nvim:1:d:$CONFIG/nvim" "alacritty:2:d:$CONFIG/alacritty:x:d:/mnt/c/Users/leanb/AppData/Roaming/alacritty" "tmux:1:f:$HOME/.tmux.conf:tmux.conf" "zsh:1:f:$HOME/.zshrc:zshrc")

# Delete old configs
echo "Deleting old configs"
for app in ${apps[@]}; do
    explode=(${app//:/ })
    for (( i=0; i<${explode[1]}; i++ )); do
        if [ -${explode[$((2+i*3))]} ${explode[$((3+i*3))]} ] ; then
            echo "Old config found: ${explode[0]} -> ${explode[$((3+i*3))]}. Removing..."
            rm -rf ${explode[$((3+i*3))]}
        fi
    done
done

# Install configs
echo "Installing configs"
for app in ${apps[@]}; do
    explode=(${app//:/ })

    if [ ${explode[2]} == 'd' ]; then
        cp -rs $PWD/${explode[0]} ${explode[3]}
        echo "Successful config [folder]: ${explode[0]}"
    fi

    if [ ${explode[2]} == 'f' ]; then
        cp -rs $PWD/${explode[0]}/${explode[4]} ${explode[3]}
        echo "Successful config [file]: ${explode[0]}"
    fi
done

# Install windows configs
if [ $(systemd-detect-virt) == 'wsl' ];then
    echo "WSL instance detected"
    mkdir /mnt/c/Users/leanb/AppData/Roaming/alacritty
    cp $PWD/alacritty/windows.toml /mnt/c/Users/leanb/AppData/Roaming/alacritty/alacritty.toml
    echo "Successful config [file]: alacritty for windows"
fi
