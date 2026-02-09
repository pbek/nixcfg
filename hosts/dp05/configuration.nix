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
    usb-modeswitch
    usbutils
    superTuxKart
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
  # End Steam

  # Logitech G923
  # boot.kernelModules = [ "hid-logitech-hidpp" ];

  # services.udev.extraRules = ''
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c26d", RUN+="/bin/sh -c 'echo 046d # # c26d > /sys/bus/hid/drivers/logitech-hidpp-device/new_id || true'"
  # '';

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", \
    ATTR{idVendor}=="046d", ATTR{idProduct}=="c26d", \
    RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c26d -m 01 -r 01 -C 0x03 -M 0f00010142"
  '';

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
      # "production" currently is at 580, that's the last release that supports the Quadro P2000
      # If that ever changes, we might need to switch to "legacy_535"
      packageType = "production";
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
