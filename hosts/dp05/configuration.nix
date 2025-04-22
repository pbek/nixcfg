# TU Thinkbook P52 Tobias

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.services.hokage) userLogin;
  inherit (config.services.hokage) userNameLong;
  inherit (config.services.hokage) userEmail;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/mixins/users.nix
    ../../modules/mixins/desktop.nix
    ../../modules/mixins/audio.nix
    ../../modules/mixins/jetbrains.nix
    ../../modules/mixins/openssh.nix
    ../../modules/mixins/remote-store-cache.nix
  ];

  networking = {
    hostName = "dp05";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  # Search on https://search.nixos.org/packages?channel=unstable
  environment.systemPackages = with pkgs; [
    thunderbird
    stable.digikam
    gimp
  ];

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
    open = false;

    # production
    # latest
    # beta
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    #    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    #    modesetting.enable = true;
  };

  services.hokage = {
    userLogin = "tgros";
    userNameLong = "Tobias Groß-Vogt";
    userNameShort = "Tobias";
    userEmail = "tobias.gross-vogt@tugraz.at";

    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
    waylandSupport = true;
    useEspanso = false;
    tugraz.enable = true;

    zfs = {
      enable = true;
      hostId = "dccada05";
      encrypted = true;
    };
  };
}
