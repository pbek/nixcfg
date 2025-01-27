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
      useSecrets = mkOption {
        type = types.bool;
        default = true;
        description = "Use secrets handling of omega";
      };
      useSharedKey = mkOption {
        type = types.bool;
        default = true;
        description = "Use shared keys of omega";
      };
      useEspanso = mkOption {
        type = types.bool;
        default = true;
        description = "Use Espanso to expand text";
      };
      userLogin = mkOption {
        type = types.str;
        default = "omega";
        description = "User login of the default user";
      };
      userNameLong = mkOption {
        type = types.str;
        default = "Patrizio Bekerle";
        description = "User full name of the default user";
      };
      userNameShort = mkOption {
        type = types.str;
        default = "Patrizio";
        description = "User short name of the default user";
      };
      userEmail = mkOption {
        type = types.str;
        default = "patrizio@bekerle.com";
        description = "Email of the default user";
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
