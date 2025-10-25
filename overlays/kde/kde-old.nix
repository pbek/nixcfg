_final: prev:

let
  oldNixpkgs =
    import
      (prev.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "95625320bff6b09ab0d6d268626444bb9571eb57";
        sha256 = "sha256-OFcTuiCmh8g+kBMfUhr4ltaJdZdaLhG9TPV1UPoZ9Kc=";
      })
      {
        inherit (prev) system;
        config.allowUnfree = true;
      };
in
{
  kdePackages = oldNixpkgs.kdePackages // {
    knighttime = prev.kdePackages.knighttime;
  };
  qt6 = oldNixpkgs.qt6;
}
