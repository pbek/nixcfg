# Overlay adding zerobyte package
_self: super: {
  # Provide zerobyte from local pkgs/zerobyte/package.nix
  zerobyte = super.callPackage ../pkgs/zerobyte/package.nix { };
}
