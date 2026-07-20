{
  lib,
  bash,
  coreutils,
  stdenv,
  fetchFromGitHub,
  git,
  gnugrep,
  makeWrapper,
  nix-update-script,
  zig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QvPFx8BghCdIWVRb1vvIfD61Ho/rfLo9yOr01LdbH+g=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-KQg6eGQxN1RALmSpiqs/okgGQI85tv4ap6zP+Dz5b6c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    zig
  ];

  nativeCheckInputs = [
    bash
    coreutils
    git
    gnugrep
  ];

  postPatch = ''
    substituteInPlace src/git.zig \
      --replace-fail "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin" \
        "${lib.makeBinPath finalAttrs.nativeCheckInputs}"
  '';

  postConfigure = ''
    cp -rLT ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram "$out/bin/ziggity" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.*)$"
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Fast, keyboard-driven terminal UI for Git";
    homepage = "https://github.com/simoarpe/ziggity";
    changelog = "https://github.com/simoarpe/ziggity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "ziggity";
    platforms = lib.platforms.unix;
  };
})
