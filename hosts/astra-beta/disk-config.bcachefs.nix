{
  disko.devices = {
    disk = {
      vda = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            vda1 = {
              type = "EF00";
              size = "100M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            vda2 = {
              size = "100%";
              content = {
                type = "bcachefs";
                # This refers to a filesystem in the `bcachefs_filesystems` attrset below.
                filesystem = "mounted_subvolumes_in_multi";
                label = "group_a.vda2";
                extraFormatArgs = [
                  "--discard"
                ];
              };
            };
          };
        };
      };
    };

    bcachefs_filesystems = {
      # Example showing mounted subvolumes in a multi-disk configuration.
      mounted_subvolumes_in_multi = {
        type = "bcachefs_filesystem";
        # passwordFile = "/tmp/secret.key";
        extraFormatArgs = [
          "--compression=lz4"
          "--background_compression=lz4"
        ];
        subvolumes = {
          # Subvolume name is different from mountpoint.
          "subvolumes/root" = {
            mountpoint = "/";
            mountOptions = [
              "verbose"
            ];
          };
          # Subvolume name is the same as the mountpoint.
          "subvolumes/home" = {
            mountpoint = "/home";
          };
          # Parent is not mounted so the mountpoint must be set.
          "subvolumes/nix" = {
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
