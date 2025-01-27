{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.displayManager.defaultSession = "plasmax11";

  imports = [
    ./desktop-common-plasma6.nix
#    ./espanso-latest.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.xkill
  ];
}
