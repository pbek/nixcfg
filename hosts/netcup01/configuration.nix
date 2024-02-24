# netcup02 Netcup server
{ modulesPath, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/mixins/server-remote.nix
      ./disk-config.zfs.nix
    ];

  # Bootloader.
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
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
    hostId = "dafdad01";  # needed for ZFS
    hostName = "netcup01";
    networkmanager.enable = true;

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        25    # SMTP
        80    # HTTP
        143   # IMAP
        443   # HTTPS
        587   # SMTP
        993   # IMAPS
        4190  # ManageSieve
        8883  # MQTT
      ];
      allowedUDPPorts = [
        443   # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];
}
