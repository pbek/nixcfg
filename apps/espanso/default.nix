{ config, pkgs, lib, ... }:

let
  # Define a small set of required packages for your function
  myPackages = {
    lib = pkgs.lib;
    coreutils = pkgs.coreutils;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    rustPlatform = pkgs.rustPlatform;
    pkg-config = pkgs.pkg-config;
    extra-cmake-modules = pkgs.extra-cmake-modules;
    dbus = pkgs.dbus;
    libX11 = pkgs.xorg.libX11;
    libXi = pkgs.xorg.libXi;
    libXtst = pkgs.xorg.libXtst;
    libnotify = pkgs.libnotify;
    libxkbcommon = pkgs.libxkbcommon;
    openssl = pkgs.openssl;
    xclip = pkgs.xclip;
    xdotool = pkgs.xdotool;
    setxkbmap = pkgs.xorg.setxkbmap;
    wl-clipboard = pkgs.wl-clipboard;
    wxGTK32 = pkgs.wxGTK32;
    makeWrapper = pkgs.makeWrapper;
    stdenv = pkgs.stdenv;
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