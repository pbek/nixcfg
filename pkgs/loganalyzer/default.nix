{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtsvg,
  wrapQtAppsHook,
}:

let
  pname = "loganalyzer";
  appname = "LogAnalyzer";
  version = "23.5.1";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "${pname}";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-k9hOGI/TmiftwhSHQEh3ZVV8kkMSs1yKejqHelFSQJ4=";
  };

  buildInputs = [
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  sourceRoot = "source/src";

  # qmakeFlags = [
  #   "${appname}.pro"
  #   "CONFIG+=release"
  # ];
  buildPhase = ''
    runHook preBuild

    qmake ${appname}.pro CONFIG+=release PREFIX=/
    make

    runHook postBuild
  '';

  # installPhase = ''
  #   runHook preInstall

  #   make install PREFIX=$(out) INSTALL_ROOT=$(out)
  #   install -vD ${appname} $out/bin/${pname}

  #   runHook postInstall
  # '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall =
    # Create a lowercase symlink for Linux
    lib.optionalString stdenv.isLinux ''
      ln -s $out/bin/${appname} $out/bin/${pname}
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
