# Caliban TU Work PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  config,
  pkgs,
  userLogin,
  ...
}:

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
    ../../modules/mixins/virt-manager.nix
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
    hostId = "dccada02"; # needed for ZFS
    hostName = "caliban";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    # Adding a 2nd IP address temporarily to the interface didn't work out, best use the ip command
    # `sudo ip addr add 192.168.1.100/255.255.255.0 dev eno1`
    #    interfaces.eno1 = {
    #      useDHCP = true;
    #      ipv4.addresses = [{ address = "192.168.1.100"; prefixLength = 24; }];
    #    };

    firewall = {
      allowedTCPPorts = [
        9000
        9003
      ]; # xdebug
    };
  };

  environment.systemPackages = with pkgs; [
    soapui
    openldap
    gimp
    inkscape
    krename
    go-passbolt-cli
    #    (pkgs.callPackage ../../apps/go-passbolt-cli/default.nix { })
    docker-slim # Docker image size optimizer and analysis tool
    amdgpu_top # AMD GPU monitoring
    lact # AMD GPU monitoring
  ];

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox = {
    host.enable = true;
    guest = {
      enable = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = [ userLogin ];

  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # latest: 6.13
  # lts: 6.6
  #  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ZFS (even unstable) is marked broken in kernel 6.12, so we stick to 6.11 and the unstable ZFS package
  boot.zfs.package = pkgs.zfs_unstable;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://nixos.wiki/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  #  # https://nixos.wiki/wiki/nvidia
  #  services.xserver.videoDrivers = [ "nvidia" ];
  #  nixpkgs.config.nvidia.acceptLicense = true;
  #  hardware.nvidia = {
  #    modesetting.enable = true;
  #    open = true;
  #
  #    # production: version 550
  #    # latest: version 560
  #    package = config.boot.kernelPackages.nvidiaPackages.latest;
  #
  #    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #    # Enable this if you have graphical corruption issues or application crashes after waking
  #    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  #    # of just the bare essentials.
  #    powerManagement.enable = false;
  #  };

  # For testing https://gitlab.tugraz.at/vpu-private/ansible/
  virtualisation.multipass.enable = true;

  users.users.omegah = {
    isNormalUser = true;
    description = "Patrizio Bekerle Home";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
      "input"
    ];
    shell = pkgs.fish;
    # Set empty password initially. Don't forget to set a password with "passwd".
    initialHashedPassword = "";
  };

  # Try if another console fonts make the console apear
  # Disabled, because since the new installation with ZFS the console was very small
  #  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
  #  console.earlySetup = true;

  # Enable Nix-Cache
  # See ./README.md
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/etc/cache-priv-key.pem";
    openFirewall = true;
  };

  # We have enough RAM
  zramSwap.enable = false;
}
