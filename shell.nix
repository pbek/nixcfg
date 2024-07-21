{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      gnumake
      git
      statix
      nh
      gum
    ];
}
