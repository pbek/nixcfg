{ nixpkgsSource }:
final: _prev: {
  # Remove this overlay once NixOS/nixpkgs#557765 reaches nixos-unstable.
  zerobyte = final.callPackage (nixpkgsSource + "/pkgs/by-name/ze/zerobyte/package.nix") { };
}
