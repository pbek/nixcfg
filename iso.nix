# This module defines a small NixOS installation CD.
# https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
{

  ...
}:
{
  imports = [
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    ./modules/hokage
    # ./modules/mixins/jetbrains.nix
    # ./modules/mixins/virt-manager.nix
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
