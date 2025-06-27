{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
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
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options.ashift = "12";
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/secret.key";
              # keylocation = "prompt";
            };
            mountpoint = "/";
            # use this to read the key during boot
            postCreateHook = ''
              zfs set keylocation="prompt" "zroot/$name";
            '';
          };
          "root/nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };
          "root/home" = {
            type = "zfs_fs";
            options.mountpoint = "/home";
            mountpoint = "/home";
          };
          "root/docker" = {
            type = "zfs_fs";
            options.mountpoint = "/var/lib/docker/volumes";
            mountpoint = "/var/lib/docker/volumes";
          };
        };
      };
    };
  };
}
