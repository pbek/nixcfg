# TU Gaming Station - ThinkCentre M720q
#
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# To test in a VM, run:
# nixos-rebuild --flake .#dp08 build-vm
# just boot-vm-no-kvm
#

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
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  environment.systemPackages = with pkgs; [
    # Video Player
    mplayer
    vlc
    # Games
    superTuxKart
    superTux
    brogue
  ];

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "dp";
    };
  };

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # Make the console font bigger
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u20n.psf.gz";

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  # Enable flatpak support
  services.flatpak.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.gamescopeSession.enable = true; # Integrates with programs.steam

  hokage = {
    hostName = "dp08";
    userLogin = "dp";
    userNameLong = "DP";
    userNameShort = "DP";
    userEmail = "dp@tugraz";
    useInternalInfrastructure = false;
    useSecrets = false;
    programs.espanso.enable = false;
    programs.git.enableUrlRewriting = false;

    gaming = {
      enable = true;
      ryubing.highDpi = true;
    };

    zfs = {
      enable = true;
      hostId = "1572555d";
    };
  };
}
