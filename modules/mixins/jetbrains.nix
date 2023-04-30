{ config, pkgs, inputs, xdg, ... }:

let
  prForJBPlugins = import
    (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/62ba85c05e275112a365083ebde5317f0042be6d.tar.gz;
      sha256 = "sha256:0gbxwm1zabnwjmsiql1ywmh32ls44wfkd2f770p9vldwjgfnja7v";
    })
    {
      config = config.nixpkgs.config;
      localSystem = { system = "x86_64-linux"; };
    };
in {
  environment.systemPackages = with pkgs; [
    # jetbrains.phpstorm
    (prForJBPlugins.jetbrains.plugins.addPlugins prForJBPlugins.jetbrains.phpstorm [ "github-copilot" ])
    # jetbrains.clion
    (prForJBPlugins.jetbrains.plugins.addPlugins prForJBPlugins.jetbrains.clion [ "github-copilot" ])
    # prForJBPlugins.jetbrains.goland
    (prForJBPlugins.jetbrains.plugins.addPlugins prForJBPlugins.jetbrains.goland [ "github-copilot" ])
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
    };
  };
}
