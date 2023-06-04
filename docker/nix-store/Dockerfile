#
# Docker image to build and serve nix store
#
FROM nixos/nix:latest
WORKDIR /root/nixcfg
COPY ../.. /root/nixcfg
RUN pwd
RUN find /root/nixcfg
RUN nix --extra-experimental-features "nix-command flakes" flake prefetch .#neptun
