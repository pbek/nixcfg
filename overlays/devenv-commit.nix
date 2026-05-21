final: prev:

let
  version = "2.1.3";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "a904b9b62d53399bb1c01b3ccf25255b59641b65";
    hash = "sha256-esZvb5j2bjfBBYjj6OPi4mGLfFuQ5uguBCLI1S0u40E=";
  };
  cargoHash = "sha256-ncQCfWil20jtpzszkTjF+3wvNcfb7T/wW1JC6bx720I=";
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
