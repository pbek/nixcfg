{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  corrosion,
  extra-cmake-modules,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  openssl,
  sqlite,
  qtbase,
  qtdeclarative,
  qtkeychain,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libquotient";
  version = "0.10.0-alpha-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = "d8150bd555554ff87fe15111bbd0ea0172ee3de4";
    hash = "sha256-QaJoWCcmX4LJ2RXUC6HnmKh0pxMfGJ/62nzfe+cpLAE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoRoot = "Quotient/crypto-sdk";
  # Upstream does not ship a lockfile; pin the Rust dependency graph locally.
  postPatch = ''
    cp ${./Cargo.lock} ${finalAttrs.cargoRoot}/Cargo.lock
    # Nix uses absolute install directories, including a separate dev output.
    substituteInPlace Quotient.pc.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "source/${finalAttrs.cargoRoot}";
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';
    hash = "sha256-He6wg2byNr/kXY+6UL/YypUGSn5rHQiN37efcr0OU0w=";
  };

  nativeBuildInputs = [
    cmake
    corrosion
    extra-cmake-modules
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  buildInputs = [ qtdeclarative ];
  propagatedBuildInputs = [
    qtbase
    qtkeychain
    openssl
    sqlite
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_TESTING=OFF"
  ];
  env.CARGO_NET_OFFLINE = "true";
  dontWrapQtApps = true;

  postInstall = ''
    # Unused Android export introduces a cyclic output reference.
    rm $out/share/ndk-modules/Android.mk
  '';

  meta = {
    description = "Matrix client library using Matrix Rust SDK cryptography instead of libolm";
    homepage = "https://github.com/quotient-im/libQuotient";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
