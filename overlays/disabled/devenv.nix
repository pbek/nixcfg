final: prev:

let
  nixpkgsPr500565 = prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "eceb958e81e7219514c19a908e3c05f21d4c77a2";
    hash = "sha256-WCSNXrp3pFc1O1eNs8ZIJet1zQ+NUOhwiYfGleg7ep0=";
  };
in
{
  devenv = final.callPackage "${nixpkgsPr500565}/pkgs/by-name/de/devenv/package.nix" { };
}
