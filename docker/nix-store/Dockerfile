#
# Docker image to build and serve nix store
#
FROM nixos/nix:latest
RUN nix-shell -p git --run 'git clone --recurse-submodules https://github.com/pbek/nixcfg.git /root/nixcfg'
WORKDIR /root/nixcfg
RUN nix --extra-experimental-features "nix-command flakes" flake prefetch .#neptun
