{ config, pkgs, inputs, ... }:
{
  imports = [
#    ./kmail-fix.nix
  ];

  services.desktopManager.plasma6.enable = true;

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    kwalletmanager
    plasma-systemmonitor
    kfind
    kontact
    akonadiconsole
    kleopatra
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
#    # Fall back to Qt5
    kmail
    akonadi
    kdepim-runtime
    filelight
  ];
}
