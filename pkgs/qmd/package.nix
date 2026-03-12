{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
  sqlite,
  runCommand,
}:
let
  version = "v2.0.1";
  rev = "64c6e6c2e30d6063e0020db0b5eb515c56f7f09e";
  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    inherit rev;
    hash = "sha256-0yWy0KhlMIbl3OM3nCMNR3XDtLppGVb7aNmjm+KA009=";
  };
  node_modules = stdenv.mkDerivation {
    pname = "qmd-node_modules";
    inherit src;
    inherit version;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    buildPhase = ''
      export HOME=$(mktemp -d)
      bun install --no-progress --frozen-lockfile
    '';
    installPhase = ''
      mkdir -p $out/node_modules
      cp -R ./node_modules $out
    '';
    dontPatchShebangs = true;
    dontFixup = true;
    outputHash = "sha256-nkFzT3IH3fr5p5Q8FRPGtYzUkwxoM2rx95RT7nvuHd2=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qmd";
  inherit version;
  inherit src;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ sqlite ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/qmd
    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out/lib/qmd/node_modules
    cp -r src $out/lib/qmd/
    cp package.json $out/lib/qmd/

    makeBinaryWrapper ${bun}/bin/bun $out/bin/qmd \
      --add-flags "run --prefer-offline --no-install --cwd $out/lib/qmd $out/lib/qmd/src/qmd.ts" \
      --set-default NODE_LLAMA_CPP_GPU false \
      --set DYLD_LIBRARY_PATH "${sqlite.out}/lib" \
      --set LD_LIBRARY_PATH "${
        lib.makeLibraryPath (
          [ sqlite ]
          ++ lib.optionals stdenv.isLinux [
            stdenv.cc.libc
            stdenv.cc.cc.lib
          ]
        )
      }"

    runHook postInstall
  '';

  passthru.tests.version = runCommand "qmd-test" { } ''
    ${lib.getExe finalAttrs.finalPackage} --help > $out
    grep -q "qmd collection add" $out
  '';

  meta = {
    description = "On-device search engine for markdown notes and knowledge bases";
    homepage = "https://github.com/tobi/qmd";
    license = lib.licenses.mit;
    mainProgram = "qmd";
    platforms = lib.platforms.unix;
  };
})
