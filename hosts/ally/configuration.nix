# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop-common-minimum.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/local-store-cache.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "ally";
    networkmanager.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    kwalletmanager
    plasma-systemmonitor
    spectacle
    ark
    bluedevil
    dolphin
    dolphin-plugins
    gwenview
    okular
    plasma-browser-integration
    plasma-disks
    plasma-nm
    plasma-pa
    kate
  ];

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
