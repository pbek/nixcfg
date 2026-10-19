# NeoChat without libolm

`overlays/neochat.nix` builds NeoChat against a pinned snapshot of libQuotient's
unreleased 0.10 branch. This branch replaces deprecated libolm with the Matrix
Rust SDK (using vodozemac), keeping end-to-end encryption enabled. The replacement
is scoped to NeoChat; other libQuotient consumers are unchanged. No insecure
package exceptions or security metadata overrides are used.

Run from the repository root:

```sh
nix run .#neochat
```

`nix run nixpkgs#kdePackages.neochat` does not use this repository's overlays.
The Build Apps CI workflow and `just push` build `.#neochat` and upload its full
runtime closure to the `qownnotes` Attic cache, including the replacement library.
New files must be added to Git before a Git-backed flake includes them; during
development, `nix run path:.#neochat` also includes untracked files.

This is **pre-release cryptography integration**, not a security audit. Back up
your NeoChat data and ensure you have your recovery key before using it with an
existing account. Build/startup checks cannot establish encrypted messaging,
verification, or migration correctness; test those separately before relying on
this version.

Upstream migration: <https://github.com/quotient-im/libQuotient/pull/820> (merged
April 20, 2026; the security tracking issue was closed in July).
Nixpkgs discussion: <https://github.com/NixOS/nixpkgs/issues/501884>. As checked
on October 19, 2026, nixpkgs master still packages libQuotient 0.9.6.1 with libolm;
the migration has not yet appeared in a published libQuotient release.
Remove the overlay and local package when nixpkgs includes this migration.

## Rust dependency pinning

Upstream does not include a `Cargo.lock`. The local lockfile was generated from
the pinned source's `Quotient/crypto-sdk/Cargo.toml` using `cargo generate-lockfile`.
It is copied into both the library build and the Cargo vendor derivation. When
updating the source, regenerate the lockfile and update the vendor hash together.
