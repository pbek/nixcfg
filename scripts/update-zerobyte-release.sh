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

# Set the URL
url="https://github.com/nicotsx/zerobyte/archive/refs/tags/v${version}.tar.gz"

# Get the hash
hash=$(nix-prefetch-url "$url" | xargs nix hash convert --hash-algo sha256)

echo "Using hash $hash..."

# Update the package.nix file
sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|" pkgs/zerobyte/package.nix
sed -i "s|hash = \"sha256-[A-Za-z0-9+/]*=*\";|hash = \"$hash\";|" pkgs/zerobyte/package.nix

# Reset the node_modules FOD hash so the build computes the new one
sed -i "s|outputHash = \"sha256-[A-Za-z0-9+/]*=*\";|outputHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";|" pkgs/zerobyte/package.nix

echo "Updated pkgs/zerobyte/package.nix with version $version and hash $hash"
echo "The node_modules outputHash was reset; run a build to get the new hash:"
echo "  cd pkgs/zerobyte && just build"
