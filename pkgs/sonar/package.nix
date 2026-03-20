{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule rec {
  pname = "sonar";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "RasKrebs";
    repo = "sonar";
    tag = "v${version}";
    hash = "sha256-mAFrEi/CMYadb0LaHh9zN6PEXOW0vcq6F5N04+cR+8o=";
  };

  sourceRoot = "${src.name}/cli";
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
