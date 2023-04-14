{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "qc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    sha256 = "sha256-6dH7pmsd7kUgwHplvCfNqoq/ucDY/UZnyVxC3VvV+fQ=";
  };

  vendorSha256 = "sha256-7t5rQliLm6pMUHhtev/kNrQ7AOvmA/rR93SwNQhov6o=";

  ldflags = [
    "-s -w -X github.com/qownnotes/qc/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd qc \
      --zsh ./misc/completions/zsh/_qc
  '';

  meta = with lib; {
    description = "QOwnNotes command-line snippet manager";
    homepage = "https://github.com/qownnotes/qc";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}