{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  nixbitPkg = import ./package.nix {
    inherit (pkgs)
      lib
      stdenv
      cmake
      ninja
      pkg-config
      libgit2
      installShellFiles
      xvfb-run
      ;
    kdePackages = pkgs.kdePackages;
    qt6 = pkgs.qt6;
  };
  cfg = config.services.nixbit;
in
{
  options.services.nixbit = {
    enable = mkEnableOption "nixbit configuration";

    package = mkOption {
      type = types.package;
      default = nixbitPkg;
      description = "The nixbit package to install";
    };

    repository = mkOption {
      type = types.str;
      default = "https://github.com/pbek/nixcfg.git";
      description = "Git repository URL for nixbit";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."nixbit.conf".text = ''
      [General]
      repository = ${cfg.repository}
    '';
  };
}
