{
  config,
  fetchFromGitHub,
  hidapi,
  kmod,
  lib,
  python3,
  toybox,
  coreutils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    rev = "v${version}";
    hash = "sha256-fsH8H6ZhiguOWI2t79GnxqAmqL/1m06RQzs+k8bUWcU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    evdev
    hidapi
    kmod
    pyyaml
    rich
    setuptools
    toybox
    xlib
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  # handheld-daemon contains a fork of the python module `hid`, so this hook
  # is borrowed from the `hid` derivation.
  postPatch = ''
    hidapi=${hidapi}/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" src/hhd/controller/lib/hid.py

    # The generated udev rules point to /bin/chroot, which does not exist in NixOS
    chmod=${coreutils}/bin/chmod
    sed -i -e "s|/bin/chmod|$chmod|" src/hhd/controller/lib/hide.py
  '';

  postInstall = ''
    install -Dm644 $src/usr/lib/udev/rules.d/83-hhd.rules -t $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/hhd/";
    description = "Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ appsforartists ];
    mainProgram = "hhd";
  };
}
