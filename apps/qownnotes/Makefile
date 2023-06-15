build:
	nix-build -E '((import <nixpkgs> {}).qt6Packages.callPackage (import ./default.nix) { })'

ui-tests:
	cd ~/Code/_fork/nixpkgs || cd ~/Code/nixpkgs; nix-build . -A nixosTests.qownnotes

ui-tests-logs:
	cd ~/Code/_fork/nixpkgs || cd ~/Code/nixpkgs; nix-store --read-log result
