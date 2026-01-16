{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs,
  restic,
  rclone,
  shoutrrr,
  davfs2,
  openssh,
  fuse3,
  sshfs,
  tini,
  nfs-utils,
  cifs-utils,
  util-linux,
  makeBinaryWrapper,
}:

let
  version = "0.22.0";
  src = fetchFromGitHub {
    owner = "nicotsx";
    repo = "zerobyte";
    tag = "v${version}";
    hash = "sha256-Ws0u4/H3LQeF4j0ROpkGyTzDrunvodq5cNGmsjPBJAc=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "zerobyte-node_modules";
    inherit src version;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      export HOME=$(mktemp -d)
      # Allow scripts to run during install to build packages like @react-router/dev
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out
      cp -R ./node_modules $out/node_modules
    '';

    # Disable references to make this a proper FOD
    dontPatchShebangs = true;
    dontPatchELF = true;
    dontStrip = true;

    outputHash = "sha256-Qg6DR8tZRyb0STO/6p8y/cDRhu5/UqQj0e7VIESkGzg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  # Built application derivation
  built_app = stdenv.mkDerivation {
    pname = "zerobyte-built";
    inherit src version;

    nativeBuildInputs = [
      bun
      nodejs
    ];

    # Environment variables for build
    VITE_RESTIC_VERSION = restic.version;
    VITE_RCLONE_VERSION = rclone.version;
    VITE_SHOUTRRR_VERSION = shoutrrr.version;
    VITE_APP_VERSION = version;
    NODE_ENV = "production";

    dontConfigure = true;

    buildPhase = ''
      export HOME=$(mktemp -d)

      # Copy node_modules preserving symlinks
      cp -r ${node_modules}/node_modules ./node_modules
      chmod -R +w ./node_modules

      # Patch shebangs - this will use nodejs from nativeBuildInputs for node scripts
      patchShebangs --build ./node_modules

      # Build the application using bun
      bun run build
    '';

    installPhase = ''
      mkdir -p $out

      # Copy built application
      cp -r dist $out/
      cp -r app/drizzle $out/drizzle
      cp package.json $out/
    '';
  };

in
stdenv.mkDerivation {
  pname = "zerobyte";
  inherit version src;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [
    restic
    rclone
    shoutrrr
    davfs2
    openssh
    fuse3
    sshfs
    tini
    nfs-utils
    cifs-utils
    util-linux
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/zerobyte,share/zerobyte}

    # Install the built application
    cp -r ${built_app}/dist/* $out/lib/zerobyte/
    cp ${built_app}/package.json $out/lib/zerobyte/

    # Copy migrations to the assets directory where the app expects them
    mkdir -p $out/lib/zerobyte/assets
    cp -r ${built_app}/drizzle $out/lib/zerobyte/assets/migrations

    # Also copy to share for reference
    cp -r ${built_app}/drizzle $out/share/zerobyte/migrations

    # Link node_modules for runtime
    ln -s ${node_modules}/node_modules $out/lib/zerobyte/node_modules

    # Create wrapper script using makeBinaryWrapper
    makeBinaryWrapper ${bun}/bin/bun $out/bin/zerobyte \
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          restic
          rclone
          shoutrrr
          davfs2
          openssh
          fuse3
          sshfs
          tini
          nfs-utils
          cifs-utils
          util-linux
        ]
      } \
      --set NODE_ENV "production" \
      --set APP_VERSION "${version}" \
      --set MIGRATIONS_FOLDER "$out/lib/zerobyte/assets/migrations" \
      --add-flags "$out/lib/zerobyte/server/index.js"

    # Copy licenses and notices
    if [ -f LICENSE ]; then cp LICENSE $out/share/zerobyte/; fi
    if [ -f LICENSE.md ]; then cp LICENSE.md $out/share/zerobyte/; fi
    if [ -f NOTICES.md ]; then cp NOTICES.md $out/share/zerobyte/; fi
    if [ -d LICENSES ]; then cp -r LICENSES $out/share/zerobyte/; fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "A web-based backup management system using restic";
    homepage = "https://github.com/nicotsx/zerobyte";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "zerobyte";
  };
}
