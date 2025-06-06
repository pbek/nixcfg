{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.hokage;

  inherit (lib)
    mkOption
    types
    literalExpression
    ;
in
{
  imports = [
    ../common.nix
    ./atuin.nix
    ./audio.nix
    ./cache.nix
    ./desktop-minimum.nix
    ./desktop.nix
    ./espanso.nix
    ./gaming.nix
    ./ghostty.nix
    ./git.nix
    ./jetbrains.nix
    ./kernel.nix
    ./openssh.nix
    ./platformio.nix
    ./qtcreator.nix
    ./rog-ally.nix
    ./server-home.nix
    ./server-remote.nix
    ./server.nix
    ./starship.nix
    ./tugraz.nix
    ./virt-manager.nix
    ./virtualbox.nix
    ./zfs.nix
  ];

  options = {
    hokage = {
      role = mkOption {
        type = types.enum [
          "desktop"
          "server-home"
          "server-remote"
          "ally"
        ];
        default = "desktop";
        description = "Role of the system";
      };
      useInternalInfrastructure = mkOption {
        type = types.bool;
        default = true;
        description = "Use internal infrastructure of omega";
      };
      useSecrets = mkOption {
        type = types.bool;
        default = true;
        description = "Use secrets handling of omega";
      };
      useSharedKey = mkOption {
        type = types.bool;
        default = true;
        description = "Use shared keys of omega";
      };
      waylandSupport = mkOption {
        type = types.bool;
        default = true;
        description = "Wayland is the default, otherwise use X11";
      };
      useGraphicalSystem = mkOption {
        type = types.bool;
        default = true;
        description = "Use graphical system by default, otherwise use text-based system";
      };
      usePlasma6 = mkOption {
        type = types.bool;
        default = true;
        description = "Plasma 6 is the default, otherwise use Plasma 5";
      };
      useGhosttyGtkFix = mkOption {
        type = types.bool;
        default = false;
        description = "Build Ghostty with GTK 4.17.6";
      };
      termFontSize = mkOption {
        type = types.float;
        default = 12.0;
        description = "Terminal font size";
      };
      userLogin = mkOption {
        type = types.str;
        default = "omega";
        description = "User login of the default user";
      };
      userNameLong = mkOption {
        type = types.str;
        default = "Patrizio Bekerle";
        description = "User full name of the default user";
      };
      userNameShort = mkOption {
        type = types.str;
        default = "Patrizio";
        description = "User short name of the default user";
      };
      userEmail = mkOption {
        type = types.str;
        default = "patrizio@bekerle.com";
        description = "Email of the default user";
      };
      excludePackages = mkOption {
        description = "List of default packages to exclude from the configuration";
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.qownnotes ]";
      };
    };
  };

  config = lib.mkMerge [
    #
    # General configs for Plasma 6
    #
    (lib.mkIf (cfg.useGraphicalSystem && cfg.usePlasma6) {
      services.desktopManager.plasma6.enable = true;
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
        requiredPackages ++ utils.removePackagesByName optionalPackages cfg.excludePackages;

      home-manager.users.${cfg.userLogin} = {
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
    })

    #
    # General configs for X11
    #
    (lib.mkIf (cfg.useGraphicalSystem && !cfg.waylandSupport) {
      environment.systemPackages = with pkgs; [
        xorg.xkill
      ];
    })

    #
    # General configs for X11 with Plasma 6
    #
    (lib.mkIf (cfg.useGraphicalSystem && !cfg.waylandSupport && cfg.usePlasma6) {
      services.displayManager.defaultSession = "plasmax11";
    })

    #
    # General configs for X11 with Plasma 5
    #
    (lib.mkIf (cfg.useGraphicalSystem && !cfg.waylandSupport && !cfg.usePlasma6) {
      services.xserver.desktopManager.plasma5.enable = true;
      environment.plasma5.excludePackages = with pkgs.libsForQt5; [
        baloo
      ];

      environment.systemPackages =
        with pkgs.libsForQt5;
        let
          requiredPackages = [
          ];
          optionalPackages = [
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
            kcolorchooser
          ];
        in
        requiredPackages ++ utils.removePackagesByName optionalPackages config.hokage.excludePackages;
    })

    #
    # General configs for Plasma 6 with Wayland
    #
    (lib.mkIf (cfg.useGraphicalSystem && cfg.waylandSupport && cfg.usePlasma6) {
      services.displayManager.defaultSession = "plasma";

      # Launch SDDM in Wayland too
      # https://wiki.nixos.org/wiki/KDE#Launch_SDDM_in_Wayland_too
      services.displayManager.sddm.wayland.enable = true;

      # KMail Renders Blank Messages
      # https://wiki.nixos.org/wiki/KDE#KMail_Renders_Blank_Messages
      environment.sessionVariables = {
        NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (
          pkgs.lib.reverseList config.environment.profiles
        )}";
      };

      environment.systemPackages = with pkgs; [
        # Add missing dependency for espanso
        wl-clipboard
      ];

      home-manager.users.${cfg.userLogin} = {
        xdg.desktopEntries = {
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
      };
    })
  ];
}
