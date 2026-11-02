{
  config,
  inputs,
  lib,
  options,
  pkgs,
  ...
}:

let
  inherit (config) hokage;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.hokage.programs.nixbit;
in
{
  options.hokage.programs.nixbit = {
    enable = mkEnableOption "Nixbit configuration" // {
      default = hokage.role == "desktop" || hokage.role == "ally";
    };

    repository = mkOption {
      type = types.str;
      default = "https://github.com/pbek/nixcfg.git";
      description = "Git repository URL for Nixbit";
    };

    forceAutostart =
      mkEnableOption "Force creation of autostart desktop entry when application starts"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable (
    lib.optionalAttrs (builtins.hasAttr "nixbit" options) {
      nixbit = {
        enable = true;
        # Build Nixbit with our Kwi package, so commands run in an embedded Kwi terminal
        package = pkgs.callPackage "${inputs.nixbit}/package.nix" { kwi = pkgs.kwi or null; };
        inherit (cfg) repository;
        inherit (cfg) forceAutostart;
      }
      # Rebuild with nh in Nixbit's embedded Kwi terminal
      // lib.optionalAttrs (builtins.hasAttr "useNh" options.nixbit) {
        useNh = config.programs.nh.enable;
      }
      //
        lib.optionalAttrs
          (hokage.useInternalInfrastructure && builtins.hasAttr "notificationCommand" options.nixbit)
          {
            notificationCommand = "neosay";
          };
    }
  );
}
