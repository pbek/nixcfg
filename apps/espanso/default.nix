{ config, pkgs, lib, ... }:

let
  # Define a small set of required packages for your function
  myPackages = {
    inherit (pkgs) lib;
    inherit (pkgs) coreutils;
    inherit (pkgs) fetchFromGitHub;
    inherit (pkgs) rustPlatform;
    inherit (pkgs) pkg-config;
    inherit (pkgs) extra-cmake-modules;
    inherit (pkgs) dbus;
    inherit (pkgs.xorg) libX11;
    inherit (pkgs.xorg) libXi;
    inherit (pkgs.xorg) libXtst;
    inherit (pkgs) libnotify;
    inherit (pkgs) libxkbcommon;
    inherit (pkgs) openssl;
    inherit (pkgs) xclip;
    inherit (pkgs) xdotool;
    inherit (pkgs.xorg) setxkbmap;
    inherit (pkgs) wl-clipboard;
    inherit (pkgs) wxGTK32;
    inherit (pkgs) makeWrapper;
    inherit (pkgs) stdenv;
  };

  # Import the espanso package
  espansoPackage = import ./espanso.nix myPackages;
in {
  options = {
    programs.espanso = {
      enable = lib.mkEnableOption "espanso";

      # optionally allow for a custom package source
      package = lib.mkOption {
        type = lib.types.package;
        default = espansoPackage;
        defaultText = "espansoPackage";
        description = "The package to use for the espanso binary.";
      };
    };
  };

  config = lib.mkIf config.programs.espanso.enable {
    home.packages = [ config.programs.espanso.package ];

    # Here you can add more configuration, for example, setting up environment
    # variables, startup services, etc., specific to espanso
  };
}