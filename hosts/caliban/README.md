# Caliban TU Graz Desktop

## Binary Cache

Also see [Binary Cache](https://wiki.nixos.org/wiki/Binary_Cache).

### Setup

```bash
cd /etc
sudo nix-store --generate-binary-cache-key caliban-1.netbird.cloud cache-priv-key.pem cache-pub-key.pem
sudo chmod 600 cache-priv-key.pem
cat cache-pub-key.pem

# You need to do this after the nix-serve user is created by the nix-serve service
sudo chown nix-serve cache-priv-key.pem
```

## Disko disk partitioning

```bash
# Create a /tmp/secret.key with the disk-password (at least 8 characters)
vim /tmp/secret.key

# Do the partitioning (from root of git repository)
sudo nix run github:nix-community/disko -- --mode zap_create_mount ./hosts/caliban/disk-config.zfs.nix
```

- Afterward, do a normal `just switch` to apply the changes
- Then reboot the machine
- Then mount the old disks and copy the data over
