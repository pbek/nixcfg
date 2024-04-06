# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

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

  # Virtual keyboard at login screen does not work in plasma6!
#  services.desktopManager.plasma6.enable = true;
#  services.xserver.displayManager.defaultSession = "plasmax11";

  services.xserver.desktopManager.plasma5.enable = true;

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

#  environment.systemPackages = with pkgs.kdePackages; [
  environment.systemPackages = with pkgs; [
    libsForQt5.kwalletmanager
    libsForQt5.plasma-systemmonitor
    libsForQt5.spectacle
    libsForQt5.ark
    libsForQt5.bluedevil
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.gwenview
    libsForQt5.okular
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-disks
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.kate

    onboard # On-screen keyboard
    google-chrome
  ];

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      # use "git diff --no-ext-diff" for creating patches!
      difftastic.enable = true;
      userName  = "Patrizio Bekerle";
      userEmail = "patrizio@bekerle.com";
      ignores = [ ".idea" ".direnv" ];
    };
  };

  # Touch screen gestures
  services.touchegg.enable = true;
}
