#!/usr/bin/env bash

set -e

export HOST=caliban
sudo nix --experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode disko ./hosts/${HOST}/disk-config.zfs.nix
#sudo nix --experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --flake .#${HOST} --write-efi-entries
sudo nixos-install --flake .#${HOST}

