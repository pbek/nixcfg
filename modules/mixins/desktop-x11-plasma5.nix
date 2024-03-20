{ config, pkgs, inputs, ... }:
{
  imports = [
    ./desktop-common.nix
    ./desktop-common-plasma5.nix
  ];

  # You seem to need to set the default pinentry if you ar using X11 with Plasma5
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
}
