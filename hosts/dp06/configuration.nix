# TU Thinkbook Shiva

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:
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

  hokage = {
    hostName = "dp06";
    userLogin = "vision";
    userNameLong = "Shiva Pouya";
    userNameShort = "Shiva";
    userEmail = "shiva.pouya@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "79a86a3b";
    };
  };
}
