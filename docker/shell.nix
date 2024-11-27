{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = [
    pkgs.x11docker
    pkgs.xorg.libxcvt
    pkgs.catatonit
    pkgs.wmctrl
  ];
}
