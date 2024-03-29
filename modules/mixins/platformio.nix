{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    platformio
    avrdude
  ];

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
  ];
}
