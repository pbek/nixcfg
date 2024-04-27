# Asus Rog Ally (using NixOS)

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disk-config.zfs.nix
      ../../modules/mixins/rog-ally.nix
    ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;
  boot.zfs.requestEncryptionCredentials = true;

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
    hostId = "decfda01";  # needed for ZFS, use: head -c4 /dev/urandom | od -A none -t x4
    hostName = "ally2";
    networkmanager.enable = true;
  };

  # Add the sanoid service to take snapshots of the ZFS datasets
  services.sanoid = {
    enable = true;
    templates = {
      hourly = {
        autoprune = true;
        autosnap = true;
        daily = 7;
        hourly = 24;
        monthly = 0;
      };
    };
    datasets = {
      "zroot/encrypted/home" = {
        useTemplate = ["hourly"];
      };
    };
  };

  # Enable Tailscale VPN
  # Use `sudo tailscale up --accept-routes` to connect to the VPN
  services.tailscale.enable = true;
}
