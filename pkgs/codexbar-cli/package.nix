{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  curl,
  sqlite,
  gcc-unwrapped,
}:

let
  version = "0.84.0";

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-x86_64.tar.gz";
      hash = "sha256-cksL6w0nac/G/BVY8ngrW4EutzoUBYK5cW+vZirbrqA=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-aarch64.tar.gz";
      hash = "sha256-dpRuTSbNbmRbBGCZu3ekO2+2IyfHdpf9BkYlv5RV0a8=";
    };
  };

  src = fetchurl (
    sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );
in
stdenv.mkDerivation {
  pname = "codexbar-cli";
  inherit version src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    curl
    sqlite
    gcc-unwrapped.lib
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    app=$out/libexec/codexbar
    install -Dm755 CodexBarCLI $app/CodexBarCLI
    install -Dm644 VERSION $app/VERSION
    install -Dm644 THIRD_PARTY_NOTICES $out/share/doc/codexbar-cli/THIRD_PARTY_NOTICES
    cp -R CodexBar_CodexBarCore.bundle $app/
    makeWrapper $app/CodexBarCLI $out/bin/codexbar
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI to show AI coding provider usage stats (Codex, Claude, Cursor, and more)";
    homepage = "https://github.com/steipete/CodexBar";
    changelog = "https://github.com/steipete/CodexBar/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "codexbar";
  };
}
