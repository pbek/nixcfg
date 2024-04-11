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
, qt5compat
, makeWrapper
, wrapQtAppsHook
, botan2
, pkg-config
, installShellFiles
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "24.4.1";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz";
    hash = "sha256-E4tLlzjIOElsZr2jcbsnge5jJqKQ0kWf86tFonZ1+Zs=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
    pkg-config
    installShellFiles
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    qt5compat
    botan2
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  qmakeFlags = [
    "USE_SYSTEM_BOTAN=1"
  ];

  postInstall = ''
    # we need a writable home directory, or the completion files will be empty
    export HOME=$(mktemp -d)
    installShellCompletion --cmd ${appname} \
      --bash <($out/bin/${appname} --completion bash) \
      --fish <($out/bin/${appname} --completion fish)
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${appname} --completion bash) \
      --fish <($out/bin/${appname} --completion fish)
  ''
  # Create a lowercase symlink for Linux
  + lib.optionalString stdenv.isLinux ''
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
    maintainers = with maintainers; [ pbek totoroot ];
    platforms = platforms.unix;
  };
}
