# Overlay adding local packages
_self: super: {
  # Provide qownnotes from local pkgs/qownnotes/package.nix
  qownnotes = super.callPackage ../pkgs/qownnotes/package.nix {
    # Dummy nixosTests attr so passthru.tests reference resolves
    nixosTests = {
      qownnotes = super.runCommand "dummy-qownnotes-nixos-test" { } "mkdir -p $out";
    };
  };
}
