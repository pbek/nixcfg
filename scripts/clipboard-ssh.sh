#!/usr/bin/env bash

# Clipboard sharing over SSH using wl-copy and wl-paste
# Usage:
#   clipboard-ssh.sh send <remote-host>    # Send local clipboard to remote host
#   clipboard-ssh.sh receive <remote-host> # Receive clipboard from remote host
#   clipboard-ssh.sh sync <remote-host>    # Two-way sync (send local, then receive remote)

set -euo pipefail

SCRIPT_NAME=$(basename "$0")

show_usage() {
  echo "Usage: $SCRIPT_NAME <command> <remote-host> [options]"
  echo ""
  echo "Commands:"
  echo "  send <host>     Send local clipboard to remote host"
  echo "  receive <host>  Receive clipboard from remote host"
  echo "  sync <host>     Two-way sync (send local, then receive remote)"
  echo ""
  echo "Options:"
  echo "  -p <port>       SSH port (default: 22)"
  echo "  -u <user>       SSH user (default: current user)"
  echo "  -i <keyfile>    SSH identity file"
  echo "  -v              Verbose output"
  echo ""
  echo "Examples:"
  echo "  $SCRIPT_NAME send myserver.com"
  echo "  $SCRIPT_NAME receive user@192.168.1.100 -p 2222"
  echo "  $SCRIPT_NAME sync myserver -i ~/.ssh/special_key"
}

log() {
  if [[ ${VERBOSE:-0} == "1" ]]; then
    echo "[$(date '+%H:%M:%S')] $*" >&2
  fi
}

error() {
  echo "Error: $*" >&2
  exit 1
}

check_dependencies() {
  local missing=()

  if ! command -v wl-copy >/dev/null 2>&1; then
    missing+=("wl-copy")
  fi

  if ! command -v wl-paste >/dev/null 2>&1; then
    missing+=("wl-paste")
  fi

  if ! command -v ssh >/dev/null 2>&1; then
    missing+=("ssh")
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing[*]}"
  fi
}

build_ssh_cmd() {
  local host="$1"
  local cmd="ssh"

  if [[ -n ${SSH_PORT:-} ]]; then
    cmd+=" -p $SSH_PORT"
  fi

  if [[ -n ${SSH_USER:-} ]]; then
    host="$SSH_USER@$host"
  fi

  if [[ -n ${SSH_KEY:-} ]]; then
    cmd+=" -i $SSH_KEY"
  fi

  cmd+=" -o ConnectTimeout=10"
  cmd+=" -o BatchMode=yes"
  cmd+=" $host"

  echo "$cmd"
}

send_clipboard() {
  local host="$1"
  local ssh_cmd
  ssh_cmd=$(build_ssh_cmd "$host")

  log "Sending clipboard to $host..."

  # Check if we have clipboard content
  if ! wl-paste --no-newline >/dev/null 2>&1; then
    error "No clipboard content to send"
  fi

  # Send clipboard content to remote host
  if wl-paste --no-newline | $ssh_cmd "wl-copy"; then
    echo "? Clipboard sent successfully to $host"
  else
    error "Failed to send clipboard to $host"
  fi
}

receive_clipboard() {
  local host="$1"
  local ssh_cmd
  ssh_cmd=$(build_ssh_cmd "$host")

  log "Receiving clipboard from $host..."

  # Receive clipboard content from remote host
  if $ssh_cmd "wl-paste --no-newline" | wl-copy; then
    echo "? Clipboard received successfully from $host"
  else
    error "Failed to receive clipboard from $host"
  fi
}

sync_clipboard() {
  local host="$1"

  log "Syncing clipboard with $host..."

  # Save current local clipboard
  local local_clipboard
  if local_clipboard=$(wl-paste --no-newline 2>/dev/null); then
    log "Local clipboard saved"
  else
    local_clipboard=""
    log "No local clipboard content"
  fi

  # Send local clipboard to remote
  if [[ -n $local_clipboard ]]; then
    send_clipboard "$host"
  fi

  # Receive remote clipboard
  receive_clipboard "$host"

  echo "? Clipboard sync completed with $host"
}

main() {
  if [[ $# -lt 2 ]]; then
    show_usage
    exit 1
  fi

  local command="$1"
  local host="$2"
  shift 2

  # Parse options
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -p)
      SSH_PORT="$2"
      shift 2
      ;;
    -u)
      SSH_USER="$2"
      shift 2
      ;;
    -i)
      SSH_KEY="$2"
      shift 2
      ;;
    -v)
      VERBOSE=1
      shift
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      ;;
    esac
  done

  check_dependencies

  case "$command" in
  send)
    send_clipboard "$host"
    ;;
  receive)
    receive_clipboard "$host"
    ;;
  sync)
    sync_clipboard "$host"
    ;;
  *)
    error "Unknown command: $command. Use 'send', 'receive', or 'sync'"
    ;;
  esac
}

main "$@"
