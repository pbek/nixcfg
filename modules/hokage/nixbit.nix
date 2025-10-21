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
  cfg = config.services.nixbit;
in
{
  options.services.nixbit = {
    # enable = mkEnableOption "Nixbit configuration";
    enable = mkEnableOption "Nixbit configuration" // {
      default = hokage.role == "desktop";
    };

    package = mkOption {
      type = types.package;
      # default = pkgs.nixbit;
      default = pkgs.callPackage ../../pkgs/nixbit/package.nix { };
      description = "The Nixbit package to install";
    };

    repository = mkOption {
      type = types.str;
      default = "https://github.com/pbek/nixcfg.git";
      description = "Git repository URL for Nixbit";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."nixbit.conf".text = ''
      [Repository]
      Url = ${cfg.repository}
    '';
  };
}
