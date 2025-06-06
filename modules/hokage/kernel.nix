{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hokage.kernel;
in
{
  # https://wiki.nixos.org/wiki/Linux_kernel
  options.hokage.kernel = {
    requirements = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of kernel packages required by various modules";
      example = [
        pkgs.linuxPackages_6_13
        pkgs.linuxPackages_6_14
      ];
    };

    maxVersion = lib.mkOption {
      type = lib.types.package;
      # Use the latest kernel by default
      default = pkgs.linuxPackages_latest.kernel;
      description = "Maximum allowed kernel version";
      # example = pkgs.linuxPackages_6_15;
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable automatic kernel selection based on requirements";
    };

    selectedKernel = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "The automatically selected kernel package (lowest from requirements)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Add max version to requirements list
    hokage.kernel.requirements = [ cfg.maxVersion ];

    # Calculate the lowest kernel version from all requirements
    hokage.kernel.selectedKernel =
      if cfg.requirements == [ ] then
        cfg.maxVersion
      else
        builtins.head (lib.sort (a: b: lib.versionOlder a.version b.version) cfg.requirements);

    # Apply the selected kernel
    boot.kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor cfg.selectedKernel);

    # Optional: Add some debugging info
    system.build.hokageKernelInfo = pkgs.writeText "hokage-kernel-info" ''
      Selected kernel: ${cfg.selectedKernel.kernel.version}
      Max allowed: ${cfg.maxVersion.kernel.version}
      All requirements: ${lib.concatStringsSep ", " (map (k: k.kernel.version) cfg.requirements)}
    '';
  };
}
