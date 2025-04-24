{
  config,
  pkgs,
  inputs,
  lib,
  xdg,
  ...
}:
let
  inherit (config.services) hokage;
  inherit (hokage) userLogin;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.jetbrains;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  jetbrainsPackages =
    if cfg.useStable then
      (import
        (fetchTarball {
          # Date: 20250404
          url = "https://github.com/NixOS/nixpkgs/tarball/2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
          sha256 = "sha256-F7n4+KOIfWrwoQjXrL2wD9RhFYLs2/GGe/MQY1sSdlE=";
        })
        {
          inherit (config.nixpkgs) config;
          localSystem = {
            system = "x86_64-linux";
          };
        }
      ).jetbrains
    else
      # GitHub copilot seems broken with JetBrains 2025.1
      (import
        (fetchTarball {
          # Date: 20250412
          url = "https://github.com/NixOS/nixpkgs/tarball/2631b0b7abcea6e640ce31cd78ea58910d31e650";
          sha256 = "sha256-LWqduOgLHCFxiTNYi3Uj5Lgz0SR+Xhw3kr/3Xd0GPTM=";
        })
        {
          inherit (config.nixpkgs) config;
          localSystem = {
            system = "x86_64-linux";
          };
        }
      ).jetbrains;
  # pkgs.jetbrains;
in
{
  options.services.hokage.jetbrains = {
    enable = mkEnableOption "Enable JetBrains IDEs support" // {
      default = true; # Enable JetBrains IDEs support by default
    };
    useStable = mkEnableOption "Use stable JetBrains packages";
    phpstorm = {
      enable = mkEnableOption "Enable PhpStorm support" // {
        default = useInternalInfrastructure;
      };
      package = mkPackageOption jetbrainsPackages "phpstorm" {
        example = "phpstorm";
      };
    };
    clion = {
      enable = mkEnableOption "Enable CLion support" // {
        default = useInternalInfrastructure;
      };
      package = mkPackageOption jetbrainsPackages "clion" {
        example = "clion";
      };
    };
    goland = {
      enable = mkEnableOption "Enable Goland support" // {
        default = useInternalInfrastructure;
      };
      package = mkPackageOption jetbrainsPackages "goland" {
        example = "goland";
      };
    };
    # https://plugins.jetbrains.com/plugin/17718-github-copilot
    plugins = mkOption {
      type = types.listOf types.str;
      default = [ "17718" ];
      example = [ "17718" ];
      description = ''
        List of JetBrains plugin IDs to install. See
        https://plugins.jetbrains.com/plugin/17718-github-copilot
        for the plugin ID.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Unfortunately, we can't have per-application plugin settings
    environment.systemPackages =
      with pkgs;
      lib.optional cfg.phpstorm.enable (
        if builtins.isNull cfg.plugins || builtins.length cfg.plugins == 0 then
          cfg.phpstorm.package
        else
          jetbrainsPackages.plugins.addPlugins cfg.phpstorm.package cfg.plugins
      )
      ++ lib.optional cfg.clion.enable (
        if builtins.isNull cfg.plugins || builtins.length cfg.plugins == 0 then
          cfg.clion.package
        else
          jetbrainsPackages.plugins.addPlugins cfg.clion.package cfg.plugins
      )
      ++ lib.optional cfg.goland.enable (
        if builtins.isNull cfg.plugins || builtins.length cfg.plugins == 0 then
          cfg.goland.package
        else
          jetbrainsPackages.plugins.addPlugins cfg.goland.package cfg.plugins
      );
    home-manager.users.${userLogin} = {
      xdg.desktopEntries = lib.mkMerge [
        (lib.mkIf cfg.clion.enable {
          clion-nix-shell = {
            name = "CLion with dev packages";
            genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
            comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
            icon = "${jetbrainsPackages.clion}/share/pixmaps/clion.svg";
            exec = "nix-shell /home/${userLogin}/.shells/qt5.nix --run clion";
            terminal = false;
            categories = [ "Development" ];
          };
        })
        (lib.mkIf cfg.phpstorm.enable {
          phpstorm-nix-shell = {
            name = "PhpStorm with dev packages";
            genericName = "Professional IDE for Web and PHP developers";
            comment = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
            icon = "${jetbrainsPackages.phpstorm}/share/pixmaps/phpstorm.svg";
            exec = "nix-shell /home/${userLogin}/.shells/webdev.nix --run phpstorm";
            terminal = false;
            categories = [ "Development" ];
          };
        })
        (lib.mkIf cfg.goland.enable {
          goland-nix-shell = {
            name = "Goland with dev packages";
            genericName = "Up and Coming Go IDE";
            comment = "Goland is the codename for a new commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development. The new IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language.";
            icon = "${jetbrainsPackages.goland}/share/pixmaps/goland.svg";
            exec = "nix-shell -p go --run goland";
            terminal = false;
            categories = [ "Development" ];
          };
        })
      ];
    };
  };
}
