# Acer Aspire 5 Laptop

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/mixins/common.nix
    ../../modules/mixins/virt-manager.nix
  ];

  networking = {
    hostName = "hyperion";
    networkmanager.enable = true;
  };

  hokage = {
    jetbrains.useStable = true;
    useGhosttyGtkFix = false;
    cache.sources = [ "home" ];

    zfs = {
      enable = true;
      hostId = "dbbfda01";
    };
  };
}
