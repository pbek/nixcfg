{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.zfs;
  # Import only the EOL kernel from the pinned source; modules such as ZFS
  # are built by the current nixpkgs via the shared kernel selector.
  kernelPkgs = import inputs.nixpkgs-linux-7-2 {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (pkgs) config;
  };
  datasetRootPart =
    if cfg.datasetRootName != "" then
      "/${cfg.datasetRootName}"
    else
      (if cfg.encrypted then "/encrypted" else "");
  homeDataset = "${cfg.poolName}${datasetRootPart}/home";

  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.hokage.zfs = {
    enable = mkEnableOption "ZFS support";
    hostId = mkOption {
      type = types.str;
      description = "Host ID for ZFS, generate with 'just zfs-generate-host-id'";
    };
    poolName = mkOption {
      type = types.str;
      default = "zroot";
      description = "Name of your ZFS pool";
    };
    datasetRootName = mkOption {
      type = types.str;
      default = "";
      example = "root";
      description = "Name of the root dataset of the ZFS pool";
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
    maxKernelVersion = lib.mkOption {
      type = lib.types.package;
      # Temporary Linux 7.2 pin until ZFS supports 7.3; see https://github.com/openzfs/zfs/releases.
      default = kernelPkgs.linuxKernel.packages.linux_7_2.kernel;
      description = "Maximum allowed kernel package for ZFS";
      readOnly = true;
    };
    useUnstable = mkOption {
      type = types.bool;
      # Currently, stable is zfs 2.4.2
      default = false;
      description = "Use pkgs.zfs_unstable for zfs.package when true (otherwise use pkgs.zfs).";
    };
    devNodes = mkOption {
      type = types.str;
      default = "";
      example = "/dev/disk/by-path";
      description = ''
        Override boot.zfs.devNodes to control which directory ZFS scans for
        pool devices. Useful for VMs with virtio disks that do not reliably
        appear under /dev/disk/by-id (the ZFS default).  Leave empty to keep
        the ZFS default.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.zfs.autoScrub.enable = true;
    networking.hostId = cfg.hostId;

    # Use the latest kernel version possible for ZFS or the latest kernel
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    boot = {
      # Set maximum ARC size to prevent the Early OOM from killing processes
      # https://wiki.nixos.org/wiki/ZFS#Tuning_Adaptive_Replacement_Cache_size
      kernelParams = [ "zfs.zfs_arc_max=${builtins.toString cfg.arcMax}" ];

      supportedFilesystems = [ "zfs" ];
      zfs.requestEncryptionCredentials = lib.mkIf cfg.encrypted true;
      zfs.package = if cfg.useUnstable then pkgs.zfs_unstable else pkgs.zfs;
      zfs.devNodes = lib.mkIf (cfg.devNodes != "") cfg.devNodes;
      # Silence warning https://github.com/nix-community/disko/issues/1255
      zfs.forceImportRoot = true;
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
