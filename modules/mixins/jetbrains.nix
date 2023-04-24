{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.phpstorm
    jetbrains.clion
    # (jetbrains.plugins.addPlugins jetbrains.clion [ "github-copilot" ])
    jetbrains.goland
  ];
}
