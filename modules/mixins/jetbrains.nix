{ config, pkgs, inputs, xdg, username, ... }:
#{ config, inputs, xdg, ... }:

## https://github.com/NixOS/nixpkgs/pull/244500
#let
#  pkgs = import
#    (builtins.fetchTarball {
#      url = https://github.com/NixOS/nixpkgs/archive/151c175a8528864be449ba30df62ef4c2c93a25d.tar.gz;
#      sha256 = "sha256:06iyc7dqy863dkmy7nlnzfy2wd2gsb27szghp45rx2yfjr5b9mrf";
#    })
#    {
#      config = config.nixpkgs.config;
#      localSystem = { system = "x86_64-linux"; };
#    };
#in
{
  environment.systemPackages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.phpstorm [ "github-copilot" ])
    # jetbrains.clion
    (jetbrains.plugins.addPlugins jetbrains.clion [ "github-copilot" ])
    # jetbrains.goland
    (jetbrains.plugins.addPlugins jetbrains.goland [ "github-copilot" ])
  ];

  home-manager.users.${username} = {
    xdg.desktopEntries = {
      clion-nix-shell = {
        name = "CLion with nix-shell";
        genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
        comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
        icon = "${pkgs.jetbrains.clion}/share/pixmaps/clion.svg";
        exec = "nix-shell /home/${username}/.shells/qt5.nix --run clion";
        terminal = false;
        categories = [ "Development" ];
      };

      phpstorm-nix-shell = {
        name = "PhpStorm with nix-shell";
        genericName = "Professional IDE for Web and PHP developers";
        comment = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
        icon = "${pkgs.jetbrains.phpstorm}/share/pixmaps/phpstorm.svg";
        exec = "nix-shell /home/${username}/.shells/webdev.nix --run phpstorm";
        terminal = false;
        categories = [ "Development" ];
      };

      goland-nix-shell = {
        name = "Goland with nix-shell";
        genericName = "Up and Coming Go IDE";
        comment = "Goland is the codename for a new commercial IDE by JetBrains aimed at providing an ergonomic environment for Go development. The new IDE extends the IntelliJ platform with the coding assistance and tool integrations specific for the Go language.";
        icon = "${pkgs.jetbrains.goland}/share/pixmaps/goland.svg";
        exec = "nix-shell -p go --run goland";
        terminal = false;
        categories = [ "Development" ];
      };
    };
  };
}
