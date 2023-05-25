# nixcfg

[GitHub](https://github.com/pbek/nixcfg)

NixOS config

## Setup

Set your hostname and run the [install script](./install.sh):

```bash
HOSTNAME=yourhostname bash <(curl -s https://raw.githubusercontent.com/pbek/nixcfg/main/install.sh)
```

Afterwards here are some useful commands:

```bash
# Build and switch to new configuration
make switch

# edit configuration.nix
kate . &

# check for Nvidia card
nix-shell -p pciutils --run 'lspci | grep VGA'

# look at network load and other stats?
nix-shell -p btop --run btop

# login at another computer and start the restic mount and restore

# take over tmux session at local system to watch restore
tmux new-session -A -s main

# after backup restore reboot computer
sudo reboot

# run backup script
```

In the end commit changes to https://github.com/pbek/nixcfg.

## Secrets

### Rekey after adding new host

This needs to be done if hosts were added.

- run `ssh-keyscan localhost` on new host
- add those keys to `./secrets/secret.nix`
- run `cd ./secrets && agenix -i ~/.ssh/agenix --rekey` to rekey all keys

### Add secret

```bash
cd ./secrets && agenix -i ~/.ssh/agenix -e secret-file.age
```

## Commands

```bash
# switch to unstable channel
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos && sudo nixos-rebuild switch --upgrade
```
