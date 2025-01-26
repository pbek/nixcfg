# TU ThinkBook Jenny

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/mixins/users.nix
    ../../modules/mixins/desktop.nix
    ../../modules/mixins/git.nix
    ../../modules/mixins/audio.nix
    ../../modules/mixins/jetbrains.nix
    ../../modules/mixins/openssh.nix
    ../../modules/mixins/remote-store-cache.nix
  ];

  # Bootloader.
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;
  boot.zfs.requestEncryptionCredentials = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot";
      }
    ];
  };

  boot.initrd.network = {
    enable = true;
    postCommands = ''
      sleep 2
      zpool import -a;
    '';
  };

  # Add the sanoid service to take snapshots of the ZFS datasets
  services.sanoid = {
    enable = true;
    templates = {
      hourly = {
        autoprune = true;
        autosnap = true;
        daily = 7;
        hourly = 24;
        monthly = 0;
      };
    };
    datasets = {
      "calroot/encrypted/home" = {
        useTemplate = [ "hourly" ];
      };
    };
  };

  networking = {
    hostId = "dccada03"; # needed for ZFS
    hostName = "dp03";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  # ZFS (even unstable) is marked broken in kernel 6.12, so we stick to 6.11 and the unstable ZFS package
  boot.zfs.package = pkgs.zfs_unstable;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;

  environment.systemPackages = with pkgs; [
    go-passbolt-cli
  ];

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
    open = true;

    # production: version 550
    # latest: version 560
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    #    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    #    modesetting.enable = true;
  };

  # We have enough RAM
  zramSwap.enable = false;

  services.hokage = {
    userLogin = "jenny";
    userNameLong = "Jenny Gasser";
    useInternalInfrastructure = false;
  };
}
