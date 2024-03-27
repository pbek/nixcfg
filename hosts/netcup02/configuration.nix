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
    hostId = "dafdad02";  # needed for ZFS
    hostName = "netcup02";
    networkmanager.enable = true;

    # ssh is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [ 25 ]; # SMTP
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  # Add the sanoid service to take snapshots of the ZFS datasets
  services.sanoid = {
    enable = true;
    templates = {
      hourly = {
        autoprune = true;
        autosnap = true;
        daily = 14;
        hourly = 24;
        monthly = 0;
      };
    };
    datasets = {
      "zpool/home" = {
        useTemplate = ["hourly"];
      };
      "zpool/docker" = {
        useTemplate = ["hourly"];
      };
    };
  };
}
