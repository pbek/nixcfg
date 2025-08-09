{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    crowdin-cli
    cmakeWithGui
    libsForQt5.qt5.full # You need the full Qt5 package to not get QSqlError messages like "Driver not loaded" when running a built Qt5 application
    libsForQt5.qt5.wrapQtAppsHook
    gdb
    aspell
  ];
}
