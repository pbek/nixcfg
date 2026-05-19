final: prev:

let
  version = "2.1.3";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "8eff3cd84a4c2a86a02fe706582ae348650e3e76";
    hash = "sha256-ekzTg0h7hb/FYF5XhTWC1J2MFGEs8yuEasVsQliJ6ek=";
  };
  cargoHash = "sha256-O2v0BAXt2RjYAMUEjHiqV9CPmsOumv+i5bTe1vTgubM=";
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
