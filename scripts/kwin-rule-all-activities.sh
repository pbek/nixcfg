#!/usr/bin/env bash
#
# Add a KWin window rule that initially places all normal windows on all
# activities, unless a rule with the same description already exists.
# Existing (manually created) rules are left untouched.

set -euo pipefail

file="kwinrulesrc"
description="All windows on all activities"
# The null UUID means "all activities"
allActivities="00000000-0000-0000-0000-000000000000"

read_key() {
  kreadconfig6 --file "$file" --group "$1" --key "$2"
}

rules=$(read_key General rules)

# Check if the rule already exists
IFS=',' read -ra ruleIds <<<"$rules"
for id in "${ruleIds[@]}"; do
  [ -z "$id" ] && continue
  if [ "$(read_key "$id" Description)" = "$description" ]; then
    echo "Rule \"$description\" already exists (group [$id]), nothing to do"
    exit 0
  fi
done

# KDE uses UUIDs as group names for rules created in System Settings
id=$(uuidgen)

write_key() {
  kwriteconfig6 --file "$file" --group "$id" --key "$1" "$2"
}

write_key Description "$description"
write_key activity "$allActivities"
# 3 = Apply Initially (the window can still be moved to a single activity)
write_key activityrule 3
# 1 = Normal Window
write_key types 1

if [ -z "$rules" ]; then
  rules="$id"
else
  rules="$rules,$id"
fi

IFS=',' read -ra ruleIds <<<"$rules"
kwriteconfig6 --file "$file" --group General --key rules "$rules"
kwriteconfig6 --file "$file" --group General --key count "${#ruleIds[@]}"

echo "Added rule \"$description\" (group [$id])"

# Tell KWin to reload its rules, if it's running
if command -v qdbus >/dev/null && qdbus org.kde.KWin >/dev/null 2>&1; then
  qdbus org.kde.KWin /KWin reconfigure
  echo "KWin reconfigured"
fi
