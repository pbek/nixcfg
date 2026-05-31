# Overlay adding codexbar-cli package
_self: super: {
  codexbar-cli = super.callPackage ../pkgs/codexbar-cli/package.nix { };
}
