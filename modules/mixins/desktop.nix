{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
#  waylandSupport = config.services.hokage.waylandSupport;
#  usePlasma6 = config.services.hokage.usePlasma6;
  waylandSupport = true;
  usePlasma6 = true;
in
{
  imports =
    lib.optional (!waylandSupport && usePlasma6) ./desktop-x11.nix
    ++ lib.optional (waylandSupport && usePlasma6) ./desktop-wayland.nix
    ++ lib.optional (!waylandSupport && !usePlasma6) ./desktop-x11-plasma5.nix
    ++ [
      # Other imports here
    ];
}
