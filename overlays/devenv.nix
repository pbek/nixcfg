_final: prev: {
  # Override devenv with version from specific nixpkgs commit
  devenv =
    let
      # Pin nixpkgs to the specific commit
      pinnedNixpkgs = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/870493f9a8cb0b074ae5b411b2f232015db19a65.tar.gz";
        sha256 = "045sqv2qym9hmly6c2khpbawwn26084x8lxz7qs0zqd5y9ahdjq4";
      };
      # Import the pinned nixpkgs
      pinnedPkgs = import pinnedNixpkgs {
        system = prev.system;
        config = prev.config;
      };
    in
    pinnedPkgs.devenv;
}
