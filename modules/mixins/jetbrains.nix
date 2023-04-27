{ config, pkgs, inputs, ... }:

let
  prForJBPlugins = import
    (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/pull/223593/head.tar.gz;
      sha256 = "sha256:1wc70sq3nzk58kp9bbzlw2f57df02d7jclf5dhqc2sr0jk3psiaf";
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
    prForJBPlugins.jetbrains.goland
    # (prForJBPlugins.jetbrains.plugins.addPlugins prForJBPlugins.jetbrains.goland [ "github-copilot" ])
  ];
}
