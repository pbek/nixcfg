# TU Thinkbook P52 Tobias

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
  ];

  # Search on https://search.nixos.org/packages?channel=unstable
  environment.systemPackages = with pkgs; [
    thunderbird
    digikam
    gimp
    kdePackages.kcalc
    php
    zoom-us
    wineWowPackages.waylandFull
  ];

  hardware.nvidia.prime = {
    sync.enable = true;

    # NVIDIA Quadro P2000
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  hokage = {
    hostName = "dp05";
    userLogin = "tgros";
    userNameLong = "Tobias Groß-Vogt";
    userNameShort = "Tobias";
    userEmail = "tobias.gross-vogt@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "dccada05";
      encrypted = true;
    };

    nvidia = {
      enable = true;
      packageType = "beta";
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      open = false;
      modesetting.enable = true;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    # LC_ALL = "de_AT.UTF-8";
    LC_ADDRESS = "de_AT.UTF-8";
    LC_COLLATE = "de_AT.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  services.xserver.xkb = lib.mkForce {
    layout = "us";
    variant = "intl";
  };

  # Console keyboard layout
  console.keyMap = lib.mkForce "us";

  # Makes it so the tty console has about the same layout as the one configured in the services.xserver options
  console.useXkbConfig = true;
}
