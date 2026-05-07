{
  lib,
  stdenv,
  cctools,
  fetchFromGitHub,
  fixDarwinDylibNames,
  gitMinimal,
  ncurses,
  pkg-config,
  xcbuild,
  zig_0_15,

  libghostty-vt-deps,

  optimize ? "ReleaseFast",
  simd ? true,
}:
let
  zigPlatforms = zig_0_15.meta.platforms;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libghostty-vt";
  version = "0.1.0-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "1547dd667ab6d1f4ebcdc7282adc54c95752ee67";
    hash = "sha256-dZFc+8az7BUIs8+v45XqNnY5G6oXEwVfVVHZQuATSGQ=";
  };

  deps = libghostty-vt-deps;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    gitMinimal
    ncurses
    pkg-config
    zig_0_15
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    fixDarwinDylibNames
    xcbuild
  ];

  buildInputs = [ ];

  dontSetZigDefaultFlags = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dlib-version-string=${finalAttrs.version}"
    "-Dcpu=baseline"
    "-Doptimize=${optimize}"
    "-Dapp-runtime=none"
    "-Demit-lib-vt=true"
    "-Dsimd=${lib.boolToString simd}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Demit-xcframework=false"
  ];

  doCheck = false;

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p "$dev/lib"
    mv "$out/lib/libghostty-vt.a" "$dev/lib/"
  '';

  postFixup = ''
    substituteInPlace "$dev/share/pkgconfig/libghostty-vt-static.pc" \
      --replace-fail "$out" "$dev"
  '';

  meta = {
    description = "Ghostty's VT (terminal sequence) parsing library";
    homepage = "https://ghostty.org/";
    license = lib.licenses.mit;
    pkgConfigModules = [
      "libghostty-vt"
      "libghostty-vt-static"
    ];
    maintainers = with lib.maintainers; [ domenkozar ];
    platforms = zigPlatforms;
  };
})
