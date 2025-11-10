#!/usr/bin/env bash
#
# We want to push all derivations of the CURRENT generation to attic!
#

set -euo pipefail

echo "Reading all paths from /run/current-system/sw/bin..."
binList=$(find /run/current-system/sw/bin/* -maxdepth 1 -exec readlink -f {} \;)

echo "Reading all paths from /run/current-system/sw/sbin..."
sbinList=$(find /run/current-system/sw/sbin/* -maxdepth 1 -exec readlink -f {} \;)

list="$binList\n$sbinList"
pathList=""

while read -r file; do
  # Check if $file is a file and executable
  [[ -x $file && -f $file ]] || continue

  # Only get the three first parts of the path
  file=$(echo "$file" | cut -d "/" -f 1-4)

  # Add $file to pathList with a newline at the end
  pathList+="$file\n"
done <<<"$list"

# remove duplicates from pathList
pathList=$(echo -e "$pathList" | sort | uniq)

# Count lines of pathList
lineCount=$(echo -e "$pathList" | wc -l)

echo "Pushing $lineCount paths to attic..."

while read -r path; do
  # Skip paths that are no directories
  [[ -d $path ]] || continue

  echo "Pushing $path to attic..."
  attic push --ignore-upstream-cache-filter cicinas2:nix-store "$path"
done <<<"$pathList"
