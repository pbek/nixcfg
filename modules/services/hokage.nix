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
    literalExpression
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
      userLogin = mkOption {
        type = types.str;
        default = "omega";
        description = "User login of the default user";
      };
      excludePackages = mkOption {
        description = "List of default packages to exclude from the configuration";
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.qownnotes ]";
      };
    };
  };
}
