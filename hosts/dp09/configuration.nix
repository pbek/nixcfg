# TU Laptop Ruxandra - Lenovo ThinkBook

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
    backintime
    webex
  ];

  hokage = {
    hostName = "dp09";
    userLogin = "ruxi";
    userNameLong = "Ruxandra-Ileana Gherman";
    userNameShort = "Ruxandra";
    userEmail = "r.gherman@tugraz.at";
    tugraz.enableExternal = true;
    nvidia.enable = true;

    zfs = {
      enable = true;
      hostId = "e783460f";
    };
  };
}
