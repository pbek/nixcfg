{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "go-passbolt-cli";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "go-passbolt-cli";
    rev = "v${version}";
    hash = "sha256-I+niNUowKTFDMa7yOnRToMFPzO/CbnjXHJr5nAhhHcg=";
  };

  # first use: lib.fakeHash
#  vendorHash = lib.fakeHash;
  vendorHash = "sha256-XRHGq3Qeq7VWHzw5WWVv4x5orQu740lttGVreiu7qP4=";

  ldflags = [
    "-X=main.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    install -D $GOPATH/bin/go-passbolt-cli $out/bin/passbolt

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd passbolt \
      --bash <($out/bin/passbolt completion bash) \
      --fish <($out/bin/passbolt completion fish) \
      --zsh <($out/bin/passbolt completion zsh)
  '';

  meta = with lib; {
    description = "CLI tool to interact with Passbolt, an Open source Password Manager for teams";
    homepage = "https://www.passbolt.com";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
