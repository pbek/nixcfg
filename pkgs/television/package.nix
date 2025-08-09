{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  testers,
  television,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "television";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    tag = version;
    hash = "sha256-wfIzmk4mCSdfSAJP2DcnpuQAg62m6CfynmxoH580k9A=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-C/umcbD/wb+Bz9Qbp7gx70Cr5blcXgEqsIfLKefZrrY=";

  passthru = {
    tests.version = testers.testVersion {
      package = television;
      command = "XDG_DATA_HOME=$TMPDIR tv --version";
    };
    updateScript = nix-update-script { };
  };

  #  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
  #    if [[ -f $out/bin/tv ]]; then
  #      export HOME=$(mktemp -d)
  #      installShellCompletion --cmd tv \
  #        --bash --name tv.bash <($out/bin/tv init bash) \
  #        --fish --name tv.fish <($out/bin/tv init fish) \
  #        --zsh --name tv.zsh <($out/bin/tv init zsh)
  #    fi
  #  '';

  postInstall = ''
    export HOME=$(mktemp -d)
    installShellCompletion --cmd tv \
      --bash --name tv.bash <($out/bin/tv init bash) \
      --fish --name tv.fish <($out/bin/tv init fish) \
      --zsh --name tv.zsh <($out/bin/tv init zsh)
  '';

  #  postInstall = ''
  #    export HOME=$(mktemp -d)
  #    installShellCompletion --cmd tv \
  #      --bash <($out/bin/tv init bash) \
  #      --fish <($out/bin/tv init fish) \
  #      --zsh <($out/bin/tv init zsh)
  #  '';

  meta = {
    description = "Blazingly fast general purpose fuzzy finder TUI";
    longDescription = ''
      Television is a fast and versatile fuzzy finder TUI.
      It lets you quickly search through any kind of data source (files, git
      repositories, environment variables, docker images, you name it) using a
      fuzzy matching algorithm and is designed to be easily extensible.
    '';
    homepage = "https://github.com/alexpasmantier/television";
    changelog = "https://github.com/alexpasmantier/television/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "tv";
    maintainers = with lib.maintainers; [
      louis-thevenet
      getchoo
    ];
  };
}
