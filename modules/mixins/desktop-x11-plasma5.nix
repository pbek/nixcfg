{ config, pkgs, inputs, ... }:
{
  imports = [
    ./desktop-common.nix
    ./desktop-common-plasma5.nix
  ];
}
