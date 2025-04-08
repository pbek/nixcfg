{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.services.hokage) zfs;
  encryptedPart = if zfs.encrypted then "/encrypted" else "";
  homeDataset = "${zfs.poolName}${encryptedPart}/home";
in
{
  # Bootloader.
  boot.supportedFilesystems = lib.mkIf zfs.enable [ "zfs" ];
  services.zfs.autoScrub.enable = lib.mkIf zfs.enable true;
  boot.zfs.requestEncryptionCredentials = lib.mkIf (zfs.enable && zfs.encrypted) true;

  # boot.zfs.package = lib.mkIf zfs.enable pkgs.zfs_unstable;

  # Use the latest kernel version possible for ZFS or the latest kernel
  boot.kernelPackages = lib.mkDefault (
    if zfs.enable then pkgs.linuxKernel.packages.linux_6_13 else pkgs.linuxPackages_latest
  );
  networking.hostId = lib.mkIf (zfs.enable && zfs.hostId != "") zfs.hostId;

  boot.initrd.network = lib.mkIf zfs.enable {
    enable = true;
    postCommands = ''
      sleep 2
      zpool import -a;
    '';
  };

  boot.loader.grub = lib.mkIf zfs.enable {
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

  # Add the sanoid service to take snapshots of the ZFS datasets
  services.sanoid = lib.mkIf zfs.enable {
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
      ${homeDataset} = {
        useTemplate = [ "hourly" ];
      };
    };
  };
}
