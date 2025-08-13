{
  config,
  pkgs,
  lib,
  xdg,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.jetbrains;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
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
    [ (basePackage.overrideAttrs { preferLocalBuild = true; }) ];

in
{
  options.hokage.jetbrains = {
    enable = mkEnableOption "Enable JetBrains IDEs support" // {
      default = hokage.role == "desktop"; # Enable JetBrains IDEs support by default for desktops
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
      enableQt6 = mkEnableOption "Enable Qt6 for CLion" // {
        default = true;
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

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      lib.optionals cfg.phpstorm.enable (mkJetbrainsPackage "phpstorm" cfg.phpstorm.package)
      ++ lib.optionals cfg.clion.enable (mkJetbrainsPackage "clion" cfg.clion.package)
      ++ lib.optionals cfg.goland.enable (mkJetbrainsPackage "goland" cfg.goland.package);

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      xdg.desktopEntries = lib.mkMerge [
        (lib.mkIf cfg.clion.enable {
          clion-nix-shell =
            let
              shellPath =
                if cfg.clion.enableQt6 then
                  "/home/${userLogin}/.shells/qt6.nix"
                else
                  "/home/${userLogin}/.shells/qt5.nix";
            in
            {
              name = "CLion with dev packages";
              genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
              comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
              icon = "${jetbrainsPackages.clion}/share/pixmaps/clion.svg";
              exec = "nix-shell ${shellPath} --run clion";
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
    });
  };
}
