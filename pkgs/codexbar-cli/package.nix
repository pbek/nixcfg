{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  curl,
  sqlite,
  gcc-unwrapped,
}:

let
  version = "0.32.0";

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-x86_64.tar.gz";
      hash = "sha256:01vwjnpjrk8k9i6b9hv6ifp5h89qzzziwgcrr0pjabl8x4xlnnmk";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-aarch64.tar.gz";
      hash = lib.fakeHash;
    };
  };

  src = fetchurl (
    sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );
in
stdenv.mkDerivation {
  pname = "codexbar-cli";
  inherit version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    curl
    sqlite
    gcc-unwrapped.lib
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 codexbar $out/bin/codexbar
    runHook postInstall
  '';

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
