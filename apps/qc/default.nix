{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "qc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    sha256 = "sha256-lNS2wrjG70gi6mpIYMvuusuAJL3LkAVh8za+KnBTioc=";
  };

  vendorSha256 = "sha256-7t5rQliLm6pMUHhtev/kNrQ7AOvmA/rR93SwNQhov6o=";

  ldflags = [
    "-s" "-w" "-X=github.com/qownnotes/qc/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd qc \
         --bash <($out/bin/qc completion bash) \
         --fish <($out/bin/qc completion fish) \
         --zsh <($out/bin/qc completion zsh)
  '';

  meta = with lib; {
    description = "QOwnNotes command-line snippet manager";
    homepage = "https://github.com/qownnotes/qc";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek totoroot ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
