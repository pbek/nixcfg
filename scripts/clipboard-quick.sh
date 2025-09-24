#!/usr/bin/env bash

# Quick clipboard sharing aliases
# Place common hosts and configurations here

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLIPBOARD_SSH="$SCRIPT_DIR/clipboard-ssh.sh"

# Configuration - edit these for your common hosts
declare -A HOSTS=(
  ["astra-beta"]="192.168.1.6"
  ["server"]="myserver.com"
  ["work"]="work-machine.local"
)

declare -A HOST_USERS=(
  ["home"]="user"
  ["server"]="admin"
  ["work"]="$(whoami)"
)

declare -A HOST_PORTS=(
  ["home"]="22"
  ["server"]="2222"
  ["work"]="22"
)

show_usage() {
  echo "Quick clipboard sharing utility"
  echo ""
  echo "Usage: $(basename "$0") <action> [host-alias]"
  echo ""
  echo "Actions:"
  echo "  push [alias]    Send clipboard to host"
  echo "  pull [alias]    Get clipboard from host"
  echo "  sync [alias]    Two-way clipboard sync"
  echo "  list            Show configured host aliases"
  echo ""
  echo "Host aliases:"
  for alias in "${!HOSTS[@]}"; do
    echo "  $alias ? ${HOST_USERS[$alias]}@${HOSTS[$alias]}:${HOST_PORTS[$alias]}"
  done
}

get_host_config() {
  local alias="$1"

  if [[ -z ${HOSTS[$alias]:-} ]]; then
    echo "Error: Unknown host alias '$alias'" >&2
    echo "Available aliases: ${!HOSTS[*]}" >&2
    exit 1
  fi

  local host="${HOSTS[$alias]}"
  local user="${HOST_USERS[$alias]}"
  local port="${HOST_PORTS[$alias]}"

  echo "$host" "$user" "$port"
}

main() {
  if [[ $# -eq 0 ]]; then
    show_usage
    exit 1
  fi

  local action="$1"
  local host_alias="${2:-}"

  case "$action" in
  list)
    show_usage
    ;;
  push | pull | sync)
    if [[ -z $host_alias ]]; then
      echo "Error: Host alias required for $action" >&2
      exit 1
    fi

    read -r host user port <<<"$(get_host_config "$host_alias")"

    local cmd_action
    case "$action" in
    push) cmd_action="send" ;;
    pull) cmd_action="receive" ;;
    sync) cmd_action="sync" ;;
    esac

    exec "$CLIPBOARD_SSH" "$cmd_action" "$host" -u "$user" -p "$port"
    ;;
  *)
    echo "Error: Unknown action '$action'" >&2
    show_usage
    exit 1
    ;;
  esac
}

main "$@"
