{
  config,
  lib,
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
    # enable = mkEnableOption "Nixbit configuration";
    enable = mkEnableOption "Nixbit configuration" // {
      default = hokage.role == "desktop";
    };

    package = mkOption {
      type = types.package;
      # default = pkgs.nixbit;
      default = pkgs.callPackage ../../../pkgs/nixbit/package.nix { };
      description = "The Nixbit package to install";
    };

    repository = mkOption {
      type = types.str;
      default = "https://github.com/pbek/nixcfg.git";
      description = "Git repository URL for Nixbit";
    };

    # forceAutostart = mkEnableOption "Force creation of autostart desktop entry when application starts";
    forceAutostart =
      mkEnableOption "Force creation of autostart desktop entry when application starts"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."nixbit.conf".text =
      let
        repoSection =
          if cfg.repository != "" then
            ''
              [Repository]
              Url = ${cfg.repository}
            ''
          else
            "";
      in
      ''
        ${repoSection}
        [Autostart]
        Force = ${if cfg.forceAutostart then "true" else "false"}
      '';
  };
}
