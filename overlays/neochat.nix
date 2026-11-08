# libQuotient's unreleased 0.10 branch replaces deprecated libolm with the
# Matrix Rust SDK. Keep this API-changing dependency scoped to NeoChat.
# https://github.com/quotient-im/libQuotient/issues/780
# Remove once nixpkgs ships the migration.
_final: prev:
let
  neochatPackages = prev.kdePackages.overrideScope (
    kfinal: kprev: {
      # Qt 6.12 can crash when an asynchronous action menu outlives its toolbar.
      # Patch the compiled QML modules, not just Kirigami's propagation wrapper.
      kirigami =
        let
          unwrapped = kprev.kirigami.unwrapped.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ ../pkgs/neochat/kirigami-synchronous-action-menu.patch ];
          });
        in
        kprev.kirigami.override { mkKdeDerivation = _: unwrapped; };
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
          # Keep desktop-session QML/plugin paths from loading a different Qt
          # build or unpatched Kirigami before this package's own dependencies.
          qtWrapperArgs = [
            "--unset"
            "QT_PLUGIN_PATH"
            "--unset"
            "QML_IMPORT_PATH"
            "--unset"
            "QML2_IMPORT_PATH"
            "--unset"
            "NIXPKGS_QT6_QML_IMPORT_PATH"
          ]
          ++ (old.qtWrapperArgs or [ ]);
        }
      );
    }
  );
}
