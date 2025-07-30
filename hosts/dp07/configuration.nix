# TU Laptop Arslan - Lenovo Yoga Pro 9i

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
    thunderbird
    webex
    discord
    gimp3
    ddev
  ];

  # https://wiki.nixos.org/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
    open = true;

    # production
    # latest
    # beta
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Use US keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";

  hokage = {
    hostName = "dp07";
    userLogin = "arslan";
    userNameLong = "Arslan Khurshid";
    userNameShort = "Arslan";
    userEmail = "arslan.khurshid@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "d322830e";
    };
  };
}
