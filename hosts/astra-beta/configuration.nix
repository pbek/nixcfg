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
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  hokage = {
    hostName = "astra-beta";
    espanso.enable = false; # App-specific configurations are not yet supported in Wayland on caliban for VirtualBox!
    # waylandSupport = false;
    termFontSize = 16.0;
    # cache.sources = [ "caliban" ];
    zfs = {
      enable = true;
      hostId = "6194bc24";
      encrypted = true;
    };
    cache.sources = [ "home" ];
  };
}
