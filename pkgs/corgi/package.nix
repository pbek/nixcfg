{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corgi";
  version = "20261025T010837Z-211f989a9870";

  src = fetchurl {
    url = "https://corgi.computer/releases/${finalAttrs.version}/corgi-linux-x86_64";
    hash = "sha256-0OHVp0R1XR3BTMm5gFXotuCeK0B2cgsssnCOdHXuwjY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  dontUnpack = true;
  # Stripping a Bun executable can destroy its embedded application and assets.
  dontStrip = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/libexec/corgi/corgi"
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} "$out/libexec/corgi/corgi"

    # Materialize Bun's embedded libraries and helpers, so autoPatchelf can fix
    # their library paths and ELF interpreters too, not just the main executable.
    export TMPDIR="$PWD/native-tmp"
    mkdir -p "$TMPDIR"
    "$out/libexec/corgi/corgi" --help > /dev/null
    cp -r "$TMPDIR"/corgi-native-*/*/{bin,lib} "$out/libexec/corgi/"

    mkdir -p "$out/bin"
    makeWrapper "$out/libexec/corgi/corgi" "$out/bin/corgi" \
      --set CORGI_NATIVE_ROOT "$out/libexec/corgi"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/corgi" --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Terminal multiplexer and AI agent manager powered by Ghostty";
    homepage = "https://github.com/tals/corgi";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "corgi";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
