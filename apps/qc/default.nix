{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "qc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    sha256 = "sha256-+Mkg8x9f6oqPqPrk6iCHH69+k0jhQGfjtbJwJPLc7Dw=";
  };

  vendorHash = "sha256-Cg1Op/4okIi2UTtqWnR0N3iMWzrYEaYxmXzvWIibftg=";

  ldflags = [
    "-s" "-w" "-X=github.com/qownnotes/qc/cmd.version=${version}"
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
    maintainers = with maintainers; [ pbek totoroot ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
