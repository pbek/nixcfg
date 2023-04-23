{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.phpstorm
    jetbrains.clion
    jetbrains.goland
  ];
}
