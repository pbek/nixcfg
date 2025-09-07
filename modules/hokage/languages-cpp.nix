{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.languages.cpp;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.languages.cpp = {
    enable = mkEnableOption "Enable cpp dev support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
