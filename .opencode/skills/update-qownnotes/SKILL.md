---
name: update-qownnotes
description: Update QOwnNotes in pkgs/qownnotes/package.nix non-interactively and commit the release hash change. Use when asked to update, bump, or upgrade QOwnNotes, including requests mentioning qownnotes-update-release.
---

# Update QOwnNotes

Update `pkgs/qownnotes/package.nix` to the requested QOwnNotes release, or to
the latest release when no version is specified. Complete the workflow without
asking for a version or opening an interactive prompt.

## Safety

- Run from the repository root.
- Do not modify, stage, commit, revert, or clean unrelated files.
- Before editing, require both `git diff --quiet -- pkgs/qownnotes/package.nix`
  and `git diff --cached --quiet -- pkgs/qownnotes/package.nix` to succeed. If
  either fails, stop and report that the package already has uncommitted work.
- Never push the resulting commit.

## Workflow

1. Read the current version from the top-level `version` attribute in
   `pkgs/qownnotes/package.nix`. Call it the old version.
2. If the user supplied a target version, strip an optional leading `v` and
   use it. Otherwise fetch the latest version non-interactively:

   ```bash
   version=$(curl -fsSL https://api.github.com/repos/pbek/QOwnNotes/releases/latest | jq -er '.tag_name | sub("^v"; "")')
   ```

   If GitHub's API fails, use this fallback:

   ```bash
   version=$(curl -fsSL https://api.qownnotes.org/latest_releases/linux | jq -er '.version')
   ```

3. Require the target to match `^[0-9]+\.[0-9]+\.[0-9]+$`. Stop without a
   commit if it equals the old version.
4. Prefetch the release archive and convert its SHA-256 hash to SRI form:

   ```bash
   url="https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz"
   hash=$(nix-prefetch-url --type sha256 "$url" | xargs nix hash convert --hash-algo sha256)
   ```

   Use the flat hash of the downloaded archive because `src` uses `fetchurl`.
   Never pass `--unpack`; that produces a recursive hash which `fetchurl` will
   reject.

5. Update only the `version` and `src.hash` string values in
   `pkgs/qownnotes/package.nix`. Do not run the interactive
   `just qownnotes-update-release` recipe.
6. Run `nix-instantiate --parse pkgs/qownnotes/package.nix >/dev/null`.
7. Run `nix build .#qownnotes --no-link`. Do not stage or commit the update
   unless the build succeeds.
8. Inspect `git diff -- pkgs/qownnotes/package.nix`. Require exactly two
   changed lines: the version and hash values. Confirm that the new values are
   the target version and the computed hash.
9. Stage only `pkgs/qownnotes/package.nix`, then inspect
   `git diff --cached -- pkgs/qownnotes/package.nix` and apply the same check.
10. Commit non-interactively with this exact subject, substituting the actual
    versions:

```text
qownnotes: <old-version> -> <new-version>
```

11. Report the commit hash, version transition, and validation performed.
