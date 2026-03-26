final: prev:

let
  # devenv 2.0.6
  # https://github.com/NixOS/nixpkgs/pull/502149
  nixpkgsPr502149 = prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "4fd6b31a326472305c2709c1ce7dc7a8ea5b839d";
    hash = "sha256-Nbq1syxcy6lJEZpgbHdxuDrfLM7C6fiTkoSxJKynLTU=";
  };
in
{
  devenv = final.callPackage "${nixpkgsPr502149}/pkgs/by-name/de/devenv/package.nix" { };
}
