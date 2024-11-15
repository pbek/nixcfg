#!/usr/bin/env bash

set -e

export HOST=caliban
sudo nix --experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode disko ./hosts/${HOST}/disk-config.zfs.nix
#sudo nix --experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --flake .#${HOST} --write-efi-entries
#sudo nix --experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --flake .#${HOST} --write-efi-boot-entries --disk main /dev/nvme1n1
#sudo nix run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake .#${HOST} --disk disk1 /dev/nvme1n1
sudo nixos-install --flake .#${HOST}

