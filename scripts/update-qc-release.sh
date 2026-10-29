#!/usr/bin/env bash

set -euo pipefail

# Get version number from user input or API
version=$(gum input --placeholder "QC version (empty for latest)")

if [ -z "$version" ]; then
  version=$(curl -fsSL https://api.github.com/repos/qownnotes/qc/releases/latest |
    jq -er '.tag_name | sub("^v"; "")')
fi

version=${version#v}

echo "Using version $version..."

# Update the version, source hash, and buildGoModule vendorHash
nix shell nixpkgs#nix-update --command nix-update qc --flake --version="$version"

echo "Updated pkgs/qc/default.nix to version $version (including source and Go dependency hashes)"
