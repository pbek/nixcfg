# MBA Gaming PC
#
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# To test in a VM, run:
# nixos-rebuild --flake .#mba-gaming-pc build-vm
# just boot-vm-no-kvm
#

{
  config,
  pkgs,
  lib,
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

  environment.systemPackages = with pkgs; [
    amdgpu_top # AMD GPU monitoring
    lact # AMD GPU monitoring
  ];

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://wiki.nixos.org/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Make the console font bigger
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u20n.psf.gz";

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.gamescopeSession.enable = true; # Integrates with programs.steam

  users.users.omega = {
    description = "Patrizio Bekerle";
  };

  # TODO: Enable home-manager for "omega" user
  # home-manager.users.omega = config.home-manager.users.mba;

  hokage = {
    users = [
      "mba"
      "omega"
    ];
    hostName = "mba-gaming-pc";
    userLogin = "mba";
    userNameLong = "Markus Barta";
    userNameShort = "Markus";
    userEmail = "markus@barta.com";
    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
    espanso.enable = false;
    jetbrains.enable = false;
    qtcreator.enable = false;

    gaming = {
      enable = true;
      ryubing.highDpi = true;
    };

    zfs = {
      enable = true;
      hostId = "96cb2b23";
      datasetRootName = "root";
    };
  };
}
