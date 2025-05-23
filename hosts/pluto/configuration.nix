# PC Garage

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
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
    ../../modules/hokage
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "pluto"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # https://wiki.nixos.org/wiki/steam
  #  programs.steam = {
  #    enable = true;
  #    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #  };

  # # https://wiki.nixos.org/wiki/nvidia
  # services.xserver.videoDrivers = [ "nvidia" ];
  # nixpkgs.config.nvidia.acceptLicense = true;
  # hardware.graphics.enable = true;

  # # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway

  # hardware.nvidia = {
  #   open = false;
  #   # modesetting.enable = true;

  #   # The NVIDIA GeForce GTX 760 GPU needs the NVIDIA 470.xx Legacy drivers
  #   # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  #   # Fix for issue https://github.com/NixOS/nixpkgs/issues/370208
  #   package = config.boot.kernelPackages.nvidiaPackages.mkDriver (
  #     let
  #       aurPatches = pkgs.fetchgit {
  #         url = "https://aur.archlinux.org/nvidia-390xx-utils.git";
  #         rev = "94dffc01e23a93c354a765ea7ac64484a3ef96c1";
  #         hash = "sha256-c94qXNZyMrSf7Dik7jvz2ECaGELqN7WEYNpnbUkzeeU=";
  #       };
  #     in
  #     {
  #       version = "470.256.02";
  #       sha256_64bit = "sha256-1kUYYt62lbsER/O3zWJo9z6BFowQ4sEFl/8/oBNJsd4=";
  #       sha256_aarch64 = "sha256-e+QvE+S3Fv3JRqC9ZyxTSiCu8gJdZXSz10gF/EN6DY0=";
  #       settingsSha256 = "sha256-kftQ4JB0iSlE8r/Ze/+UMnwLzn0nfQtqYXBj+t6Aguk=";
  #       persistencedSha256 = "sha256-iYoSib9VEdwjOPBP1+Hx5wCIMhW8q8cCHu9PULWfnyQ=";

  #       patches = [ "${aurPatches}/gcc-14.patch" ];
  #     }
  #   );
  # };

  hokage = {
    jetbrains.useStable = true;
    useGhosttyGtkFix = false;
    virtualbox.enable = true;
    cache.sources = [ "home" ];
  };
}
