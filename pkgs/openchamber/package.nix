# OpenChamber web/CLI server (https://github.com/openchamber/openchamber).
#
# OpenChamber 2.x talks to the OpenCode 2.x HTTP API (it pins
# @opencode/client 2.0.x, and its Docker image installs @opencode/cli 2.0.x),
# so it is wired to `opencode2` instead of the nixpkgs OpenCode 1.x.
# Use `openchamber.override { opencode2 = ...; }` for a different build, or set
# OPENCODE_BINARY at runtime.
{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs,
  git,
  opencode2,
  makeBinaryWrapper,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
let
  platform = stdenvNoCC.hostPlatform;
  bunCpu = if platform.isAarch64 then "arm64" else "x64";
  bunOs = if platform.isLinux then "linux" else "darwin";

  # Two installs from the same lockfile:
  #  - build/:   full workspace install (vite, tsc, ...) used to build the app
  #  - runtime/: production-only deps of @openchamber/web, which is what we ship
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
        bunInstall() {
          bun install \
            --cpu="${bunCpu}" \
            --os="${bunOs}" \
            --frozen-lockfile \
            --ignore-scripts \
            --no-progress \
            "$@"
        }

        # bun's isolated linker creates .bin and hoisted links in a
        # nondeterministic way, rebuild them so the output hash is stable.
        collect() {
          bun --bun ${./scripts/canonicalize-node-modules.ts}
          bun --bun ${./scripts/normalize-bun-binaries.ts}
          mkdir -p "$1"
          find . -type d -name node_modules -prune -exec cp -R --parents {} "$1" \;
          find . -type d -name node_modules -prune -exec rm -rf {} +
        }

        bunInstall
        collect "$TMPDIR/build"

        bunInstall --production --filter ./packages/web
        collect "$TMPDIR/runtime"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        mv "$TMPDIR/build" "$TMPDIR/runtime" $out/

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash =
        {
          x86_64-linux = "sha256-61kzTCWOAhzw/dSJcYQrgzc95fET6ucMUxiWrl4okd8=";
        }
        .${platform.system} or lib.fakeHash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openchamber";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "openchamber";
    repo = "openchamber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dp3E+bMyGakWZeG4QaGJmDA5xGjxUnYn70+gEj92zt8=";
  };

  nativeBuildInputs = [
    bun
    nodejs # for patchShebangs node_modules
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # Prebuilt native addons shipped at runtime (bun-pty, node-pty, sherpa-onnx)
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  postPatch = ''
    # Updates are managed by Nix, never let `openchamber update` or the UI
    # run a global npm/bun install.
    substituteInPlace packages/web/server/lib/package-manager.js \
      --replace-fail \
        'export function executeUpdate(pm = detectPackageManager(), options = {}) {' \
        'export function executeUpdate(pm = detectPackageManager(), options = {}) {
        return { success: false, exitCode: 1, error: "OpenChamber is installed via Nix; update it through your Nix configuration." };'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/build/. .
    chmod -R u+w node_modules packages
    patchShebangs node_modules packages/*/node_modules

    runHook postConfigure
  '';

  env.NODE_OPTIONS = "--max-old-space-size=6144";

  buildPhase = ''
    runHook preBuild

    # Mirrors the upstream Dockerfile: the server imports @openchamber/sdk at
    # runtime, and the web build also generates the built-in extensions.
    bun run --cwd packages/sdk build
    bun run build:web

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app=$out/lib/openchamber
    mkdir -p $app/packages/web $app/packages/sdk

    cp package.json $app/
    cp -R packages/web/{package.json,bin,server,dist,public} $app/packages/web/
    cp -R packages/sdk/{package.json,dist} $app/packages/sdk/
    cp -R ${finalAttrs.passthru.node_modules}/runtime/. $app/
    chmod -R u+w $app
    # Only links the SDK's dev-time guest bundler script, which we do not ship
    rm $app/packages/web/node_modules/.bin/openchamber-guest-bundle

    makeWrapper ${lib.getExe bun} $out/bin/openchamber \
      --add-flags $app/packages/web/bin/cli.js \
      --set-default BUN_BINARY ${lib.getExe bun} \
      --set-default OPENCHAMBER_BUN_BINARY ${lib.getExe bun} \
      --set-default OPENCHAMBER_NODE_BINARY ${lib.getExe nodejs} \
      --set-default OPENCODE_BINARY ${lib.getExe opencode2} \
      --suffix PATH : ${
        lib.makeBinPath [
          git
          nodejs
        ]
      }

    runHook postInstall
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru = {
    node_modules = node_modules finalAttrs;
    opencode = opencode2;
  };

  meta = {
    description = "Web/PWA workspace and CLI server for running and reviewing OpenCode agent work";
    homepage = "https://openchamber.dev";
    changelog = "https://github.com/openchamber/openchamber/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # prebuilt native addons from npm
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "openchamber";
  };
})
