build:
	nix-build -E '((import <nixpkgs> {}).libsForQt5.callPackage (import ./default.nix) { })'

build-force:
	nix-build -E '((import <nixpkgs> {}).libsForQt5.callPackage (import ./default.nix) { })' --check
