# Overlay adding gh-stack package
_self: super: {
  gh-stack = super.callPackage ../pkgs/gh-stack/package.nix { };
}
