{
  lib,
  stdenv,
  callPackage,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
  qtshadertools,
  qtsvg,
  wrapQtAppsHook,
  kcoreaddons,
  kconfig,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kirigami,
  kirigami-addons,
  kirigami-app-components,
  kitemmodels,
  kpty,
  kio,
  knotifications,
  kwindowsystem,
  kparts,
  kxmlgui,
  kwidgetsaddons,
  qqc2-desktop-style,
}:

stdenv.mkDerivation {
  pname = "kwi";
  version = "0.1.0-unstable-2026-11-08";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kwi";
    rev = "1df87417056b4b44085845b7fd273fe95bb0e42f";
    hash = "sha256-I7DjwSTC7kV3H0XokmC0aeGI6aQQ3vq7cOUkkbgQ+1Q=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    (callPackage ./libghostty-vt.nix { })
    qtbase
    qtdeclarative
    qtshadertools
    qtsvg
    kcoreaddons
    kconfig
    kdbusaddons
    kguiaddons
    ki18n
    kirigami
    kirigami-addons
    kirigami-app-components
    kitemmodels
    kpty
    kio
    knotifications
    kwindowsystem
    kparts
    kxmlgui
    kwidgetsaddons
    qqc2-desktop-style
  ];

  cmakeFlags = [
    "-DBUILD_KPART=ON"
    "-DBUILD_TESTING=OFF"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME="$TMPDIR/kwi-install-check" QT_QPA_PLATFORM=offscreen "$out/bin/kwi" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Modern GPU-accelerated KDE terminal built on libghostty-vt";
    homepage = "https://invent.kde.org/utilities/kwi";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      lgpl21Only
      lgpl3Only
    ];
    mainProgram = "kwi";
    platforms = lib.platforms.linux;
  };
}
