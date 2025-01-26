{
  config,
  lib,
  ...
}:
let
  cfg = config.services.hokage;

  inherit (lib)
    mkOption
    types
    ;
in
{
  options = {
    services.hokage = {
      useInternalInfrastructure = mkOption {
        type = types.bool;
        default = true;
        description = "Use internal infrastructure of omega";
      };
    };
  };
}
