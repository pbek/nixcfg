# Overlay adding OpenChamber (uses opencode2 from overlays/opencode2.nix)
self: super: {
  openchamber = super.callPackage ../pkgs/openchamber/package.nix { inherit (self) opencode2; };
}
