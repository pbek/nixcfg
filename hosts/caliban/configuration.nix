# Caliban TU Work PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/virt-manager.nix
      ../../modules/mixins/remote-store-cache.nix
#    ../../modules/editor/nvim.nix
    # this brought me an infinite recursion
#    mixins-openssh
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "caliban"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    soapui
    openldap
    gimp
    inkscape
    krename
    go-passbolt-cli
#    (pkgs.callPackage ../../apps/go-passbolt-cli/default.nix { })
    docker-slim # Docker image size optimizer and analysis tool
  ];

  networking.firewall = {
    allowedTCPPorts = [ 9000 9003 ]; # xdebug
  };

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox = {
    host.enable = true;
    guest = {
      enable = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = [ username ];

  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # latest: 6.11
  # lts: 6.6
#  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
#    modesetting.enable = true;
    open = false;

    # production: version 550
    # latest: version 560
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;
  };


  # For testing https://gitlab.tugraz.at/vpu-private/ansible/
  virtualisation.multipass.enable = true;

  users.users.omegah = {
    isNormalUser = true;
    description = "Patrizio Bekerle Home";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" "input" ];
    shell = pkgs.fish;
    # Set empty password initially. Don't forget to set a password with "passwd".
    initialHashedPassword = "";
  };

  # Try if another console fonts make the console apear
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
  console.earlySetup = true;

  # Enable Nix-Cache
  # See ./README.md
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/etc/cache-priv-key.pem";
    openFirewall = true;
  };
}
