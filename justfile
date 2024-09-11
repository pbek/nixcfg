# Use `just <recipe>` to run a recipe
# https://just.systems/man/en/

# By default, run the `--choose` command
default:
  @just --choose

# Set default shell to bash
set shell := ["bash", "-c"]

# Variables
hostname := `hostname`
user := `whoami`

test:
    sudo nixos-rebuild test --flake .#{{hostname}} -L

nix-switch:
    sudo nixos-rebuild switch --flake .#{{hostname}} -L

# Build and switch to the new configuration for the current host
switch:
    nix-shell --run "nh os switch -H {{hostname}} ."

nix-build:
    sudo nixos-rebuild build --flake .#{{hostname}}

_build hostname:
    nix-shell --run "nh os build -H {{hostname}} ."

build: (_build hostname)

# Build the current host on the Caliban host
build-on-caliban:
    nixos-rebuild --build-host omega@caliban.netbird.cloud --flake .#{{hostname}} build

# TODO: "--build-host" not found
nh-build-on-caliban:
    nix-shell --run "nh os build -H {{hostname}} . -- --build-host omega@caliban.netbird.cloud"

# Build the current host on the Home01 host
build-on-home01:
    nixos-rebuild --build-host omega@home01.lan --flake .#{{hostname}} build

# TODO: "--build-host" not found
nh-build-on-home01:
    nix-shell --run "nh os build -H {{hostname}} . -- --build-host omega@home01.lan"

switch-push: switch && push

switch-push-all:
  switch
  push-all
  push

# Update the flakes
update:
    NIX_CONFIG="access-tokens = github.com=`cat ~/.secrets/github-token`" nix flake update

# Update the flakes and switch to the new configuration
upgrade: update && switch

upgrade-push: upgrade && push

upgrade-push-all:
  upgrade
  push-all
  push

push:
    attic push main `which espanso` && \
    attic push qownnotes `which qownnotes` && \
    attic push qownnotes `which qc`

push-all:
    ./scripts/push-all-to-attic.sh

push-local:
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which phpstorm` && \
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which clion` && \
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which goland`

[group('agenix')]
rekey-fallback:
    cd ./secrets && agenix -i ~/.ssh/agenix --rekey

# Rekey the agenix secrets
[group('agenix')]
rekey:
    cd ./secrets && agenix --rekey

# Show ssh keys for agenix
[group('agenix')]
keyscan:
    ssh-keyscan localhost

build-iso:
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

boot-iso:
    nix-shell -p qemu --run "qemu-system-x86_64 -m 256 -cdrom result/iso/nixos-*.iso"

boot-vm:
    QEMU_OPTS="-m 4096 -smp 4 -enable-kvm" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

boot-vm-no-kvm:
    QEMU_OPTS="-m 4096 -smp 4" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

boot-vm-console:
    QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

boot-vm-server-console:
    QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:2222" ./result/bin/run-*-vm

ssh-vm-server:
    ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

# Reset the VM
[confirm("Are you sure you want to reset the VM?")]
reset-vm:
    rm *.qcow2

ssh-vm:
    ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

build-vm-desktop:
    nixos-rebuild --flake .#vm-desktop build-vm

build-vm-server:
    nixos-rebuild --flake .#vm-server build-vm

build-vm-netcup02:
    nixos-rebuild --flake .#vm-netcup02 build-vm

flake-rebuild-current:
    sudo nixos-rebuild switch --flake .#{{hostname}}

flake-update:
    nix flake update

# Clean up the system to free up space
[confirm("Are you sure you want to clean up the system?")]
cleanup:
    duf && \
    sudo journalctl --vacuum-time=3d && \
    docker system prune -f && \
    rm -rf ~/.local/share/Trash/* && \
    sudo nix-collect-garbage -d && \
    nix-collect-garbage -d && \
    duf

# Repair the nix store
repair-store:
    sudo nix-store --verify --check-contents --repair

# List the generations
list-generations:
    nix profile history --profile /nix/var/nix/profiles/system

# Garbage collect the nix store to free up space
optimize-store:
    duf && \
    nix store optimise && \
    duf

# Do firmware updates
fwup:
    -fwupdmgr refresh
    fwupdmgr update

# Open a terminal with the nixcfg session
term:
    zellij --layout term.kdl attach nixcfg -c

# Kill the nixcfg session
term-kill:
    zellij delete-session nixcfg -f

# Replace the current fish shell with a new one
fish-replace:
    exec fish

linter-check:
    statix check

linter-fix:
    statix fix

update-channels:
    sudo nix-channel --update

fix-command-not-found-error: update-channels

nix-build-venus:
    nixos-rebuild --flake .#venus build

# Build the Venus host
build-venus: (_build "venus")

home-manager-logs:
    sudo journalctl --since today | grep "hm-activate-" | bat

home-manager-status:
    systemctl status home-manager-{{user}}.service

home01-restart-nix-serve:
    systemctl restart nix-serve

# Edit the QOwnNotes build file
[group('qownnotes')]
edit-qownnotes-build:
    kate ./apps/qownnotes/default.nix -l 23 -c 19

# Run a fish shell with all needed tools
shell:
    nix-shell --run fish

# Get the nix hash of a QOwnNotes release
[group('qownnotes')]
qownnotes-hash:
    #!/usr/bin/env bash
    set -euxo pipefail
    version=$(gum input --placeholder "QOwnNotes version number")
    url="https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz"
    nix-prefetch-url "$url" | xargs nix hash to-sri --type sha256

# Update the QOwnNotes release in the app
[group('qownnotes')]
qownnotes-update-release:
    ./scripts/update-qownnotes-release.sh

# Get the reverse dependencies of a nix store path
nix-store-reverse-dependencies:
    #!/usr/bin/env bash
    set -euxo pipefail
    nixStorePath=$(gum input --placeholder "Nix store path (e.g. /nix/store/hbldxn007k0y5qidna6fg0x168gnsmkj-botan-2.19.5.drv)")
    nix-store --query --referrers "$nixStorePath"
