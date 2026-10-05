# Overlay adding OpenCode 2.x (side-by-side with the nixpkgs OpenCode 1.x)
_self: super: {
  opencode2 = super.callPackage ../pkgs/opencode2/package.nix { };
}
