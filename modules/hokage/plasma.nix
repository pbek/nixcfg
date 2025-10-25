{ config, lib, ... }:

let
  cfg = config.hokage.plasma;
in
{
  options.hokage.plasma = {
    enableOld = lib.mkEnableOption "Enable plasma with old KDE packages";
  };

  config = lib.mkIf cfg.enableOld {
    nixpkgs.overlays = [
      (import ../../overlays/kde/kde-old.nix)
    ];
  };
}
