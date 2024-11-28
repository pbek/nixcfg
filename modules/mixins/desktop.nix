{
  config,
  pkgs,
  inputs,
  lib,
  waylandSupport,
  usePlasma6,
  ...
}:
{
  imports =
    lib.optional (!waylandSupport && usePlasma6) ./desktop-x11.nix
    ++ lib.optional (waylandSupport && usePlasma6) ./desktop-wayland.nix
    ++ lib.optional (!waylandSupport && !usePlasma6) ./desktop-x11-plasma5.nix
    ++ [
      # Other imports here
    ];
}
