# Overlay adding corgi package
_self: super: {
  corgi = super.callPackage ../pkgs/corgi/package.nix { };
}
