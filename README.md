# nixcfg

[GitHub](https://github.com/pbek/nixcfg)

NixOS config

## Setup

Pick your hostname, you might find some inspiration [here](https://spaceplace.nasa.gov/review/switch-a-roo/planet_sizes.en.jpg).

Set your hostname and run the [install script](./install.sh):

```bash
# Start with a fresh NixOS installation in ~/Code/nixcfg
HOSTNAME=yourhostname bash <(curl -s https://raw.githubusercontent.com/pbek/nixcfg/main/install.sh)

# Initially build and switch to new configuration for host "yourhostname" after you adapted flake.nix and your configuration.nix
nix-shell -p git --run "sudo nixos-rebuild switch --flake .#yourhostname -L"
```

Afterward here are some useful commands:

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
# update just one flake (we need to set the github token so the API limit is not reached)
NIX_CONFIG="access-tokens = github.com=`cat ~/.secrets/github-token`" nix flake lock --update-input catppuccin
```

## Fix bootloader

If the UEFI "BIOS" gets corrupted and was reset, no NixOS EFI boot device will be found.
You can fix this with the following steps:

- boot [Ventoy](https://www.ventoy.net/) USB stick in **UEFI mode**
- start NixOS image
- load encrypted root partition with `gparted`

```bash
# as root
sudo su -

# mount encrypted root partition and boot partition
mount /dev/mapper/sda2_crypt /mnt
mount /dev/sda1 /mnt/boot

# install current flake including bootloader
cd /mnt/home/omega/Code/nixcfg
nixos-install --flake .#pluto

# reboot machine, "Linux Bootloader" should now be available in the UEFI boot menu
reboot
```
