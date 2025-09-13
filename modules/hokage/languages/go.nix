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
    mkDefault
    ;
in
{
  options.hokage.languages.go = {
    enable = mkEnableOption "Enable Go development support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure && !hokage.lowBandwidth;
    };
    ide.enable = mkEnableOption "Enable Go IDE";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ go ];

    hokage = {
      jetbrains.goland.enable = mkDefault cfg.ide.enable;
    };
  };
}
