{
  config,
  lib,
  pkgs,
  utils,
  lib-utils,
  ...
}:
let
  cfg = config.hokage;
  hokage = cfg;

  inherit (lib)
    mkIf
    mkOption
    types
    literalExpression
    ;
in
{
  imports =
    builtins.map import (lib-utils.listNixFiles ./.)
    ++ builtins.map import (lib-utils.listNixFiles ./languages)
    ++ [
      ../common.nix
    ];

  options = {
    hokage = {
      users = mkOption {
        type = types.listOf types.str;
        default = [ cfg.userLogin ];
        description = "List of users that should be created by hokage";
      };
      usersWithRoot = mkOption {
        type = types.listOf types.str;
        default = cfg.users ++ [ "root" ];
        description = "List of users, including root";
        readOnly = true;
      };
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
      lowBandwidth = mkOption {
        type = types.bool;
        default = false;
        description = "Don't install all packages or use stable versions to save bandwidth";
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
      hostName = mkOption {
        type = types.str;
        default = "";
        description = "Hostname of the system";
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
    {
      # Placed here, because common.nix already had a "users.users" attribute
      users.users.root = {
        shell = pkgs.fish;
      };
    }

    (mkIf (cfg.hostName != "") {
      networking.hostName = cfg.hostName;
    })

    #
    # General configs for Plasma 6
    #
    (lib.mkIf cfg.useGraphicalSystem {
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
      });
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
    (lib.mkIf (cfg.useGraphicalSystem && !cfg.waylandSupport) {
      services.displayManager.defaultSession = "plasmax11";
    })

    #
    # General configs for Plasma 6 with Wayland
    #
    (lib.mkIf (cfg.useGraphicalSystem && cfg.waylandSupport) {
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

      home-manager.users = lib.genAttrs hokage.users (_userName: {
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
      });
    })
  ];
}
