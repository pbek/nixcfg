{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.nvidia;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkDefault
    types
    ;
in
{
  options.hokage.nvidia = {
    enable = mkEnableOption "NVIDIA graphics support";
    open = mkEnableOption "Open NVIDIA drivers (NVIDIA open-gpu-kernel-modules)" // {
      default = true;
    };
    powerManagement.enable = mkEnableOption "NVIDIA power management" // {
      default = true;
    };
    modesetting.enable = mkEnableOption "NVIDIA DRM modesetting (required for some Wayland compositors, e.g. Sway)";
    # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix for available package types
    packageType = mkOption {
      type = types.enum [
        "stable"
        "latest"
        "beta"
        "production"
        "legacy_535"
        "legacy_470"
      ];
      default = "latest";
      description = "Type of NVIDIA driver package to use";
    };
    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Nvidia driver package to use (overrides packageType if set)";
    };
    maxKernelVersion = lib.mkOption {
      type = lib.types.package;
      # Set the currently maximum allowed kernel package for NVIDIA here
      # We had an issue with kernel 6.18 and the NVIDIA drivers, so we limit it to 6.17 for now
      # default = pkgs.linuxKernel.packages.linux_6_18.kernel;
      default = pkgs.linuxPackages_latest.kernel;
      description = "Maximum allowed kernel package vor NVIDIA";
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    # Use the latest kernel version possible for NVIDIA or the latest kernel
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    # https://wiki.nixos.org/wiki/nvidia
    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.nvidia.acceptLicense = true;
    hardware.graphics.enable = true;
    hardware.nvidia = {
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      open = mkDefault cfg.open;

      package = mkDefault (
        if cfg.package != null then
          cfg.package
        else
          config.boot.kernelPackages.nvidiaPackages.${cfg.packageType}
      );

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = mkDefault cfg.powerManagement.enable;

      # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
      modesetting.enable = mkDefault cfg.modesetting.enable;
    };
  };
}
