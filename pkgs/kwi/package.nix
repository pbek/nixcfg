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
  version = "0.1.0-unstable-2026-11-01";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kwi";
    rev = "483d718d779c069a28ec139280d1d6e5e198b94e";
    hash = "sha256-BA3Rxm7QzSM6SDb35Q7SlKzVAgvYDkHF1IWaZCMHp64=";
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
