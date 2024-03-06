{ config, pkgs, inputs, ... }:
{
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs.libsForQt5; [
    kwalletmanager
    plasma-systemmonitor
    kfind
    kontact
    akonadiconsole
    kleopatra
    kmail
    korganizer
    kaddressbook
    yakuake
    spectacle
    ark
    bluedevil
    dolphin
    dolphin-plugins
    gwenview
    kaccounts-integration
    kaccounts-providers
    ksshaskpass
    okular
    plasma-browser-integration
    plasma-disks
    plasma-nm
    plasma-pa
    plasma-vault
    kate
    kmail
    akonadi
    kdepim-runtime
    filelight
  ];
}
