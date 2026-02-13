{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs,
  makeWrapper,
}:

let
  nodeModules = stdenvNoCC.mkDerivation {
    pname = "copilot-api-node-modules";
    inherit (copilot-api) version src;

    nativeBuildInputs = [ bun ];

    # Allow network access for fetching dependencies
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
      "NIX_BUILD_CORES"
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      export HOME=$TMPDIR

      # Install dependencies using bun (ignore scripts to avoid bad interpreter issues)
      bun install --frozen-lockfile --no-progress --ignore-scripts
    '';

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-+AH8eRG3SwwU86Pa/hFSW5nWD0v1po6z7xoLKUzq3qY=";
  };

  copilot-api = stdenvNoCC.mkDerivation rec {
    pname = "copilot-api";
    version = "0.7.0";

    src = fetchFromGitHub {
      owner = "ericc-ch";
      repo = "copilot-api";
      rev = "v${version}";
      hash = "sha256-rUUqf9QalVZDN3aw9ze5Uh+y5xvH6zdSgGN6ZLDjkDQ=";
    };

    nativeBuildInputs = [
      bun
      nodejs
      makeWrapper
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR

      # Copy the prefetched node_modules (symlinks can cause issues with shebangs)
      cp -r ${nodeModules}/node_modules node_modules
      chmod -R +w node_modules

      # Patch shebangs in all node_modules
      patchShebangs node_modules/

      # Fix specific shebang issues in .bin scripts that point to .mjs files
      for f in node_modules/.bin/*; do
        if [ -L "$f" ]; then
          target=$(readlink "$f")
          if [ -f "node_modules/$target" ]; then
            # If it's a node script, use node directly
            if head -1 "node_modules/$target" | grep -q "usr/bin/env node"; then
              rm "$f"
              echo "#!/bin/sh" > "$f"
              echo "exec ${nodejs}/bin/node \"$(dirname \"$f\")/../$target\" \"\$@\"" >> "$f"
              chmod +x "$f"
            fi
          fi
        fi
      done

      # Build the project using bun
      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Create output directory structure
      mkdir -p $out/lib/copilot-api
      mkdir -p $out/bin

      # Copy built application
      cp -r dist/ $out/lib/copilot-api/
      cp package.json $out/lib/copilot-api/

      # Create wrapper script
      makeWrapper ${bun}/bin/bun $out/bin/copilot-api \
        --add-flags "run $out/lib/copilot-api/dist/main.js" \
        --set NODE_ENV production

      runHook postInstall
    '';

    meta = with lib; {
      description = "Turn GitHub Copilot into OpenAI/Anthropic API compatible server";
      longDescription = ''
        A wrapper around GitHub Copilot API to make it OpenAI compatible,
        making it usable for other tools like Claude Code.
      '';
      homepage = "https://github.com/ericc-ch/copilot-api";
      license = licenses.mit;
      maintainers = [ "pbek" ];
      platforms = platforms.all;
      mainProgram = "copilot-api";
    };
  };
in
copilot-api
