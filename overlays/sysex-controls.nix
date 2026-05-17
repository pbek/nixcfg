# Overlay adding sysex-controls package
_self: super: {
  sysex-controls = super.callPackage ../pkgs/sysex-controls/package.nix { };
}
