{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  kdePackages,
  qt6,
  libgit2,
  installShellFiles,
  xvfb-run,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixbit";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "nixbit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-erK+FBAWwT5G72gz7+ZycrrpOnxvHdL5WgSokW/ePZw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ];

  buildInputs = [
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kconfig
    kdePackages.kirigami
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    libgit2
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # Install shell completion on Linux (with xvfb-run)
  postInstall = ''
    installShellCompletion --cmd ${finalAttrs.pname} \
      --bash <(xvfb-run $out/bin/${finalAttrs.pname} --completion-bash) \
      --fish <(xvfb-run $out/bin/${finalAttrs.pname} --completion-fish)
  '';

  meta = with lib; {
    description = "A KDE Plasma application to update your nixos system from a git repository";
    homepage = "https://github.com/pbek/nixbit";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = platforms.linux;
    mainProgram = "nixbit";
  };
})
