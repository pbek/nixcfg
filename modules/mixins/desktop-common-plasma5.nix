{ config, pkgs, inputs, username, weztermFontSize, ... }:
{
  imports = [
    ./desktop-common.nix
  ];

  services.xserver.desktopManager.plasma5.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libsForQt5.kwalletmanager
    libsForQt5.plasma-systemmonitor
    libsForQt5.kfind
    libsForQt5.kontact
    libsForQt5.akonadiconsole
    libsForQt5.kleopatra
    libsForQt5.kmail
    libsForQt5.korganizer
    libsForQt5.kaddressbook
    libsForQt5.yakuake
    libsForQt5.spectacle
    libsForQt5.ark
    libsForQt5.bluedevil
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.gwenview
    libsForQt5.kaccounts-integration
    libsForQt5.kaccounts-providers
    libsForQt5.ksshaskpass
    libsForQt5.okular
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-disks
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.plasma-vault
  ];
}
