final: prev:

let
  version = "2.1.3";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "5f1cf17be0fc48689bd0ecb810de6d2e06d259a1";
    hash = "sha256-Gof6j4d43yX2qSLLp78JILke346IggDFIxTgl3ecVQE=";
  };
  cargoHash = "sha256-9Iz+HYQCrcEqF6x/vgw7n+eYBzHMRcWLYnNJlBFb9DI=";

  nixVersion = "2.34";
  nixSrc = final.fetchFromGitHub {
    owner = "cachix";
    repo = "nix";
    rev = "782ac1b155679b065ec945ae50d0fa1d495883b7";
    hash = "sha256-xem+4ncdQCTFJsQ4PrVuyVmi3j4w/Yqg298hBUzVejA=";
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
