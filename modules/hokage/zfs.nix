{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.zfs;
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
      # Set the currently maximum allowed kernel package for ZFS here
      # Look for Kernel support on https://github.com/openzfs/zfs/releases
      # Look for ZFS version in nixpkgs on https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=zfs+linux_6_17
      default = pkgs.linuxKernel.packages.linux_6_17.kernel;
      description = "Maximum allowed kernel package vor ZFS";
      readOnly = true;
    };
    useUnstable = mkOption {
      type = types.bool;
      # Currently use unstable by default, because Kernel 6.16 got EOL and was removed from NixOS unstable
      default = true;
      description = "Use pkgs.zfs_unstable for zfs.package when true (otherwise use pkgs.zfs).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.zfs.autoScrub.enable = true;
    networking.hostId = cfg.hostId;

    # Use the latest kernel version possible for ZFS or the latest kernel
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    # Secure /boot mount point permissions to prevent world-accessible security hole
    fileSystems."/boot" = {
      options = [ "umask=0077" ];
    };

    boot = {
      # Set maximum ARC size to prevent the Early OOM from killing processes
      # https://wiki.nixos.org/wiki/ZFS#Tuning_Adaptive_Replacement_Cache_size
      kernelParams = [ "zfs.zfs_arc_max=${builtins.toString cfg.arcMax}" ];

      supportedFilesystems = [ "zfs" ];
      zfs.requestEncryptionCredentials = lib.mkIf cfg.encrypted true;
      zfs.package = if cfg.useUnstable then pkgs.zfs_unstable else pkgs.zfs;
      zfs.extraPools = [ cfg.poolName ];
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      /*
            initrd.network = {
              enable = true;
              postCommands = ''
                sleep 2
                zpool import -a;
              '';
            };
      */
      loader.grub.enable = false;
      /*
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
      */
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
