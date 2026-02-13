_copilot_api_completions() {
  local cur prev cmds
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  # Main commands
  cmds="auth start check-usage debug"

  # Start command options
  start_opts="--port --verbose --account-type --manual --rate-limit --wait --github-token --claude-code --show-token"

  # Account type values
  account_types="individual business enterprise"

  # Handle command-specific completions
  case "${COMP_WORDS[1]}" in
  start)
    case "$prev" in
    --port)
      # Port number completion (suggest common ports)
      mapfile -t COMPREPLY < <(compgen -W "4141 8080 3000 8000" -- "$cur")
      return 0
      ;;
    --account-type)
      mapfile -t COMPREPLY < <(compgen -W "$account_types" -- "$cur")
      return 0
      ;;
    *)
      if [[ "$cur" == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "$start_opts" -- "$cur")
        return 0
      fi
      ;;
    esac
    ;;
  auth | check-usage | debug)
    # These commands don't take options
    return 0
    ;;
  *)
    if [[ $COMP_CWORD -eq 1 ]]; then
      mapfile -t COMPREPLY < <(compgen -W "$cmds" -- "$cur")
      return 0
    fi
    ;;
  esac

  # Default: show main commands
  if [[ $COMP_CWORD -eq 1 ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$cmds" -- "$cur")
  fi
}

complete -F _copilot_api_completions copilot-api
