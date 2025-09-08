{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                # mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        # mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          encrypted = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/secret.key";
            };
            # use this to read the key during boot
            postCreateHook = ''
              zfs set keylocation="prompt" "zroot/$name";
            '';
          };
          "encrypted/root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "encrypted/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
          "encrypted/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "encrypted/docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker/volumes";
          };
        };
      };
    };
  };
}
