{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.languages.go;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.hokage.languages.go = {
    enable = mkEnableOption "Go development support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure && !hokage.lowBandwidth;
    };
    ide.enable = mkEnableOption "Go IDE" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ go ];

    hokage = mkIf cfg.ide.enable {
      programs.jetbrains.enable = true;
      programs.jetbrains.goland.enable = true;
    };
  };
}
