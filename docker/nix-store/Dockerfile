#
# Docker image to build and serve nix store
#
FROM nixos/nix:latest
# RUN nix-shell -p git --run 'git clone --depth 1 --recurse-submodules https://github.com/pbek/nixcfg.git /root/nixcfg'
# WORKDIR /root/nixcfg
# RUN nix --extra-experimental-features "nix-command flakes" flake prefetch .#neptun
RUN nix --extra-experimental-features "nix-command flakes" flake show github:pbek/nixcfg
RUN nix --extra-experimental-features "nix-command flakes" run github:pbek/nixcfg#neptun
