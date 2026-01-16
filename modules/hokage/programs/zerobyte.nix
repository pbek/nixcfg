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
      description = "Port to bind zerobyte service (localhost only)";
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
        "/var/lib/docker/volumes:/backup/var/lib/docker/volumes:ro"
        "/home:/backup/home:ro"
        "/etc:/backup/etc:ro"
        "/root:/backup/root:ro"
      ];
      description = "List of paths to backup in container format (host:container:options)";
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

        # Port binding - only bind to localhost for security
        ports = [
          "127.0.0.1:${toString cfg.port}:4096"
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
        ++ cfg.backupPaths;
      };
    };

    # Open firewall for localhost only (this is handled by the port binding above)
    # No need to explicitly open firewall since we're binding to localhost only

    # Add zerobyte to system packages for CLI access if needed
    environment.systemPackages = [ ];
  };
}
