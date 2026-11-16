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
  zig_0_17,
}:

let
  # Match the minimum Zig 0.17.1 toolchain required by ziggity.
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggity";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "simoarpe";
    repo = "ziggity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QnG99z3v9Eba3XAfH0+SSsDpp0D2UyQyIGDl00yW5wg=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-OjvuVDDu5l6pxx0Yew0TxqZQ6OsnPeU7x3ZMfnvhdLU=";
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
    substituteInPlace src/git.zig src/app.zig \
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
