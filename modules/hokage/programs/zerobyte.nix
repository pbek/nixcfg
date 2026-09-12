{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.zerobyte;
  backupMounts = map (path: "${path}:/backup${path}") cfg.backupPaths;
in
{
  options.hokage.programs.zerobyte = {
    enable = lib.mkEnableOption "the native Zerobyte backup service" // {
      default = hokage.role == "desktop" && hokage.useInternalInfrastructure;
    };

    package = lib.mkPackageOption pkgs "zerobyte" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which Zerobyte listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4096;
      description = "Port on which Zerobyte listens.";
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:4096";
      description = "Base URL of the Zerobyte instance.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = config.age.secrets.zerobyte-secret.path;
      defaultText = "config.age.secrets.zerobyte-secret.path";
      description = "Environment file containing APP_SECRET and other sensitive settings.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/zerobyte";
      description = "State directory used by Zerobyte.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "User under which Zerobyte runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Group under which Zerobyte runs.";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Vienna";
      description = "Timezone used by Zerobyte.";
    };

    resticHostname = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Restic hostname, defaulting to the system hostname when empty.";
    };

    trustedOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional origins allowed to call the Zerobyte authentication API.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.bool
          lib.types.int
          lib.types.str
        ]
      );
      default = { };
      description = "Additional environment settings passed to Zerobyte.";
    };

    backupPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/var/lib"
        "/home"
        "/etc"
        "/root"
      ];
      description = "Host paths exposed under /backup for existing Zerobyte volume definitions.";
    };

    readWriteBackupPaths = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Zerobyte may write to the configured backup paths for restores.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the Zerobyte port in the firewall.";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to start Zerobyte automatically at boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.zerobyte-secret = {
      file = ../../../secrets/zerobyte-secret.age;
      mode = "600";
    };

    services.zerobyte = {
      enable = true;
      inherit (cfg)
        package
        environmentFile
        dataDir
        user
        group
        openFirewall
        ;
      settings = {
        BASE_URL = cfg.baseUrl;
        HOST = cfg.host;
        PORT = cfg.port;
        TZ = cfg.timezone;
        RESTIC_HOSTNAME =
          if cfg.resticHostname != "" then cfg.resticHostname else config.networking.hostName;
        TRUSTED_ORIGINS = lib.concatStringsSep "," (
          cfg.trustedOrigins
          ++ lib.optional (lib.hasInfix "://localhost" cfg.baseUrl) (
            lib.replaceStrings [ "://localhost" ] [ "://127.0.0.1" ] cfg.baseUrl
          )
          ++ lib.optional (lib.hasInfix "://127.0.0.1" cfg.baseUrl) (
            lib.replaceStrings [ "://127.0.0.1" ] [ "://localhost" ] cfg.baseUrl
          )
        );
      }
      // cfg.settings;
    };

    systemd.services.zerobyte = {
      wantedBy = lib.mkIf (!cfg.autoStart) (lib.mkForce [ ]);
      serviceConfig = {
        ${if cfg.readWriteBackupPaths then "BindPaths" else "BindReadOnlyPaths"} = backupMounts;
      };
    };
  };
}
