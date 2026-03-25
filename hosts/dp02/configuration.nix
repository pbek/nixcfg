# TU ThinkBook Manuel

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:
{
  imports = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hokage = {
    hostName = "dp02";
    memory-swap.enable = false;
    userLogin = "mkocher";
    userNameLong = "Manuel Kocher";
    userNameShort = "Manuel";
    tugraz.enableExternal = true;
    excludePackages = with pkgs; [
      qownnotes
      qc
    ];
    userEmail = "manuel.kocher@tugraz.at";
    nvidia.enable = true;
  };
}
