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
    (pkgs.callPackage ../../apps/go-passbolt-cli/default.nix { })
  ];

  networking.firewall = {
    allowedTCPPorts = [ 9000 9003 ]; # xdebug
  };

  # Extract

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # For testing https://gitlab.tugraz.at/vpu-private/ansible/
  # Turn off for now, because build is broken
#  virtualisation.multipass.enable = true;

  users.users.omegah = {
    isNormalUser = true;
    description = "Patrizio Bekerle Home";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" "input" ];
    shell = pkgs.fish;
    # Set empty password initially. Don't forget to set a password with "passwd".
    initialHashedPassword = "";
  };

  # Try if another console fonts make the console apear
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  console.earlySetup = true;
}
