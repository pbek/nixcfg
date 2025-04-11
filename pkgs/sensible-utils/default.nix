{
  stdenv,
  lib,
  fetchgit,
  makeWrapper,
  bash,
}:

let
  pname = "sensible-utils";
  version = "0.0.18";
in
stdenv.mkDerivation rec {
  inherit pname version;

  # https://salsa.debian.org/debian/sensible-utils
  src = fetchgit {
    url = "https://salsa.debian.org/debian/sensible-utils.git";
    rev = "debian/${version}";
    sha256 = "sha256-fZJKPnEkPfo/3luUcHzAmGB2k1nkA4ATEQMSz0aN0YY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  configurePhase = ''
    # We don't want to use configure!
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp sensible-browser $out/bin/sensible-browser
    wrapProgram $out/bin/sensible-browser \
      --prefix PATH : ${lib.makeBinPath [ bash ]}

    cp sensible-editor $out/bin/sensible-editor
    wrapProgram $out/bin/sensible-editor \
      --prefix PATH : ${lib.makeBinPath [ bash ]}

    cp sensible-pager $out/bin/sensible-pager
    wrapProgram $out/bin/sensible-pager \
      --prefix PATH : ${lib.makeBinPath [ bash ]}

    cp sensible-terminal $out/bin/sensible-terminal
    wrapProgram $out/bin/sensible-terminal \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  meta = with lib; {
    description = "This package provides a number of small utilities which are used by programs to sensibly select and spawn an appropriate browser, editor, or pager. The specific utilities included are: sensible-browser sensible-editor sensible-pager";
    homepage = "https://salsa.debian.org/debian/sensible-utils";
    changelog = "https://salsa.debian.org/debian/sensible-utils/-/tags";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}
