# Fish completions for copilot-api

# Disable file completions for copilot-api
complete -c copilot-api -f

# Main commands
complete -c copilot-api -n '__fish_use_subcommand' -a 'auth' -d 'Run GitHub auth flow without running the server'
complete -c copilot-api -n '__fish_use_subcommand' -a 'start' -d 'Start the Copilot API server'
complete -c copilot-api -n '__fish_use_subcommand' -a 'check-usage' -d 'Show current GitHub Copilot usage/quota information'
complete -c copilot-api -n '__fish_use_subcommand' -a 'debug' -d 'Print debug information about the application'

# Start command options
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s p -l port -d 'Port to listen on' -a '4141 8080 3000 8000'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s v -l verbose -d 'Enable verbose logging'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s a -l account-type -d 'Account type to use' -a 'individual business enterprise'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -l manual -d 'Enable manual request approval'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -l rate-limit -d 'Rate limit in seconds between requests'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s w -l wait -d 'Wait instead of error when rate limit is hit'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s g -l github-token -d 'Provide GitHub token directly'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -s c -l claude-code -d 'Generate a command to launch Claude Code with Copilot API config'
complete -c copilot-api -n '__fish_seen_subcommand_from start' -l show-token -d 'Show GitHub and Copilot tokens on fetch and refresh'
