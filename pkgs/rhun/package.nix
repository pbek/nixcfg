{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhun";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "vshvedov";
    repo = "rhun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/LVYg/dodRTDH1YtsGvzmuUXRqmD3KOFpJl43VNYuuE=";
  };

  strictDeps = true;

  # Fully static, libc-free binary: nothing for patchelf to do
  dontPatchELF = true;

  # build.sh only needs GNU as/ld (binutils from stdenv) and a POSIX shell.
  # RHUN_DIST is intentionally left unset, which disables the built-in self-updater.
  postPatch = ''
    patchShebangs build.sh tools/gen-assets.sh
  '';

  buildPhase = ''
    runHook preBuild
    ./build.sh release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/rhun -t $out/bin
    install -Dm644 assets/rhun.desktop -t $out/share/applications
    install -Dm644 assets/icons/rhun.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 assets/icons/rhun-256.png $out/share/icons/hicolor/256x256/apps/rhun.png
    install -Dm644 assets/icons/rhun-512.png $out/share/icons/hicolor/512x512/apps/rhun.png
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    [ "$($out/bin/rhun --version)" = "rhun ${finalAttrs.version}" ]
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small and fast code editor written in Assembly";
    homepage = "https://rhun.app";
    changelog = "https://github.com/vshvedov/rhun/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      ofl # embedded Iosevka font
    ];
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "rhun";
    # Linux build is hand-written x86-64 assembly; the macOS build needs Apple tooling
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
