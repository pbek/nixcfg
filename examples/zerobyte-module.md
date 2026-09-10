# Zerobyte Module

The `hokage.programs.zerobyte` module uses the native package and NixOS service
from [NixOS/nixpkgs#557765](https://github.com/NixOS/nixpkgs/pull/557765).
The merged nixpkgs revision is pinned temporarily until it reaches
`nixos-unstable`.

The service is enabled by default on desktop hosts using the internal
infrastructure.

## Usage

```nix
hokage.programs.zerobyte = {
  enable = true;
  port = 4096;
  host = "127.0.0.1";
  timezone = "Europe/Vienna";
  resticHostname = "myserver";
  backupPaths = [
    "/var/lib"
    "/home"
    "/etc"
    "/root"
  ];
};
```

The native service runs as root by default to retain the filesystem access of
the former rootful container. Each `backupPaths` entry is exposed at its former
container path under `/backup`; for example, `/home` is also available as
`/backup/home`. This keeps existing Zerobyte volume definitions working.

Set `readWriteBackupPaths = false` to prevent restores from writing to these
paths. The service listens only on `127.0.0.1:4096` by default and does not open
the firewall.

## Existing State

Hosts that previously used `/var/lib/zerobyte` retain the same state directory.
For an installation that used the Docker named volume, point the native service
at its data directory:

```nix
hokage.programs.zerobyte.dataDir = "/var/lib/docker/volumes/zerobyte-data/_data";
```

## Secret

The module decrypts `secrets/zerobyte-secret.age` and passes it to systemd as an
environment file. Its contents must use this format:

```text
APP_SECRET=<32-or-more-character-secret>
```

Inspect the service with `systemctl status zerobyte` and
`journalctl -u zerobyte`.
