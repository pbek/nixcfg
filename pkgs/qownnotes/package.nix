{
  lib,
  stdenv,
  fetchurl,
  qt6Packages,
  cmake,
  makeWrapper,
  botan3,
  libgit2,
  libsecret,
  pkg-config,
  nixosTests,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  aspell,
  kdePackages,
  useKdeIntegration ? stdenv.hostPlatform.isLinux,
}:

let
  # Keep Qt and KDE Frameworks on the same Qt package set.
  qtPackages = if useKdeIntegration then kdePackages else qt6Packages;
in
assert lib.assertMsg (
  !useKdeIntegration || stdenv.hostPlatform.isLinux
) "KDE integration is currently supported only on Linux";
stdenv.mkDerivation (finalAttrs: {
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "26.10.10";

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${finalAttrs.version}/qownnotes-${finalAttrs.version}.tar.xz";
    hash = "sha256-SrDlS5sVViUtbbx6MAql0+4guuiAbAwIXxQR5zSscrc=";
  };

  nativeBuildInputs = [
    cmake
    qtPackages.qttools
    qtPackages.wrapQtAppsHook
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals useKdeIntegration [ kdePackages.extra-cmake-modules ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    qtPackages.qtbase
    qtPackages.qtdeclarative
    qtPackages.qtsvg
    qtPackages.qtwebsockets
    botan3
    libgit2
    aspell
  ]
  ++ lib.optionals useKdeIntegration [
    kdePackages.kcolorscheme
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kglobalaccel
    kdePackages.knotifications
    kdePackages.plasma-activities
    kdePackages.kwindowsystem
    kdePackages.purpose
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsecret
    qtPackages.qtwayland
  ];

  cmakeFlags = [
    "-DQON_QT6_BUILD=ON"
    "-DBUILD_WITH_SYSTEM_BOTAN=ON"
    "-DBUILD_WITH_LIBGIT2=ON"
    "-DBUILD_WITH_ASPELL=ON"
    (lib.cmakeBool "QON_KDE_INTEGRATION" useKdeIntegration)
    "-DUSE_QLITEHTML=ON"
    "-DQLITEHTML_LIBRARY_TYPE=STATIC"
  ];

  # Install shell completion on Linux (offscreen, no display needed)
  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      installShellCompletion --cmd ${finalAttrs.appname} \
        --bash <(QT_QPA_PLATFORM=offscreen $out/bin/${finalAttrs.appname} --completion bash) \
        --fish <(QT_QPA_PLATFORM=offscreen $out/bin/${finalAttrs.appname} --completion fish)
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash <(QT_QPA_PLATFORM=offscreen $out/bin/${finalAttrs.appname} --completion bash) \
        --fish <(QT_QPA_PLATFORM=offscreen $out/bin/${finalAttrs.appname} --completion fish)
    ''
    # Install shell completion on macOS
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash <($out/bin/${finalAttrs.appname} --completion bash) \
        --fish <($out/bin/${finalAttrs.appname} --completion fish)
    ''
    # Create a lowercase symlink for Linux
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      ln -s $out/bin/${finalAttrs.appname} $out/bin/${finalAttrs.pname}
    ''
    # Rename application for macOS as lowercase binary
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Prevent "same file" error
      mv $out/bin/${finalAttrs.appname} $out/bin/${finalAttrs.pname}.bin
      mv $out/bin/${finalAttrs.pname}.bin $out/bin/${finalAttrs.pname}
    '';

  # Tests QOwnNotes using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.qownnotes;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    changelog = "https://www.qownnotes.org/changelog.html";
    downloadPage = "https://github.com/pbek/QOwnNotes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      pbek
      totoroot
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
    mainProgram = "qownnotes";
  };
})
