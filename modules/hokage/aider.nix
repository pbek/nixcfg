{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.aider;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.aider = {
    enable = mkEnableOption "Enable Aider AI code completion tool";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      aider-chat # AI code completion tool
    ];

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
      programs.git.ignores = [ ".aider*" ];
    });
  };
}
