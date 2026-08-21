# Mercury Home01 VM

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

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
    termFontSize = 16.0;
    zfs = {
      enable = true;
      hostId = "29a6f1f7";
      encrypted = true;
      devNodes = "/dev/disk/by-path";
      useSystemdInitrd = true;
    };
    programs.libvirt.role = "guest";
    cache.sources = [ "home" ];
  };
}
