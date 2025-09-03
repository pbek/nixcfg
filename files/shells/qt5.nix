{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs =
    with pkgs;
    with libsForQt5.qt5;
    [
      crowdin-cli
      cmakeWithGui
      qmake
      qttools
      qtbase
      qtdeclarative
      qtsvg
      qtwayland
      qtwebsockets
      qtx11extras
      wrapQtAppsHook
      gdb
      aspell
    ];
}
