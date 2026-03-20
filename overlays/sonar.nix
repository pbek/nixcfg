# Overlay adding sonar package
_self: super: {
  sonar = super.callPackage ../pkgs/sonar/package.nix { };
}
