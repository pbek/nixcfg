# Overlay adding ziggity package
_self: super: {
  ziggity = super.callPackage ../pkgs/ziggity/package.nix { };
}
