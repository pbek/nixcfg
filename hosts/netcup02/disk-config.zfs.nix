{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
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
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
#        mountpoint = "/";
        postCreateHook = "zfs snapshot zroot@blank";

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
            };
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
            };
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
            };
          };
          docker = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker/volumes";
            options = {
              mountpoint = "legacy";
            };
          };
#          zfs_fs = {
#            type = "zfs_fs";
#            mountpoint = "/zfs_fs";
#            options."com.sun:auto-snapshot" = "true";
#          };
#          zfs_testvolume = {
#            type = "zfs_volume";
#            size = "10M";
#            content = {
#              type = "filesystem";
#              format = "ext4";
#              mountpoint = "/ext4onzfs";
#            };
#          };
        };
      };
    };
  };
}
