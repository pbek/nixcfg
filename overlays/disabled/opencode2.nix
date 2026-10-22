# Disabled: nixpkgs now provides OpenCode 2.x as opencode.
_self: super: {
  opencode2 = super.callPackage ../../pkgs/opencode2/package.nix { };
}
