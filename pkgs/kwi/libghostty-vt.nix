{
  lib,
  stdenv,
  ghostty,
  ncurses,
  pkg-config,
  zig_0_17,
}:

# Kwi requires APIs newer than nixpkgs' standalone libghostty-vt snapshot.
# Reuse the pinned Ghostty source and Zig dependencies, but build only its VT library.
stdenv.mkDerivation {
  pname = "libghostty-vt";
  inherit (ghostty) version src;

  strictDeps = true;
  nativeBuildInputs = [
    ncurses
    pkg-config
    zig_0_17
  ];

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "--system"
    "${ghostty.deps}"
    "-Dversion-string=${ghostty.version}"
    "-Dlib-version-string=${ghostty.version}"
    "-Dcpu=baseline"
    "-Doptimize=ReleaseFast"
    "-Dapp-runtime=none"
    "-Demit-lib-vt=true"
    "-Demit-themes=false"
    "-Demit-terminfo=false"
    "-Di18n=false"
  ];

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
    description = "Ghostty's terminal parsing and state library for Kwi";
    homepage = "https://ghostty.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
