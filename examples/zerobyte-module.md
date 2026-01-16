# Zerobyte Module

The zerobyte module provides a containerized backup service using the zerobyte application in a Docker/Podman container.

## Features

- Runs zerobyte in a secure Docker container
- Only accessible from localhost (127.0.0.1) for security
- Configurable backup paths
- Automatic restart unless stopped
- FUSE support for mounting backup repositories

## Usage

Add to your NixOS configuration:

```nix
hokage.programs.zerobyte = {
  enable = true;
  port = 4096;                    # Default port
  timezone = "Europe/Vienna";     # Your timezone
  resticHostname = "myserver";    # Hostname for restic backups
  backupPaths = [
    "/var/lib/docker/volumes:/backup/var/lib/docker/volumes:ro"
    "/home/omega:/backup/home/omega:ro"
    "/etc:/backup/etc:ro"
    "/var/lib/libvirt:/backup/var/lib/libvirt:ro"
  ];
};
```

## Configuration Options

### `enable`

- **Type:** boolean
- **Default:** false
- **Description:** Whether to enable the zerobyte backup service

### `image`

- **Type:** string
- **Default:** "ghcr.io/nicotsx/zerobyte:v0.22"
- **Description:** Docker image to use for zerobyte

### `port`

- **Type:** port (1-65535)
- **Default:** 4096
- **Description:** Port to bind zerobyte service (localhost only)

### `timezone`

- **Type:** string
- **Default:** "Europe/Vienna"
- **Description:** Timezone for the container

### `resticHostname`

- **Type:** string
- **Default:** `config.networking.hostName`
- **Description:** Restic hostname to use for backups

### `backupPaths`

- **Type:** list of strings
- **Default:** See example above
- **Description:** List of paths to backup in Docker volume format (host:container:options)

## Security

The service is configured to only listen on localhost (127.0.0.1) to prevent external access. The container runs with minimal required capabilities (SYS_ADMIN for FUSE support).

## Dependencies

- Requires Docker to be enabled (`virtualisation.docker.enable = true`)
- FUSE device access for mounting backup repositories

## Access

Once enabled, the zerobyte web interface will be available at:

- http://127.0.0.1:4096 (or your configured port)

## Troubleshooting

- Check container status: `docker ps | grep zerobyte`
- View container logs: `docker logs zerobyte`
- Restart service: `systemctl restart docker-zerobyte.service`
