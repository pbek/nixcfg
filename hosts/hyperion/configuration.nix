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
    ../../modules/mixins/users.nix
    ../../modules/mixins/desktop.nix
    ../../modules/mixins/audio.nix
    ../../modules/mixins/jetbrains.nix
    ../../modules/mixins/openssh.nix
    ../../modules/mixins/virt-manager.nix
    ../../modules/mixins/local-store-cache.nix
  ];

  networking = {
    hostName = "hyperion";
    networkmanager.enable = true;
  };

  services.hokage = {
    useStableJetbrains = true;
    useGhosttyGtkFix = false;

    zfs = {
      enable = true;
      hostId = "dbbfda01";
    };
  };
}
