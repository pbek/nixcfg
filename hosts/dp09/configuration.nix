# TU Laptop Ruxandra - Lenovo ThinkBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  environment.systemPackages = with pkgs; [
    webex
  ];

  # https://wiki.nixos.org/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
    open = true;

    # production: version 550
    # latest: version 560
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    #    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    #    modesetting.enable = true;
  };

  hokage = {
    hostName = "dp09";
    userLogin = "ruxi";
    userNameLong = "Ruxandra-Ileana Gherman";
    userNameShort = "Ruxandra";
    userEmail = "r.gherman@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "e783460f";
    };
  };
}
