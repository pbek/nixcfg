{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeWrapper,
  nodejs,
  node-gyp,
  python3,
  sqlite,
  runCommand,
}:
let
  version = "v2.0.1";
  rev = version;
  src = fetchFromGitHub {
    owner = "tobi";
    repo = "qmd";
    inherit rev;
    hash = "sha256-UoR9iyxqbjwAbEmiC/kxS10lvdBJmDuQigS/aEgEzDs=";
  };
  node_modules = stdenv.mkDerivation {
    pname = "qmd-v2.0.1-node_modules";
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
      bun install --no-progress --ignore-scripts
    '';
    installPhase = ''
      mkdir -p $out/node_modules
      cp -R ./node_modules $out
    '';
    dontPatchShebangs = true;
    dontFixup = true;
    outputHash = "sha256-VJwVhcAw4hHe+hmUAEBQIGp3ibERBQuPdw2zmvLcvVI=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qmd";
  inherit version;
  inherit src;

  nativeBuildInputs = [
    bun
    makeWrapper
    nodejs
    node-gyp
    python3
  ];
  buildInputs = [ sqlite ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r ${node_modules}/node_modules ./node_modules

    export HOME=$(mktemp -d)
    chmod -R u+w node_modules/better-sqlite3
    pushd node_modules/better-sqlite3
    node ../prebuild-install/bin.js || node-gyp rebuild --release
    popd

    mkdir -p $out/lib/qmd
    mkdir -p $out/bin

    cp -r ./node_modules $out/lib/qmd/
    cp -r src $out/lib/qmd/
    cp package.json $out/lib/qmd/

    makeWrapper ${bun}/bin/bun $out/bin/qmd \
      --add-flags "$out/lib/qmd/src/cli/qmd.ts" \
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

  passthru.tests.version = runCommand "qmd-v2.0.1-test" { } ''
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
