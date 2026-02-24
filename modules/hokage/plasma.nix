{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (config) hokage;
  inherit (hokage) useGraphicalSystem;
  inherit (hokage) waylandSupport;
  inherit (hokage) excludePackages;
  cfg = config.hokage.plasma;
in
{
  options.hokage.plasma = {
    enable = lib.mkEnableOption "KDE Plasma" // {
      default = useGraphicalSystem;
    };
    enableOld = lib.mkEnableOption "plasma with old KDE packages";
    enablePlasmaManager = lib.mkEnableOption "plasma-manager";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = lib.mkIf cfg.enableOld [
      (import ../../overlays/kde/kde-old.nix)
    ];

    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = if waylandSupport then "plasma" else "plasmax11";
    services.displayManager.plasma-login-manager.enable = cfg.enablePlasmaManager;
    services.displayManager.sddm.enable = lib.mkIf cfg.enablePlasmaManager false;

    # Launch SDDM in Wayland too
    # https://wiki.nixos.org/wiki/KDE#Launch_SDDM_in_Wayland_too
    services.displayManager.sddm.wayland.enable = lib.mkIf waylandSupport true;

    # KMail Renders Blank Messages
    # https://wiki.nixos.org/wiki/KDE#KMail_Renders_Blank_Messages
    environment.sessionVariables = lib.mkIf waylandSupport {
      NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (
        pkgs.lib.reverseList config.environment.profiles
      )}";
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      baloo
    ];

    # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
    # https://wiki.nixos.org/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
    programs.dconf.enable = true;

    # KDE PIM
    programs.kde-pim = {
      enable = true;
      merkuro = false;
      kmail = true;
      kontact = true;
    };

    environment.systemPackages =
      (lib.optionals (!waylandSupport) (with pkgs; [ xorg.xkill ]))
      ++ (lib.optionals waylandSupport (
        with pkgs;
        [
          # Add missing dependency for espanso
          wl-clipboard
        ]
      ))
      ++ (
        with pkgs.kdePackages;
        let
          requiredPackages = [
          ];
          optionalPackages = [
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
            kcolorchooser
          ];
        in
        requiredPackages ++ utils.removePackagesByName optionalPackages excludePackages
      );

    home-manager.users = lib.genAttrs hokage.users (_userName: {
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

      xdg.desktopEntries = lib.mkIf waylandSupport {
        ferdium-wayland = {
          name = "Ferdium Wayland";
          genericName = "Messaging Client";
          comment = "Desktop app bringing all your messaging services into one installable";
          icon = "ferdium";
          exec = "ferdium --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations";
          terminal = false;
          mimeType = [ "x-scheme-handler/ferdium" ];
          categories = [
            "Network"
            "InstantMessaging"
          ];
        };
      };
    });
  };
}
