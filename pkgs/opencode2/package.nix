# OpenCode 2.x (the rewrite), packaged side-by-side with the nixpkgs OpenCode 1.x.
# Adapted from upstream's nix/opencode.nix + nix/node_modules.nix at the same tag.
#
# Only the `opencode2` executable is exposed so this package does not collide
# with `pkgs.opencode` (1.x). Note that both versions share the same data
# directory (~/.local/share/opencode) and OpenCode 2 migrates the 1.x database
# in place on first start.
{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nodejs,
  sysctl,
  makeBinaryWrapper,
  models-dev,
  ripgrep,
  wayland,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  platform = stdenvNoCC.hostPlatform;
  bunCpu = if platform.isAarch64 then "arm64" else "x64";
  bunOs = if platform.isLinux then "linux" else "darwin";

  node_modules =
    finalAttrs:
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install \
          --cpu="${bunCpu}" \
          --os="${bunOs}" \
          --filter '!./' \
          --filter './packages/cli' \
          --filter './packages/app' \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress

        bun --bun ./nix/scripts/canonicalize-node-modules.ts
        bun --bun ./nix/scripts/normalize-bun-binaries.ts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash =
        {
          x86_64-linux = "sha256-vFRFIY9tlUNN33KXWMcZXa/seUbptPyslmph37jNPjs=";
        }
        .${platform.system} or lib.fakeHash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode2";
  version = "2.0.23";

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HW/uDfTRqrZRBBUTQR9ANtXVm0nYcOGl2vdTLjTj4c4=";
  };

  nativeBuildInputs = [
    bun
    nodejs # for patchShebangs node_modules
    installShellFiles
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    # Relax Bun version check to be a warning instead of an error
    substituteInPlace packages/script/src/index.ts \
      --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                     'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env = {
    MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    OPENCODE_DISABLE_MODELS_FETCH = true;
    OPENCODE_VERSION = finalAttrs.version;
    OPENCODE_CHANNEL = "prod";
    NODE_OPTIONS = "--max-old-space-size=4096";
  };

  buildPhase = ''
    runHook preBuild

    cd ./packages/cli
    bun --bun ./script/build.ts --single --skip-install

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli-*/bin/opencode $out/libexec/opencode2/opencode

    # OpenTUI dlopens Wayland for clipboard images.
    makeWrapper $out/libexec/opencode2/opencode $out/bin/opencode2 \
      --prefix PATH : ${
        lib.makeBinPath ([ ripgrep ] ++ lib.optional stdenvNoCC.hostPlatform.isDarwin sysctl)
      } \
      --set OPENCODE_DISABLE_AUTOUPDATE true ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
      ''}

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    # v2 dropped the `completion` subcommand; --completions is the global flag.
    # OPENCODE_CLI_NAME is a build-time define, so rename the generated scripts.
    for shell in bash zsh fish; do
      $out/bin/opencode2 --completions $shell > completion.$shell
    done
    substitute completion.bash opencode2.bash --replace-fail opencode opencode2
    substitute completion.zsh _opencode2 --replace-fail opencode opencode2
    substitute completion.fish opencode2.fish --replace-fail opencode opencode2

    installShellCompletion --cmd opencode2 \
      --bash opencode2.bash \
      --fish opencode2.fish \
      --zsh _opencode2
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "OPENCODE_DISABLE_MODELS_FETCH"
  ];
  versionCheckProgram = "${placeholder "out"}/bin/opencode2";
  versionCheckProgramArg = "--version";

  passthru = {
    node_modules = node_modules finalAttrs;
  };

  meta = {
    description = "Open source AI coding agent (2.x)";
    homepage = "https://opencode.ai";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "opencode2";
  };
})
