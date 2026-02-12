{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libX11,
  libxcb,
  libxkbcommon,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wden";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "luryus";
    repo = "wden";
    tag = version;
    hash = "sha256-oZr7DznCDGfNycde8OMzDRvmLiL8xc2GmMl5s/6zdf8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libX11
    libxcb
    libxkbcommon
    wayland
  ];

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "cursive_table_view-0.15.0+disablesort.1" = "sha256-VqW1sGwVJ70ip1ZOQo6StR0MfA4oos5Am9pk+cFo5LY=";
      "x11-clipboard-0.9.1+multitarget.1" = "sha256-i0q6E4Fnr5hwDhF8NzCt0liUojWL/1o1wtuDXzKEuZA=";
    };
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bitwarden TUI client";
    longDescription = ''
      Wden is a terminal user interface (TUI) client for the Bitwarden password manager.
      It supports both the official Bitwarden cloud and self-hosted instances.
    '';
    homepage = "https://github.com/luryus/wden";
    changelog = "https://github.com/luryus/wden/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "wden";
    maintainers = with lib.maintainers; [ pbek ];
    platforms = lib.platforms.linux;
  };
}
