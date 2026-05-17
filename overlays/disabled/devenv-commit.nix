final: prev:

let
  version = "2.1.2";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "c733274dc2900f4bf8b3de279de8c5577930d982";
    hash = "sha256-uX572+AJ1TAXZDg+npJFq5LMGIGg9IzffhDqcUJsdA0=";
  };
  cargoHash = "sha256-uEwxqnLqCFpyV2NbnfuUyVqKrMeVeQzoGQmElaVeGU8=";
in
{
  devenv = prev.devenv.overrideAttrs (
    _finalAttrs: _previousAttrs: {
      inherit version src cargoHash;

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        pname = "devenv";
        inherit version src;
        hash = cargoHash;
      };
    }
  );
}
