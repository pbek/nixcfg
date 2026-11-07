# libQuotient's unreleased 0.10 branch replaces deprecated libolm with the
# Matrix Rust SDK. Keep this API-changing dependency scoped to NeoChat.
# https://github.com/quotient-im/libQuotient/issues/780
# Remove once nixpkgs ships the migration.
_final: prev:
let
  neochatPackages = prev.kdePackages.overrideScope (
    kfinal: _kprev: {
      libquotient = kfinal.callPackage ../pkgs/libquotient-rust-crypto/package.nix { };
    }
  );
in
{
  kdePackages = prev.kdePackages.overrideScope (
    _kfinal: _kprev: {
      neochat = neochatPackages.neochat.overrideAttrs (
        finalAttrs: old: {
          version = "unstable-${builtins.substring 0 7 finalAttrs.src.rev}";
          # personal/master includes our changes without local backport patches.
          # Refresh this immutable pin with `just neochat-update`.
          src = prev.fetchFromGitLab {
            domain = "invent.kde.org";
            owner = "pbek";
            repo = "neochat";
            rev = "f6d39553480e161f3ebe1c25d21da548cbbb697e";
            hash = "sha256-JSHRzKF/iTsUToTlKo70smkWXRNLQjw4iGd607igQkU=";
          };
          # master requires this library; the packaged release does not yet use it.
          buildInputs = (old.buildInputs or [ ]) ++ [ neochatPackages.kirigami-app-components ];
          # libQuotient 0.10's CMake config locates SQLite using pkg-config.
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.pkg-config ];
        }
      );
    }
  );
}
