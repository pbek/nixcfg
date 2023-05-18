{ lib
, stdenv
, fetchurl
, qtbase
, qtsvg
, wrapQtAppsHook
}:

let
  pname = "loganalyzer";
  appname = "LogAnalyzer";
  version = "23.5.0";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
    url = "https://github.com/pbek/${pname}/releases/download/v${version}/source.tar.gz";
    hash = "sha256-vmtUNU3w/iNoGCUyZgxup5kXqwb+o+0foQa/bd6IhAE=";
  };

  buildInputs = [
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildPhase = ''
    qmake ${appname}.pro CONFIG+=release
    make
  '';

  installPhase = ''
    install -vD ${appname} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Tool that helps you to analyze your log files by reducing the content with patterns you define";
    homepage = "https://bekerle.com/posts/loganalyzer";
    changelog = "https://github.com/pbek/loganalyzer/blob/develop/CHANGELOG.md";
    downloadPage = "https://github.com/pbek/loganalyzer/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}
