{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.zfs;
  encryptedPart = if cfg.encrypted then "/encrypted" else "";
  homeDataset = "${cfg.poolName}${encryptedPart}/home";

  inherit (lib)
    mkDefault
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.hokage.zfs = {
    enable = mkEnableOption "Enable ZFS support";
    hostId = mkOption {
      type = types.str;
      description = "Host ID for ZFS, generate with 'just zfs-generate-host-id'";
    };
    poolName = mkOption {
      type = types.str;
      default = "zroot";
      description = "Name of your ZFS pool";
    };
    encrypted = mkOption {
      type = types.bool;
      default = true;
      description = "Define if the ZFS datasets are encrypted";
    };
    arcMax = mkOption {
      type = types.int;
      default = 1536 * 1024 * 1024; # 1.5GB
      description = "Maximum size of ARC (Adaptive Replacement Cache) in bytes";
    };
  };

  config = lib.mkIf cfg.enable {
    services.zfs.autoScrub.enable = true;
    networking.hostId = cfg.hostId;

    boot = {
      # Use the latest kernel version possible for ZFS or the latest kernel
      kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_6_13;

      # Set maximum ARC size to prevent the Early OOM from killing processes
      # https://nixos.wiki/wiki/ZFS#Tuning_Adaptive_Replacement_Cache_size
      kernelParams = [ "zfs.zfs_arc_max=${builtins.toString cfg.arcMax}" ];

      supportedFilesystems = [ "zfs" ];
      zfs.requestEncryptionCredentials = lib.mkIf cfg.encrypted true;
      # zfs.package = pkgs.zfs_unstable;
      initrd.network = {
        enable = true;
        postCommands = ''
          sleep 2
          zpool import -a;
        '';
      };
      loader.grub = {
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
        ${homeDataset} = {
          useTemplate = [ "hourly" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      httm # CLI Time Machine
    ];
  };
}
