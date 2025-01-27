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
      waylandSupport = mkOption {
        type = types.bool;
        default = true;
        description = "Wayland is the default, otherwise use X11";
      };
      usePlasma6 = mkOption {
        type = types.bool;
        default = true;
        description = "Plasma 6 is the default, otherwise use Plasma 5";
      };
      useStableJetbrains = mkOption {
        type = types.bool;
        default = false;
        description = "Set this to true to use stable versions of the Jetbrains tools";
      };
      termFontSize = mkOption {
        type = types.float;
        default = 12.0;
        description = "Terminal font size";
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
