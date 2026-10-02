# Overlay adding rhun package
_self: super: {
  rhun = super.callPackage ../pkgs/rhun/package.nix { };
}
