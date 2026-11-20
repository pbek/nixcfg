{
  lib,
  stdenv,
  callPackage,
  fetchurl,
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
  kcolorscheme,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kirigami,
  kirigami-addons,
  kirigami-app-components,
  kitemmodels,
  kiconthemes,
  kpty,
  kio,
  knotifications,
  kwindowsystem,
  kparts,
  kxmlgui,
  kwidgetsaddons,
  qqc2-desktop-style,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwi";
  version = "0.1.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/kwi/${finalAttrs.version}/kwi-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZCluPv87UbHA/c0NJbJEGyBTcqFzMPOt56fmE7SYBqc=";
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
    kcolorscheme
    kdbusaddons
    kguiaddons
    ki18n
    kirigami
    kirigami-addons
    kirigami-app-components
    kitemmodels
    kiconthemes
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
})
