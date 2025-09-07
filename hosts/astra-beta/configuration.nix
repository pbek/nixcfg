# Astra Beta TUG VM

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
  ];

  services.kmscon.enable = false;

  hokage = {
    hostName = "astra-beta";
    espanso.enable = false; # Host will already use espanso
    waylandSupport = false; # Disable Wayland support for clipboard sharing from guest to host
    termFontSize = 16.0;
    zfs = {
      enable = true;
      hostId = "6194bc24";
      encrypted = true;
    };
    virtManager.role = "guest";
    cache.sources = [ "home" ];
    # cache.sources = [ "caliban" ];
  };
}
