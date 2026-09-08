final: prev:

let
  # devenv 2.3.0
  # https://github.com/NixOS/nixpkgs/pull/560896
  nixpkgsPr560896 = prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "89ea88681d92c564085254528206f7587912f0c1";
    hash = "sha256-6CjA0V0oV53SCXsg9x14+HfqCV2cyQ+D0ZUTs30SKtc=";
  };
in
{
  devenv = final.callPackage "${nixpkgsPr560896}/pkgs/by-name/de/devenv/package.nix" { };
}
