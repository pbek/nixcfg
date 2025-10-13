# TU Laptop Arslan - Lenovo Yoga Pro 9i

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
    webex
    discord
    gimp3
    ddev
  ];

  # Use US keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";

  hokage = {
    hostName = "dp07";
    userLogin = "arslan";
    userNameLong = "Arslan Khurshid";
    userNameShort = "Arslan";
    userEmail = "arslan.khurshid@tugraz.at";
    tugraz.enableExternal = true;
    nvidia.enable = true;

    zfs = {
      enable = true;
      hostId = "d322830e";
    };
  };
}
