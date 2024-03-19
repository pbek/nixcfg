{ config, pkgs, inputs, lib, x11Support, waylandSupport, ... }:
#let
#  x11Support = !waylandSupport;
#in
{
  imports =
    lib.optional x11Support ./desktop-x11.nix
    ++ lib.optional waylandSupport ./desktop-wayland.nix
    ++ [
      # Other imports here
    ];
}
