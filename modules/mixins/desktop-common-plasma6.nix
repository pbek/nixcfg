{ config, pkgs, inputs, ... }:
{
  imports = [ ];

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    baloo
  ];

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

  # KDE PIM
  programs.kde-pim = {
    enable = true;
    merkuro = false;
    kmail = true;
    kontact = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    kwalletmanager
    plasma-systemmonitor
    kfind
    kleopatra
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
    filelight
  ];
}
