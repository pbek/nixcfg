final: _prev: {
  # Temporary: take wowup-cf directly from nixpkgs master for the latest
  # release until the updated package reaches this flake's nixos-unstable.
  # Remove this overlay once that happens.
  #
  # To update, replace rev and sha256 below with a fresh nixpkgs master
  # commit (get the NAR hash with `nix flake prefetch github:NixOS/nixpkgs/<rev>`).
  wowup-cf = final.callPackage (
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/f197bc36a0dadcfdd7465246c40ced4ca0e51074.tar.gz";
      sha256 = "sha256-cx43UD2qF7af4Y/IApSyyX2qRNEYH9x0pZEG52LXEtY=";
    }
    + "/pkgs/by-name/wo/wowup-cf/package.nix"
  ) { };
}
