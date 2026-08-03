{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "qc";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    hash = "sha256-Z96wEb9jTf3zeIxgHJMBl7OQHeEIrP/uIcJncXggA/g=";
  };

  vendorHash = "sha256-/nRPv6SlvWV8mHlQstV19BLou9iwGt/VvJbrpVwiTCU=";

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
