# TU Thinkbook Andrea

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.hokage) userLogin;
  inherit (config.hokage) userNameLong;
  inherit (config.hokage) userEmail;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  networking = {
    hostName = "dp03";
  };

  environment.systemPackages = with pkgs; [
    thunderbird
    spotify
    inkscape
  ];

  programs.evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
  };

  hokage = {
    userLogin = "dp";
    userNameLong = "Andrea Ortner";
    userNameShort = "Andrea";
    userEmail = "andrea.ortner@tugraz.at";

    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
    waylandSupport = true;
    espanso.enable = false;
    tugraz.enable = true;
    tugraz.enableOrca = true;
    jetbrains.phpstorm.enable = true;

    zfs = {
      enable = true;
      hostId = "dccada03";
      poolName = "calroot";
    };
  };
}
