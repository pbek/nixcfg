#!/usr/bin/env bash

set -euo pipefail

# Get version number from user input or API
version=$(gum input --placeholder "QOwnNotes version (empty for latest)")

if [ -z "$version" ]; then
  if ! version=$(curl -fsSL https://api.github.com/repos/pbek/QOwnNotes/releases/latest |
    jq -er '.tag_name | sub("^v"; "")'); then
    version=$(curl -fsSL https://api.qownnotes.org/latest_releases/linux | jq -er '.version')
  fi
fi

echo "Using version $version..."

# Set the URL
url="https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz"

# Get the hash
hash=$(nix-prefetch-url "$url" | xargs nix hash convert --hash-algo sha256)

echo "Using hash $hash..."

# Update the default.nix file
sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|" pkgs/qownnotes/package.nix
sed -i "s|hash = \"sha256-[A-Za-z0-9+/]*=*\";|hash = \"$hash\";|" pkgs/qownnotes/package.nix

echo "Updated pkgs/qownnotes/package.nix with version $version and hash $hash"
