{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "qc";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    hash = "sha256-Y7SjlVNiZjWDTRPNZfyoFjI5qyo2SHgTPurNJzGmN0k=";
  };

  vendorHash = "sha256-ad4IuGv2y4L9cS7pf/fEVJ3wXwy9pEIegMTbUoJHPmg=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/qownnotes/qc/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    # for some reason we need a writable home directory, or the completion files will be empty
    export HOME=$(mktemp -d)
    installShellCompletion --cmd qc \
      --bash <($out/bin/qc completion bash) \
      --fish <($out/bin/qc completion fish) \
      --zsh <($out/bin/qc completion zsh)
  '';

  meta = with lib; {
    description = "QOwnNotes command-line snippet manager";
    homepage = "https://github.com/qownnotes/qc";
    license = licenses.mit;
    maintainers = with maintainers; [
      pbek
      totoroot
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
