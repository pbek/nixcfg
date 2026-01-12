{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  pam,
  pkg-config,
  systemd,
  libxau,
  libcap,
  shadow,
  kdePackages,
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "plasma-login-manager";
  version = "0.21.0-unstable-2025-01-12";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-login-manager";
    rev = "ad36a88e29e1613e71402e10bf2fd4333ec4cc6c";
    hash = "sha256-LIKJnAoRKSj1oTJ7/TN4TnJ0ax2BKFRonp0cl73FlTM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    pam
    systemd
    libxau
    libcap
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtshadertools
    kdePackages.kconfig
    kdePackages.kpackage
    kdePackages.kwindowsystem
    kdePackages.ki18n
    kdePackages.kdbusaddons
    kdePackages.kcmutils
    kdePackages.kauth
    kdePackages.kio
    kdePackages.plasma5support
    kdePackages.layer-shell-qt
    kdePackages.plasma-workspace
  ];

  cmakeFlags = [
    "-DINSTALL_PAM_CONFIGURATION=OFF"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
    "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
    "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
    "-DPAM_CONFIG_DIR=${placeholder "out"}/lib/pam.d"
    "-DLOGIN_DEFS_PATH=${shadow}/etc/login.defs"
    "-DUID_MIN=1000"
    "-DUID_MAX=65000"
  ];

  meta = {
    description = "Plasma display manager (SDDM successor)";
    homepage = "https://invent.kde.org/plasma/plasma-login-manager";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ pbek ];
    platforms = lib.platforms.linux;
    mainProgram = "plasmalogin";
  };
})
