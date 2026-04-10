# Provide a non-deprecated hostPlatform auto-arg for packages that still
# declare `hostPlatform` directly and are instantiated via callPackage.
_self: super: {
  inherit (super.stdenv) hostPlatform;
}
