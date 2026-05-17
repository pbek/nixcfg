{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  alsa-lib,
  glib,
  gettext,
  desktop-file-utils,
  appstream-glib,
}:
stdenv.mkDerivation rec {
  pname = "sysex-controls";
  version = "0.2.28";

  src = fetchFromGitHub {
    owner = "soyersoyer";
    repo = "sysex-controls";
    tag = "v${version}";
    hash = "sha256-DfVa0xUA79aSEo3V4O6MQWDxaRNJMO0HrA6diq0p/SY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    desktop-file-utils
    appstream-glib
    glib
  ];

  buildInputs = [
    gtk4
    libadwaita
    alsa-lib
  ];

  meta = {
    description = "SysEx controls for Linux - configure Akai, Arturia and Korg MIDI devices";
    homepage = "https://github.com/soyersoyer/sysex-controls";
    changelog = "https://github.com/soyersoyer/sysex-controls/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "sysex-controls";
    platforms = lib.platforms.linux;
  };
}
