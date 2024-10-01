{ config, pkgs, inputs, username, ... }:
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

  home-manager.users.${username} = {
    # https://github.com/nix-community/plasma-manager/blob/trunk/examples/home.nix
    programs.plasma = {
      enable = true;

      shortcuts = {
        # ~/.config/kglobalshortcutsrc
        kwin = {
          "Expose" = "Meta+,";
          "Switch to Desktop 1" = "Meta+1";
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Switch to Desktop 4" = "Meta+4";
          "Window Move Center" = "Meta+C";
          "Window to Next Screen" = "Meta+Shift+Right";
          "Window to Previous Screen" = "Meta+Shift+Left";
          "Window On All Desktops" = "Meta+A";
          "Window Quick Tile Right" = "Meta+Right";
          "Window Quick Tile Left" = "Meta+Left";
          "Window Quick Tile Top" = "Meta+Up";
          "Window Quick Tile Bottom" = "Meta+Down";
          "Window Maximize" = "Meta+PgUp";
        };
      };
    };
  };
}
