{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      crowdin-cli
      cmakeWithGui
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qttools
      libsForQt5.qt5.wrapQtAppsHook
      libsForQt5.qt5.qtx11extras
      libsForQt5.qt5.qtwebsockets
      libsForQt5.qt5.qtdeclarative
      libsForQt5.qt5.qtsvg
    ];
}
