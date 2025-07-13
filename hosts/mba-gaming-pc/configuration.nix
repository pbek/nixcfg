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
    _1password-gui # 1Password GUI client
    mplayer
    vlc
    # Audio not working on e.g. X (Twitter) and Tiktok
    # (callPackage ../../pkgs/zen-browser/package.nix { })
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

  # Enable flatpak support
  services.flatpak.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.gamescopeSession.enable = true; # Integrates with programs.steam

  users.users.mba = {
    openssh.authorizedKeys.keys = [
      # Markus public key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGIQIkx1H1iVXWYKnHkxQsS7tGsZq3SoHxlVccd+kroMC/DhC4MWwVnJInWwDpo/bz7LiLuh+1Bmq04PswD78EiHVVQ+O7Ckk32heWrywD2vufihukhKRTy5zl6uodb5+oa8PBholTnw09d3M0gbsVKfLEi4NDlgPJiiQsIU00ct/y42nI0s1wXhYn/Oudfqh0yRfGvv2DZowN+XGkxQQ5LSCBYYabBK/W9imvqrxizttw02h2/u3knXcsUpOEhcWJYHHn/0mw33tl6a093bT2IfFPFb3LE2KxUjVqwIYz8jou8cb0F/1+QJVKtqOVLMvDBMqyXAhCkvwtEz13KEyt"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhUleyXsqtdA4LC17BshpLAw0X1vMLNKp+lOLpf2bw1 mba@miniserver24" # node-red container ssh calls
    ];
  };

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

    gaming = {
      enable = true;
      ryubing.highDpi = true;
    };

    zfs = {
      enable = true;
      hostId = "96cb2b24";
      poolName = "mbazroot";
    };
  };
}
