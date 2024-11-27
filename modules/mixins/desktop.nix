{
  config,
  pkgs,
  inputs,
  lib,
  x11Support,
  waylandSupport,
  usePlasma6,
  ...
}:
{
  imports =
    lib.optional (x11Support && usePlasma6) ./desktop-x11.nix
    ++ lib.optional (waylandSupport && usePlasma6) ./desktop-wayland.nix
    ++ lib.optional (x11Support && !usePlasma6) ./desktop-x11-plasma5.nix
    ++ [
      # Other imports here
    ];
}
