{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3;
in python.pkgs.buildPythonApplication rec {
  pname = "jimmy";
  version = "0.0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marph91";
    repo = "jimmy";
    rev = "v${version}";
    hash = "sha256-dKLLGrFmoA8RfLyLUsVeO74JRdLV4YfSO4C8Yy8F148=";
  };

#  postPatch = ''
#    # only setup.py has up to date dependencies
#    rm pyproject.toml
#  '';
#
#  nativeBuildInputs = with python.pkgs; [
#    setuptools
#  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/marph91/jimmy/releases/tag/${src.rev}";
    description = " Convert your notes to Markdown";
    homepage = "https://github.com/marph91/jimmy";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.pbek ];
  };
}
