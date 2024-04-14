{ config, pkgs, inputs, ... }:
{
  services.displayManager.defaultSession = "plasmax11";

  imports = [
    ./desktop-common.nix
    ./desktop-common-plasma6.nix
    ./espanso-latest.nix
  ];
}
