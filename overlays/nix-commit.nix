final: prev:

let
  rev = "078bffe9902c500d82eb6d480990f3be0d79d22e";
  version = "2.35.0-cachix-${builtins.substring 0 8 rev}";
  src = final.fetchFromGitHub {
    owner = "cachix";
    repo = "nix";
    inherit rev;
    hash = "sha256-C6Wv1eB0eqkTbI8/km21LY4s+/lGylYkeQ4knrZk5/o=";
  };

  nixComponents_cachix_base =
    prev.nixDependencies.callPackage
      "${prev.path}/pkgs/tools/package-management/nix/modular/packages.nix"
      {
        inherit version src;
        teams = [
          final.lib.teams.nix
          final.lib.teams.security-review
        ];
        otherSplices = prev.generateSplicesForMkScope [
          "nixVersions"
          "nixComponents_cachix"
        ];
      };

  nixComponents_cachix = nixComponents_cachix_base.overrideAllMesonComponents (
    _finalAttrs: previousAttrs:
    (final.lib.optionalAttrs (previousAttrs.pname or null == "nix") {
      mesonFlags = builtins.filter (flag: !(final.lib.hasPrefix "-Dmimalloc=" flag)) (
        previousAttrs.mesonFlags or [ ]
      );
    })
    // (final.lib.optionalAttrs (previousAttrs.pname or null == "nix-functional-tests") {
      mesonCheckFlags = (previousAttrs.mesonCheckFlags or [ ]) ++ [
        "--no-suite"
        "local-overlay-store"
      ];
    })
  );

  nix = nixComponents_cachix.nix-everything;
in
{
  inherit nix;

  nixVersions = prev.nixVersions.extend (
    _finalScope: _previousScope: {
      inherit nixComponents_cachix;
      latest = nix;
    }
  );
}
