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
    enable = mkEnableOption "Zerobyte backup service";

    image = mkOption {
      type = types.str;
      default = "ghcr.io/nicotsx/zerobyte:v0.22";
      description = "Docker image to use for zerobyte";
    };

    port = mkOption {
      type = types.port;
      default = 4096;
      description = "Port to bind zerobyte service";
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
      default = config.networking.hostName;
      description = "Restic hostname to use for backups";
    };

    backupPaths = mkOption {
      type = types.listOf types.str;
      default = [
        "/var/lib/docker/volumes"
        "/home"
        "/etc"
        "/root"
      ];
      description = "List of paths to backup from the host system";
    };
  };

  config = mkIf cfg.enable {
    # Enable docker/podman for OCI containers
    virtualisation.docker.enable = true;

    # Create the zerobyte service using OCI containers
    virtualisation.oci-containers = {
      backend = "docker";
      containers.zerobyte = {
        image = cfg.image;
        autoStart = true;

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
          RESTIC_HOSTNAME = cfg.resticHostname;
        };

        # Volumes
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "zerobyte-data:/var/lib/zerobyte"
        ]
        ++ (map (path: "${path}:/backup${path}:ro") cfg.backupPaths);
      };
    };

    # Open firewall for localhost only (this is handled by the port binding above)
    # No need to explicitly open firewall since we're binding to localhost only

    # Add zerobyte to system packages for CLI access if needed
    environment.systemPackages = [ ];
  };
}
