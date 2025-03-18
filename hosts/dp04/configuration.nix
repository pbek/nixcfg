# Thinkstation Andrea

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
  userNameLong = config.services.hokage.userNameLong;
  userEmail = config.services.hokage.userEmail;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/mixins/users.nix
    ../../modules/mixins/desktop.nix
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
    hostId = "dccada04"; # needed for ZFS
    hostName = "dp04";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    firewall = {
      allowedTCPPorts = [
        9000
        9003
      ]; # xdebug
    };
  };

  # ZFS (even unstable) is marked broken in kernel 6.13, so we stick to 6.12 and the unstable ZFS package
  boot.zfs.package = pkgs.zfs_unstable;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  environment.systemPackages = with pkgs; [
    go-passbolt-cli
    thunderbird
    spotify
  ];

  home-manager.users.${userLogin} = {
    # Allow https fetching for now
    home.file.".gitconfig".text = ''
      [user]
        name = ${userNameLong}
        email = ${userEmail}
      [core]
        excludesfile = /home/${userLogin}/.gitignore
      [commit]
        gpgsign = false
      [gpg]
        program = gpg
      [pull]
        rebase = true
      [gui]
        pruneduringfetch = true
      [smartgit "submodule"]
        fetchalways = false
        update = true
        initializenew = true
      [push]
        recurseSubmodules = check
      [init]
        defaultBranch = main
    '';
  };

  services.hokage = {
    userLogin = "dp";
    # userNameLong = "dp";
    # userNameShort = "dp";
    # userEmail = "dp@dp";

    # Temporary "owner" of this machine
    userNameLong = "Andrea Ortner";
    userNameShort = "Andrea";
    userEmail = "andrea.ortner@tugraz.at";

    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
  };
}
