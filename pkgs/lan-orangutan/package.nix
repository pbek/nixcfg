{
  buildGoModule,
  fetchFromGitHub,
  iproute2,
  lib,
  makeWrapper,
  nix-update-script,
  nmap,
}:

buildGoModule rec {
  pname = "lan-orangutan";
  version = "3.3.8";

  src = fetchFromGitHub {
    owner = "291-Group";
    repo = "LAN-Orangutan";
    tag = "v${version}";
    hash = "sha256-bXhpESrD9XeDYHfymv6M2ERxxFCuqBARZhaNWakd7/U=";
  };

  vendorHash = "sha256-oa5QHVlhj5Vhkib53IAgq3uCI2bR+kdDKaouHu+6ufg=";

  subPackages = [ "./cmd/orangutan" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/291-Group/LAN-Orangutan/internal/cli.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/orangutan" \
      --prefix PATH : ${
        lib.makeBinPath [
          iproute2
          nmap
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted network discovery tool for homelabs";
    homepage = "https://github.com/291-Group/LAN-Orangutan";
    changelog = "https://github.com/291-Group/LAN-Orangutan/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbek ];
    mainProgram = "orangutan";
    platforms = lib.platforms.linux;
  };
}
