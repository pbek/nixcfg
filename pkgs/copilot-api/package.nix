{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs,
  makeWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "copilot-api";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "ericc-ch";
    repo = "copilot-api";
    rev = "v${version}";
    hash = "sha256-L8Jk1L/B15nHlxS3Ng1rq3bUl7Rp6SoSOhPZdYKfG7o=";
  };

  nativeBuildInputs = [
    bun
    nodejs
    makeWrapper
  ];

  # Disable network access during build
  __darwinAllowLocalNetworking = true;

  # Set up the build environment
  configurePhase = ''
    runHook preConfigure

    export HOME=$TMPDIR
    export BUN_INSTALL_CACHE_DIR=$TMPDIR/.bun-cache

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Install dependencies using bun
    bun install --frozen-lockfile --no-progress

    # Build the project
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
}
