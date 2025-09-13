{
  config,
  lib,
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
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
    ide.enable = mkEnableOption "Enable Go IDE" // {
      default = !hokage.lowBandwidth;
    };
  };

  config = lib.mkIf cfg.enable {
    hokage = {
      jetbrains.goland.enable = mkDefault cfg.ide.enable;
    };
  };
}
