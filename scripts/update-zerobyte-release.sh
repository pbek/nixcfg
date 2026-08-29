#!/usr/bin/env bash

set -euo pipefail

# Get version number from argument, user input or API
version="${1:-}"

if [ -z "$version" ]; then
  if command -v gum >/dev/null 2>&1; then
    version=$(gum input --placeholder "Zerobyte version (empty for latest)")
  fi
fi

if [ -z "$version" ]; then
  version=$(curl -fsSL https://api.github.com/repos/nicotsx/zerobyte/releases/latest |
    jq -er '.tag_name | sub("^v"; "")')
fi

echo "Using version $version..."

# Update the version and reset hashes in package.nix
sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|" pkgs/zerobyte/package.nix
sed -i "s|hash = \"sha256-[A-Za-z0-9+/]*=*\";|hash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";|" pkgs/zerobyte/package.nix
sed -i "s|outputHash = \"sha256-[A-Za-z0-9+/]*=*\";|outputHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";|" pkgs/zerobyte/package.nix

# Update the Docker image tag (major.minor) in the hokage module
image_tag="v$(echo "$version" | cut -d. -f1,2)"
sed -i "s|ghcr.io/nicotsx/zerobyte:v[0-9.]*|ghcr.io/nicotsx/zerobyte:${image_tag}|" modules/hokage/programs/zerobyte.nix

echo "Updated pkgs/zerobyte/package.nix to version $version"
echo "Updated modules/hokage/programs/zerobyte.nix to Docker image tag $image_tag"
echo ""
echo "Hashes were reset; run a build to get the real hashes from the errors:"
echo "  cd pkgs/zerobyte && just build"
