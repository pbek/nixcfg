{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "sonar";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "RasKrebs";
    repo = "sonar";
    tag = "v${version}";
    hash = "sha256-rEAc0lmpxxnaS1kwyPPW6LE4XxjAItIV/vjYTRm+Cvw=";
  };

  vendorHash = "sha256-komX1AmHt2NoF1x6xsNa2RFkfVzOXfYEMPhT0zwMxjw=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/raskrebs/sonar/internal/selfupdate.Version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sonar \
      --bash <($out/bin/sonar completion bash) \
      --fish <($out/bin/sonar completion fish) \
      --zsh <($out/bin/sonar completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI tool for inspecting and managing services listening on localhost ports";
    homepage = "https://github.com/RasKrebs/sonar";
    changelog = "https://github.com/RasKrebs/sonar/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pbek ];
    mainProgram = "sonar";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
