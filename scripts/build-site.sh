#!/usr/bin/env bash
set -euo pipefail

# Script to build a static website from README.md and docs/*.md into ./site/ using MkDocs

SITE_DIR="./site"
DOCS_DIR="./docs"
README_FILE="./README.md"
TEMP_DIR="$(mktemp -d)"
PROJECT_DIR="$(pwd)"

# Clean up temp dir on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# Create site directory
mkdir -p "$SITE_DIR"

# Initialize MkDocs site in temp dir
cd "$TEMP_DIR"

# Create mkdocs.yml
cat >mkdocs.yml <<'EOF'
site_name: nixcfg
theme:
  name: readthedocs
docs_dir: docs
EOF

# Create docs directory
mkdir -p docs

# Copy README.md as index
if [ -f "$PROJECT_DIR/$README_FILE" ]; then
  cp "$PROJECT_DIR/$README_FILE" docs/index.md
  # Fix links for MkDocs
  sed -i 's|docs/hokage-options.md|hokage-options.md|g' docs/index.md
else
  echo "Warning: $README_FILE not found"
fi

# Copy docs to docs/
for md_file in "$PROJECT_DIR/$DOCS_DIR"/*.md; do
  if [ -f "$md_file" ]; then
    cp "$md_file" docs/
  fi
done

# Copy screenshots
if [ -d "$PROJECT_DIR/screenshots" ]; then
  mkdir -p docs/screenshots
  cp -r "$PROJECT_DIR/screenshots"/* docs/screenshots/
fi

# Copy install.sh
if [ -f "$PROJECT_DIR/install.sh" ]; then
  cp "$PROJECT_DIR/install.sh" docs/
fi

# Build the site
nix run nixpkgs#mkdocs -- build --site-dir "$PROJECT_DIR/$SITE_DIR"

echo "Website built in $SITE_DIR"
