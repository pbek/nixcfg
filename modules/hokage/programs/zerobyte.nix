{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.zerobyte;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in
{
  options.hokage.programs.zerobyte = {
    enable = mkEnableOption "Zerobyte backup service" // {
      default = hokage.role == "desktop" && hokage.useInternalInfrastructure;
    };

    image = mkOption {
      type = types.str;
      default = "ghcr.io/nicotsx/zerobyte:v0.42";
      description = "Docker image to use for zerobyte";
    };

    port = mkOption {
      type = types.port;
      default = 4096;
      description = "Port to bind zerobyte service";
    };

    baseUrl = mkOption {
      type = types.str;
      default = "http://localhost:4096";
      description = "Base URL of the zerobyte instance (required since v0.42). Use https:// for secure cookies when exposing the service.";
    };

    appSecretFile = mkOption {
      type = types.str;
      default = config.age.secrets.zerobyte-secret.path;
      defaultText = "config.age.secrets.zerobyte-secret.path";
      description = "Path to a file containing the zerobyte APP_SECRET environment variable (32+ chars, generate with 'openssl rand -hex 32'). Required since v0.42. Defaults to the agenix zerobyte-secret.";
    };

    trustedOrigins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional trusted origins (TRUSTED_ORIGINS) allowed to call the auth API, e.g. alternate hostnames or IPs. The baseUrl is always trusted automatically.";
    };

    localhostOnly = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to bind zerobyte service only to localhost (127.0.0.1). When false, binds to all interfaces.";
    };

    timezone = mkOption {
      type = types.str;
      default = "Europe/Vienna";
      description = "Timezone for the container";
    };

    resticHostname = mkOption {
      type = types.str;
      default = "";
      description = "Restic hostname to use for backups. Defaults to the system hostname if not set.";
    };

    backupPaths = mkOption {
      type = types.listOf types.str;
      default = [
        "/var/lib"
        "/home"
        "/etc"
        "/root"
      ];
      description = "List of paths to backup from the host system";
    };

    useLocalPath = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use /var/lib/zerobyte as local path (true) or docker volume zerobyte-data (false) for data storage.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically start the zerobyte container on boot. Set to false to allow manual container control.";
    };

    readWriteBackupPaths = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to mount backup paths as read-write (rw) instead of read-only (ro). Set to false for read-only mounts. Note: You cannot restore files if this option is false.";
    };
  };

  config = mkIf cfg.enable {
    # Zerobyte APP_SECRET (required since v0.42), decrypted by agenix
    age.secrets.zerobyte-secret = {
      file = ../../../secrets/zerobyte-secret.age;
      # Root-readable is fine; the file is passed to docker via environmentFiles
      mode = "600";
    };

    # Enable docker/podman for OCI containers
    virtualisation.docker.enable = true;

    # Create the zerobyte service using OCI containers
    virtualisation.oci-containers = {
      backend = "docker";
      containers.zerobyte = {
        inherit (cfg) image;
        inherit (cfg) autoStart;

        # Capabilities
        extraOptions = [
          "--cap-add=SYS_ADMIN"
          "--device=/dev/fuse:/dev/fuse"
        ];

        # Port binding - bind to localhost or all interfaces based on localhostOnly setting
        ports = [
          "${if cfg.localhostOnly then "127.0.0.1:" else ""}${toString cfg.port}:4096"
        ];

        # Environment variables
        environment = {
          TZ = cfg.timezone;
          BASE_URL = cfg.baseUrl;
          # Trust the loopback counterpart of baseUrl (localhost <-> 127.0.0.1) so the
          # auth API accepts requests regardless of which loopback name is browsed.
          TRUSTED_ORIGINS = lib.concatStringsSep "," (
            cfg.trustedOrigins
            ++ lib.optional (lib.hasInfix "://localhost" cfg.baseUrl) (
              lib.replaceStrings [ "://localhost" ] [ "://127.0.0.1" ] cfg.baseUrl
            )
            ++ lib.optional (lib.hasInfix "://127.0.0.1" cfg.baseUrl) (
              lib.replaceStrings [ "://127.0.0.1" ] [ "://localhost" ] cfg.baseUrl
            )
          );
          RESTIC_HOSTNAME =
            if cfg.resticHostname != "" then cfg.resticHostname else config.networking.hostName;
        };

        # Environment files (inject APP_SECRET without storing it in the nix store)
        environmentFiles = [ cfg.appSecretFile ];

        # Volumes
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "${if cfg.useLocalPath then "/var/lib/zerobyte" else "zerobyte-data"}:/var/lib/zerobyte"
        ]
        ++ (map (
          path: "${path}:/backup${path}:${if cfg.readWriteBackupPaths then "rw" else "ro"}"
        ) cfg.backupPaths);
      };
    };

    # Open firewall for localhost only (this is handled by the port binding above)
    # No need to explicitly open firewall since we're binding to localhost only

    # Add zerobyte to system packages for CLI access if needed
    environment.systemPackages = [ ];
  };
}
