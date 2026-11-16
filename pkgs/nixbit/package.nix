{
  cmake,
  fetchFromGitHub,
  installShellFiles,
  kdePackages,
  kwi ? null,
  lib,
  libgit2,
  libssh2,
  ninja,
  pkg-config,
  qt6,
  stdenv,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixbit";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "nixbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rf4/Lzc+Nj3wb2e4Xb+4YadbuK8mY1S2H+c7nTDVLUM=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    kdePackages.extra-cmake-modules
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    libgit2
    libssh2
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
  ]
  ++ lib.optionals (kwi != null) [ kwi ];

  # Do not load QML modules from a development shell's different Qt build.
  qtWrapperArgs = [ "--unset QML_IMPORT_PATH" ];

  # Install shell completion on Linux (with xvfb-run)
  postInstall = ''
    installShellCompletion --cmd nixbit \
      --bash <(xvfb-run $out/bin/nixbit --completion-bash) \
      --fish <(xvfb-run $out/bin/nixbit --completion-fish)
  '';

  meta = with lib; {
    description = "KDE Plasma application to update your NixOS system from a git repository";
    homepage = "https://github.com/pbek/nixbit";
    changelog = "https://github.com/pbek/nixbit/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = platforms.linux;
    mainProgram = "nixbit";
  };
})
