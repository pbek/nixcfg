# Caliban TU Work PC

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
  inherit (config.hokage) userLogin;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  networking = {
    hostName = "caliban";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    # Adding a 2nd IP address temporarily to the interface didn't work out, best use the ip command
    # `sudo ip addr add 192.168.1.100/255.255.255.0 dev eno1`
    #    interfaces.eno1 = {
    #      useDHCP = true;
    #      ipv4.addresses = [{ address = "192.168.1.100"; prefixLength = 24; }];
    #    };
  };

  environment.systemPackages = with pkgs; [
    soapui
    openldap
    gimp
    inkscape
    krename
    docker-slim # Docker image size optimizer and analysis tool
    amdgpu_top # AMD GPU monitoring
    lact # AMD GPU monitoring
  ];

  # latest: 6.13
  # lts: 6.6
  #  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://wiki.nixos.org/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  #  # https://wiki.nixos.org/wiki/nvidia
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

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # For letting astra build on caliban
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC50qr12/4ZU+xv2U20/kd6UPvX0Cgkc3XbslhFMlSde omega@astra"
    ];
  };

  hokage = {
    tugraz.enable = true;
    zfs = {
      enable = true;
      hostId = "dccada02";
      poolName = "calroot";
      encrypted = true;
    };
    qtcreator.enable = false;
    virtualbox.enable = true;
    jetbrains = {
      clion.enable = false;
      goland.enable = false;
    };
  };
}
