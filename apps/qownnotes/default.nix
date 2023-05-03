{ lib
, stdenv
, fetchurl
, qmake
, qttools
, qtbase
, qtdeclarative
, qtsvg
, qtwayland
, qtwebsockets
, qtx11extras
, makeWrapper
, wrapQtAppsHook
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "23.5.1";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-q+qBR5xec7gV7vUZ0iKXGPp+btbGrArK5KBM+C0LvZ4=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    qtx11extras
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  postInstall =
  # Create a lowercase symlink for Linux
  lib.optionalString stdenv.isLinux ''
    ln -s $out/bin/${appname} $out/bin/${pname}
  ''
  # Wrap application for macOS as lowercase binary
  + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/${appname}.app $out/Applications
    makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    changelog = "https://www.qownnotes.org/changelog.html";
    downloadPage = "https://github.com/pbek/QOwnNotes/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}
