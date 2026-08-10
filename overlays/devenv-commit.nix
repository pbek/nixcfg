final: prev:

let
  version = "2.2.2";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "4158f6bffa1ac70104e390f8b5b5f59b3a23cbb0";
    hash = "sha256-XtGARxGaiWgeWDvg3D3gVmynCtVnoBsEh/hQm8oVLe0=";
  };
  cargoHash = "sha256-PrGUXPEkpDZPdifb7ha5AeOHYt4Ga8C/87wIKPh9T8Q=";

  nixVersion = "2.34";
  nixSrc = final.fetchFromGitHub {
    owner = "cachix";
    repo = "nix";
    rev = "59407321a92f7d34d4a53e38959294007c0bc37a";
    hash = "sha256-WcqKvA7f7TGrlDVd69T1UXUqVXJ+wfoRbO+mg5L7/Rc=";
  };

  nixComponents = (prev.nixVersions.nixComponents_git.overrideSource nixSrc).overrideScope (
    _finalScope: _prevScope: {
      version = nixVersion;
    }
  );
in
{
  devenv = prev.devenv.overrideAttrs (
    _finalAttrs: previousAttrs: {
      inherit version src cargoHash;

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        pname = "devenv";
        inherit version src;
        hash = cargoHash;
      };

      buildInputs = [
        nixComponents.nix-expr-c
        nixComponents.nix-store-c
        nixComponents.nix-util-c
        nixComponents.nix-flake-c
        nixComponents.nix-cmd-c
        nixComponents.nix-fetchers-c
        nixComponents.nix-main-c
      ]
      ++ (previousAttrs.buildInputs or [ ]);
    }
  );
}
