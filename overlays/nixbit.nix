# Overlay adding local packages
_self: super: {
  # Provide nixbit from local pkgs/nixbit/package.nix
  nixbit = super.callPackage ../pkgs/nixbit/package.nix;
}
