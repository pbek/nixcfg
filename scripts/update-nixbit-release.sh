#!/usr/bin/env bash

set -euo pipefail

# Get version number from user input or API
version=$(gum input --placeholder "Nixbit version (empty for latest)")

if [ -z "$version" ]; then
  version=$(curl -s https://api.github.com/repos/pbek/nixbit/releases/latest | jq -r '.tag_name' | sed 's/^v//')
fi

echo "Using version $version..."

# Set the URL
url="https://github.com/pbek/nixbit/archive/refs/tags/v${version}.tar.gz"

# Get the hash
hash=$(nix-prefetch-url "$url" | xargs nix hash convert --hash-algo sha256)

echo "Using hash $hash..."

# Update the default.nix file
sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|" pkgs/nixbit/package.nix
sed -i "s|hash = \"sha256-[A-Za-z0-9+/]*=*\";|hash = \"$hash\";|" pkgs/nixbit/package.nix

echo "Updated pkgs/nixbit/package.nix with version $version and hash $hash"
