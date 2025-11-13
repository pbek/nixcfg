{
  config,
  lib,
  options,
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
        # package = pkgs.callPackage ../../../pkgs/nixbit/package.nix { };
        repository = cfg.repository;
        forceAutostart = cfg.forceAutostart;
      };
    }
  );
}
