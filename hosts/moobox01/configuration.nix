# moobox01 Netcup server
{
  modulesPath,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/mixins/server-remote.nix
    ./disk-config.zfs.nix
  ];

  # Bootloader.
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot";
      }
    ];
  };

  boot.initrd.network = {
    enable = true;
    postCommands = ''
      sleep 2
      zpool import -a;
    '';
  };

  networking = {
    hostId = "dacdad01"; # needed for ZFS
    hostName = "moobox01";
    networkmanager.enable = true;

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [
        443 # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];
}
