#!/usr/bin/env bash

set -e

NIXOS_DIR_NAME=nixcfg

# Check if HOSTNAME is set
if [[ -z "$HOSTNAME" ]]; then
    echo "HOSTNAME is not set!"
    exit 1
fi

echo "HOSTNAME is set to $HOSTNAME."

# Create directory ~/Code, if it doesn't exist
if [ ! -d ~/Code ]; then
    mkdir ~/Code
fi

echo ""
echo "Cloning nixcfg and copying initial config..."
cd ~/Code

if [ -d ${NIXOS_DIR_NAME} ]; then
    echo "Directory ${NIXOS_DIR_NAME} already exists!"
    exit 1
fi

nix-shell -p git --run 'git clone --recurse-submodules https://github.com/pbek/nixcfg.git ${NIXOS_DIR_NAME}'
cd ${NIXOS_DIR_NAME}
mkdir hosts/${HOSTNAME}
cp /etc/nixos/configuration.nix hosts/${HOSTNAME}
cp /etc/nixos/hardware-configuration.nix hosts/${HOSTNAME}

echo ""
echo "Switching to unstable channel..."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos

echo ""
echo "Switching to ssh git remote..."
nix-shell -p git --run 'git remote set-url origin git@github.com:pbek/nixcfg.git'

echo ""
echo "Now edit 'flakes.nix' and add your host and 'hosts/${HOSTNAME}/configuration.nix' to style it like the rest of the hosts."

