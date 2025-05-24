{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    crowdin-cli
    cmakeWithGui
    qt6.qtbase
    qt6.qttools
    qt6.wrapQtAppsHook
    qt6.qtwebsockets
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qt5compat
    kdePackages.kwidgetsaddons
    kdePackages.kcoreaddons
    kdePackages.kconfig
    kdePackages.kio
    kdePackages.kxmlgui
    kdePackages.kiconthemes
    kdePackages.knotifications
  ];
}
