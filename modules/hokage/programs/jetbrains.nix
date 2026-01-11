{
  config,
  pkgs,
  lib,
  nix-jetbrains-plugins,
  system,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.jetbrains;

  inherit (lib)
    mkEnableOption
    #    mkPackageOption
    mkOption
    types
    mkIf
    ;

  jetbrainsPackages =
    if cfg.useStable then
      (import
        (fetchTarball {
          # Date: 20260103
          # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable
          url = "https://github.com/NixOS/nixpkgs/tarball/cad22e7d996aea55ecab064e84834289143e44a0";
          sha256 = "sha256-5vKw92l1GyTnjoLzEagJy5V5mDFck72LiQWZSOnSicw=";
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
  #  mkJetbrainsPackage =
  #    name: cfgPackage:
  #    let
  #      inherit (cfg) plugins;
  #      basePackage =
  #        if builtins.isNull plugins || builtins.length plugins == 0 then
  #          cfgPackage
  #        else
  #          jetbrainsPackages.plugins.addPlugins cfgPackage plugins;
  #    in
  #    basePackage.overrideAttrs { preferLocalBuild = true; };

  mkJetbrainsIde =
    ideName:
    nix-jetbrains-plugins.lib."${system}".buildIdeWithPlugins jetbrainsPackages ideName cfg.plugins;

in
{
  options.hokage.programs.jetbrains = {
    enable = mkEnableOption "JetBrains IDEs support";
    useStable = mkEnableOption "stable JetBrains packages" // {
      default = hokage.lowBandwidth; # Use stable JetBrains packages to save bandwidth
    };
    phpstorm = {
      enable = mkEnableOption "PhpStorm support";
      #      package = mkPackageOption jetbrainsPackages "phpstorm" {
      #        example = "phpstorm";
      #      };
    };
    clion = {
      enable = mkEnableOption "CLion support";
      #      package = mkPackageOption jetbrainsPackages "clion" {
      #        example = "clion";
      #      };
    };
    goland = {
      enable = mkEnableOption "Goland support";
      #      package = mkPackageOption jetbrainsPackages "goland" {
      #        example = "goland";
      #      };
    };
    # Documentation: https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/applications/editors/jetbrains
    # Bundled plugins where droped in https://github.com/NixOS/nixpkgs/pull/470147
    plugins = mkOption {
      type = types.listOf types.str;
      default = [
        # https://plugins.jetbrains.com/plugin/17718-github-copilot
        "com.github.copilot"
        # https://plugins.jetbrains.com/plugin/8607-nixidea
        "nix-idea"
      ];
      example = [ "nix-idea" ];
      description = ''
        List of JetBrains plugin IDs to install.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      #      lib.optionals cfg.phpstorm.enable [ (mkJetbrainsPackage "phpstorm" cfg.phpstorm.package) ]
      #      ++ lib.optionals cfg.clion.enable [ (mkJetbrainsPackage "clion" cfg.clion.package) ]
      #      ++ lib.optionals cfg.goland.enable [ (mkJetbrainsPackage "goland" cfg.goland.package) ];
      lib.optionals cfg.phpstorm.enable [ (mkJetbrainsIde "phpstorm") ]
      ++ lib.optionals cfg.clion.enable [ (mkJetbrainsIde "clion") ]
      ++ lib.optionals cfg.goland.enable [ (mkJetbrainsIde "goland") ];

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
              #              clionPkg = mkJetbrainsPackage "clion" cfg.clion.package;
              clionPkg = mkJetbrainsIde "clion";
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
