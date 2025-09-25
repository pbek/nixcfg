# TU "Guest" HP EliteBook Laptop 840 G5

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
    ../../modules/hokage
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-0eda41dc-43e4-4a37-92ac-b33be4c24d4f".device =
    "/dev/disk/by-uuid/0eda41dc-43e4-4a37-92ac-b33be4c24d4f";

  environment.systemPackages = with pkgs; [
    thunderbird
    spotify
  ];

  hokage = {
    hostName = "dp01";
    userLogin = "dp";
    # userNameLong = "dp";
    # userNameShort = "dp";
    # userEmail = "dp@dp";

    # Temporary "owner" of this machine
    userNameLong = "Andrea Ortner";
    userNameShort = "Andrea";
    userEmail = "andrea.ortner@tugraz.at";

    tugraz.enableExternal = true;
  };
}
