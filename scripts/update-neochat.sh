#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

repo="https://invent.kde.org/pbek/neochat"
branch="personal/master"
overlay="overlays/neochat.nix"

rev=$(git ls-remote --exit-code "$repo.git" "refs/heads/$branch" | awk '{print $1}')
if [[ ! "$rev" =~ ^[0-9a-f]{40}$ ]]; then
  echo "Could not resolve $branch to a commit" >&2
  exit 1
fi

# Hash the unpacked archive, matching fetchFromGitLab in the overlay.
url="$repo/-/archive/$rev/neochat-$rev.tar.gz"
hash=$(nix store prefetch-file --unpack --json "$url" | jq -er '.hash')

# Only edit after both the commit and its hash have been fetched successfully.
sed -i \
  -e "s|rev = \"[0-9a-f]\{40\}\";|rev = \"$rev\";|" \
  -e "s|hash = \"sha256-[A-Za-z0-9+/]*=*\";|hash = \"$hash\";|" \
  "$overlay"

echo "Updated $overlay to $branch at $rev ($hash)"
echo "Build with: nix build .#neochat -L"
