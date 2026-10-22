# Overlay adding OpenChamber (uses upstream nixpkgs OpenCode 2.x)
self: super: {
  openchamber = super.callPackage ../pkgs/openchamber/package.nix { inherit (self) opencode; };
}
