build:
	nix-build -E '((import <nixpkgs> {}).callPackage (import ./default.nix) { })'

edit-app:
	cd ~/Code/_fork/nixpkgs || cd ~/Code/nixpkgs; kate ./pkgs/development/tools/qc/default.nix
