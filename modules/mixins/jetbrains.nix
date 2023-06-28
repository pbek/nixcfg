{ config, pkgs, inputs, xdg, ... }:

# https://github.com/NixOS/nixpkgs/pull/223593
let
  prForJBPlugins = import
    (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/c3c3a9ba26fff3dd0b406d34ada95d505b047bf4.tar.gz;
      sha256 = "sha256:0993gsjisgb3y7zxpk33fbkqivzl2hg2z4vzxx330bfbcx8f2a7x";
    })
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    };
in {
  environment.systemPackages = with prForJBPlugins; [
    (jetbrains.plugins.addPlugins jetbrains.phpstorm [ "github-copilot" ])
    # jetbrains.clion
    (jetbrains.plugins.addPlugins jetbrains.clion [ "github-copilot" ])
    # jetbrains.goland
    (jetbrains.plugins.addPlugins jetbrains.goland [ "github-copilot" ])
  ];

  home-manager.users.omega = {
    xdg.desktopEntries = {
      clion-nix-shell = {
        name = "CLion with nix-shell";
        genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
        comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
        icon = "${prForJBPlugins.jetbrains.clion}/share/pixmaps/clion.svg";
        exec = "nix-shell /etc/nixos/shells/qt5.nix --run clion";
        terminal = false;
        categories = [ "Development" ];
      };

      phpstorm-nix-shell = {
        name = "PhpStorm with nix-shell";
        genericName = "Professional IDE for Web and PHP developers";
        comment = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
        icon = "${prForJBPlugins.jetbrains.phpstorm}/share/pixmaps/phpstorm.svg";
        exec = "nix-shell /etc/nixos/shells/webdev.nix --run phpstorm";
        terminal = false;
        categories = [ "Development" ];
      };

      goland-nix-shell = {
        name = "Goland with nix-shell";
        genericName = "Up and Coming Go IDE";
        comment = "Goland is the codename for a new commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development. The new IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language.";
        icon = "${prForJBPlugins.jetbrains.goland}/share/pixmaps/goland.svg";
        exec = "nix-shell -p go --run goland";
        terminal = false;
        categories = [ "Development" ];
      };
    };
  };
}
