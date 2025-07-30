# TU Thinkbook Andrea

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
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

  environment.systemPackages = with pkgs; [
    thunderbird
    spotify
    inkscape
  ];

  programs.evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
  };

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # Access from Andrea's Windows laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsfSls4gUUD037GUdVCETkkBBW1+MVFY2Q/vnt6AVeF tugraz\krautfleckerl@vpu-nb-99"
    ];
  };

  hokage = {
    hostName = "dp03";
    userLogin = "dp";
    userNameLong = "Andrea Ortner";
    userNameShort = "Andrea";
    userEmail = "andrea.ortner@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "dccada03";
      poolName = "calroot";
    };
  };
}
