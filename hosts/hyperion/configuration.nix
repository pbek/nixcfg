# Acer Aspire 5 Laptop

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ...
}:

{
  imports = [
    ./disk-config.zfs.nix
  ];

  hokage = {
    hostName = "hyperion";
    lowBandwidth = true;
    useGhosttyGtkFix = false;
    cache.sources = [ "home" ];

    zfs = {
      enable = true;
      hostId = "dbbfda01";
    };
  };
}
