{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./desktop-common-plasma5.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.xkill
  ];
}
