{ config, pkgs, inputs, ... }:

let
  pr = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/pull/223593/head.tar.gz)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in {
  environment.systemPackages = with pkgs; [
    # jetbrains.phpstorm
    (pr.jetbrains.plugins.addPlugins pr.jetbrains.phpstorm [ "github-copilot" ])
    # jetbrains.clion
    (pr.jetbrains.plugins.addPlugins pr.jetbrains.clion [ "github-copilot" ])
    jetbrains.goland
    # (pr.jetbrains.plugins.addPlugins pr.jetbrains.goland [ "github-copilot" ])
  ];
}
