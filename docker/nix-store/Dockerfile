#
# Docker image to build and serve nix store
#
FROM nixos/nix:latest
WORKDIR /root/nixcfg
COPY ../.. .
RUN nix --extra-experimental-features "nix-command flakes" flake prefetch .#neptun
