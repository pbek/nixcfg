{
  config,
  pkgs,
  inputs,
  xdg,
  ...
}:
let
  inherit (config.services.hokage) userLogin;
  inherit (config.services.hokage) useStableJetbrains;
  jetbrainsPackages =
    if useStableJetbrains then
      (import
        (fetchTarball {
          # Date: 20250404
          url = "https://github.com/NixOS/nixpkgs/tarball/2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
          sha256 = "sha256-F7n4+KOIfWrwoQjXrL2wD9RhFYLs2/GGe/MQY1sSdlE=";
        })
        {
          config = config.nixpkgs.config;
          localSystem = {
            system = "x86_64-linux";
          };
        }
      ).jetbrains
    else
      pkgs.jetbrains;
in
{
  environment.systemPackages = with pkgs; [
    # https://plugins.jetbrains.com/plugin/17718-github-copilot
    (jetbrainsPackages.plugins.addPlugins jetbrainsPackages.phpstorm [ "17718" ])
    (jetbrainsPackages.plugins.addPlugins jetbrainsPackages.clion [ "17718" ])
    (jetbrainsPackages.plugins.addPlugins jetbrainsPackages.goland [ "17718" ])
  ];
  home-manager.users.${userLogin} = {
    xdg.desktopEntries = {
      clion-nix-shell = {
        name = "CLion with nix-shell";
        genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
        comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
        icon = "${jetbrainsPackages.clion}/share/pixmaps/clion.svg";
        exec = "nix-shell /home/${userLogin}/.shells/qt5.nix --run clion";
        terminal = false;
        categories = [ "Development" ];
      };

      phpstorm-nix-shell = {
        name = "PhpStorm with nix-shell";
        genericName = "Professional IDE for Web and PHP developers";
        comment = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
        icon = "${jetbrainsPackages.phpstorm}/share/pixmaps/phpstorm.svg";
        exec = "nix-shell /home/${userLogin}/.shells/webdev.nix --run phpstorm";
        terminal = false;
        categories = [ "Development" ];
      };

      goland-nix-shell = {
        name = "Goland with nix-shell";
        genericName = "Up and Coming Go IDE";
        comment = "Goland is the codename for a new commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development. The new IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language.";
        icon = "${jetbrainsPackages.goland}/share/pixmaps/goland.svg";
        exec = "nix-shell -p go --run goland";
        terminal = false;
        categories = [ "Development" ];
      };
    };
  };
}
