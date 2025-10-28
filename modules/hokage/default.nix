{
  config,
  lib,
  pkgs,
  lib-utils,
  ...
}:
let
  cfg = config.hokage;

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
    ++ builtins.map import (lib-utils.listNixFiles ./programs)
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
  ];
}
