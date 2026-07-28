final: prev:

let
  # devenv 2.2.0
  # https://github.com/NixOS/nixpkgs/pull/546784
  nixpkgsPr546784 = prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "b266e7d2fc3562d97a8b5ed91cc914e8dac4a4c1";
    hash = "sha256-HevLsehJQgz1xpoXK+Gk+fQTIMGZnnrp39J+1O3LvJc=";
  };
  libghostty-vt =
    final.callPackage "${nixpkgsPr546784}/pkgs/by-name/li/libghostty-vt/package.nix"
      { };
in
{
  devenv = final.callPackage "${nixpkgsPr546784}/pkgs/by-name/de/devenv/package.nix" {
    inherit libghostty-vt;
  };
}
