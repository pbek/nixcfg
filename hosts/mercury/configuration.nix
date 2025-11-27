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
    ./disk-config.zfs.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  services.kmscon.enable = false;

  hokage = {
    hostName = "mercury";
    programs.espanso.enable = false; # Host will already use espanso
    # waylandSupport = false; # Disable Wayland support for clipboard sharing from guest to host
    waylandSupport = true;
    termFontSize = 16.0;
    zfs = {
      enable = true;
      hostId = "29a6f1f7";
      encrypted = true;
    };
    programs.libvirt.role = "guest";
    cache.sources = [ "home" ];
  };
}
