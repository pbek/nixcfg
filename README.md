# nixcfg

[GitHub](https://github.com/pbek/nixcfg)

NixOS config

## Setup

```bash
# set hostname
export HOSTNAME=pluto

# setup nixos configuration
cd /etc
sudo mv nixos nixos.bak
sudo nix-shell -p git --run 'git clone https://github.com/pbek/nixcfg.git nixos'
sudo chown omega:users nixos -R
cd nixos
mkdir hosts/${HOSTNAME}
cp ../nixos.bak/* hosts/${HOSTNAME}
ln -s hosts/${HOSTNAME}/configuration.nix
ln -s hosts/${HOSTNAME}/hardware-configuration.nix

# edit configuration.nix
kate . &

# switch to unstable channel and upgrade
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos && sudo nixos-rebuild switch --upgrade

# switch git remote to ssh
nix-shell -p git --run 'git remote set-url origin git@github.com:pbek/nixcfg.git'

# look at network load?
nix-shell -p nload --run 'nload enp0s25'

# login at ther computer and start the restic mount and restore

# take over tmux session at local system to watch restore
tmux new-session -A -s main

# after backup restore reboot computer
sudo reboot

# run backup script
```

In the end commit changes to https://github.com/pbek/nixcfg.


## Commands

```bash
# switch to unstable channel
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos && sudo nixos-rebuild switch --upgrade
```
