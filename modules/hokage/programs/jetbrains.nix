{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.jetbrains;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    ;

  jetbrainsPackages =
    if cfg.useStable then
      (import
        (fetchTarball {
          # Date: 20250608
          # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable
          url = "https://github.com/NixOS/nixpkgs/tarball/005433b926e16227259a1843015b5b2b7f7d1fc3";
          sha256 = "sha256-IVft239Bc8p8Dtvf7UAACMG5P3ZV+3/aO28gXpGtMXI=";
        })
        {
          inherit (config.nixpkgs) config;
          localSystem = {
            system = "x86_64-linux";
          };
        }
      ).jetbrains
    else
      #      (import
      #        (fetchTarball {
      #          # Date: 20250713
      #          # https://github.com/NixOS/nixpkgs/issues/425328
      #          url = "https://github.com/NixOS/nixpkgs/tarball/9807714d6944a957c2e036f84b0ff8caf9930bc0";
      #          sha256 = "sha256:1g9qc3n5zx16h129dqs5ixfrsff0dsws9lixfja94r208fq9219g";
      #        })
      #        {
      #          inherit (config.nixpkgs) config;
      #          localSystem = {
      #            system = "x86_64-linux";
      #          };
      #        }
      #      ).jetbrains;
      pkgs.jetbrains;

  # Unfortunately, we can't have per-application plugin settings
  mkJetbrainsPackage =
    _name: cfgPackage:
    let
      inherit (cfg) plugins;
      basePackage =
        if builtins.isNull plugins || builtins.length plugins == 0 then
          cfgPackage
        else
          jetbrainsPackages.plugins.addPlugins cfgPackage plugins;
    in
    basePackage.overrideAttrs { preferLocalBuild = true; };

in
{
  options.hokage.programs.jetbrains = {
    enable = mkEnableOption "Enable JetBrains IDEs support";
    useStable = mkEnableOption "Use stable JetBrains packages" // {
      default = hokage.lowBandwidth; # Use stable JetBrains packages to save bandwidth
    };
    phpstorm = {
      enable = mkEnableOption "Enable PhpStorm support";
      package = mkPackageOption jetbrainsPackages "phpstorm" {
        example = "phpstorm";
      };
    };
    clion = {
      enable = mkEnableOption "Enable CLion support";
      package = mkPackageOption jetbrainsPackages "clion" {
        example = "clion";
      };
    };
    goland = {
      enable = mkEnableOption "Enable Goland support";
      package = mkPackageOption jetbrainsPackages "goland" {
        example = "goland";
      };
    };
    # Documentation: https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/applications/editors/jetbrains
    # Plugin list: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/plugins/plugins.json
    plugins = mkOption {
      type = types.listOf (types.either types.str types.package);
      # https://plugins.jetbrains.com/plugin/17718-github-copilot
      default = [
        "github-copilot"
        "nixidea"
      ];
      example = [ "github-copilot" ];
      description = ''
        List of JetBrains plugin IDs or names to install. See
        https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/plugins/plugins.json
        for a list of plugins.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      lib.optionals cfg.phpstorm.enable [ (mkJetbrainsPackage "phpstorm" cfg.phpstorm.package) ]
      ++ lib.optionals cfg.clion.enable [ (mkJetbrainsPackage "clion" cfg.clion.package) ]
      ++ lib.optionals cfg.goland.enable [ (mkJetbrainsPackage "goland" cfg.goland.package) ];

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs.fish.shellAliases = mkIf cfg.clion.enable {
        cl = "nix-shell /home/${_userName}/.shells/qt5.nix --run clion";
        cl6 = "nix-shell /home/${_userName}/.shells/qt6.nix --run clion";
      };

      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
      programs.git.ignores = [ ".idea" ];

      xdg.desktopEntries = lib.mkMerge [
        # We still need a desktop entry that launches CLion in a nix-shell with the
        # necessary development packages, otherwise CMake won't find the libraries.
        # https://www.reddit.com/r/NixOS/comments/9xjbxc/clion_cmake_not_finding_libraries_on_nixos/
        (mkIf cfg.clion.enable {
          clion-nix-shell =
            let
              shellPath =
                if hokage.languages.cplusplus.qt6.enable then
                  "/home/${_userName}/.shells/qt6.nix"
                else
                  "/home/${_userName}/.shells/qt5.nix";
              clionPkg = mkJetbrainsPackage "clion" cfg.clion.package;
            in
            {
              name = "CLion with dev packages";
              genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
              comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
              icon = "${clionPkg}/share/pixmaps/clion.svg";
              exec = "nix-shell ${shellPath} --run clion";
              terminal = false;
              categories = [ "Development" ];
            };
        })
      ];
    });
  };
}
