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
      neochat = neochatPackages.neochat.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          # Remove once NeoChat includes https://invent.kde.org/network/neochat/-/merge_requests/3086.
          ./kde/neochat-mark-all-chats-as-read.patch
          # Remove once NeoChat includes https://invent.kde.org/network/neochat/-/merge_requests/3087.
          ./kde/neochat-show-all-chats-in-home.patch
          # Remove once NeoChat includes https://invent.kde.org/network/neochat/-/merge_requests/3088.
          ./kde/neochat-search-encrypted-rooms.patch
        ];
        # libQuotient 0.10's CMake config locates SQLite using pkg-config.
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.pkg-config ];
      });
    }
  );
}
