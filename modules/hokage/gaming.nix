{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.gaming;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.hokage.gaming = {
    enable = mkEnableOption "Enable Gaming";
    ryubing = {
      highDpi = mkEnableOption "Enable high-dpi for ryubing";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      # https://wiki.nixos.org/wiki/steam
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers.
        protontricks.enable = true; # Protontricks is a simple wrapper that does winetricks things for Proton enabled games
      };

      gamemode = {
        enable = true; # Enable gamemode for games
        enableRenice = true; # Enable renice for gamemode

        settings = {
          general = {
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };

    environment.sessionVariables = mkIf cfg.ryubing.highDpi {
      # High DPI for ryubing
      AVALONIA_GLOBAL_SCALE_FACTOR = 2;
    };

    environment.systemPackages = with pkgs; [
      # wowup-cf
      #    (pkgs.callPackage ../../pkgs/wowup-cf/default.nix { })
      heroic # Epic Games Store
      ryubing # Nintendo Switch emulator
      mangohud # Overlay for monitoring performance of games
    ];
  };
}
