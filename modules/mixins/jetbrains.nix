{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.phpstorm
    # (jetbrains.plugins.addPlugins phpstorm.clion [ "github-copilot" ])
    jetbrains.clion
    # (jetbrains.plugins.addPlugins jetbrains.clion [ "github-copilot" ])
    jetbrains.goland
  ];
}
