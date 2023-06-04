#
# Docker image to build and serve nix store
#
FROM nixos/nix:latest
WORKDIR /root/nixcfg
COPY ../.. .
RUN nixos-rebuild switch --flake .#neptun -L
