# Use `just <recipe>` to run a recipe
# https://just.systems/man/en/

# By default, run the `--list` command
default:
    @just --list

# Set default shell to bash

set shell := ["bash", "-c"]

# Variables

hostname := `hostname`
user := `whoami`

# Aliases

alias s := switch
alias ss := switch-simple
alias u := upgrade
alias c := cleanup
alias b := build
alias bh := build-on-home01
alias bc := build-on-caliban
alias p := push
alias sp := switch-push
alias fix-command-not-found-error := update-channels
alias options := hokage-options
alias fmt := format
alias fmta := format-all

# Notify the user with neosay
@_notify text:
    if test -f ~/.config/neosay/config.json; then echo "❄️ nixcfg {{ text }}" | neosay; fi

[group('build')]
test:
    sudo nixos-rebuild test --flake .#{{ hostname }} -L

# Careful: This can use a lot of memory on large flakes
# https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake-check.html
[group('build')]
check-high-memory:
    nix flake check --no-build --keep-going

# Careful: This can use a lot of memory on large flakes
[group('build')]
check-trace-high-memory:
    nix flake check --no-build --show-trace

# Check all hosts configured in the flake.nix
[group('build')]
check-all:
    #!/usr/bin/env bash
    echo "🔍 Checking all hosts configured in flake.nix..."

    # Extract host names from flake.nix nixosConfigurations
    hosts=($(nix eval --raw .#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.attrNames pkgs)'))

    if [ ${#hosts[@]} -eq 0 ]; then
        echo "❌ No hosts found in flake.nix"
        exit 1
    fi

    echo "📋 Found ${#hosts[@]} hosts: ${hosts[*]}"
    echo ""

    failed_hosts=()
    successful_hosts=()

    for host in "${hosts[@]}"; do
        echo "📋 Checking host: $host"
        if just check-host "$host" > /dev/null 2>&1; then
            echo "✅ $host: OK"
            successful_hosts+=("$host")
        else
            echo "❌ $host: FAILED"
            failed_hosts+=("$host")
        fi
    done

    echo ""
    echo "📊 Summary:"
    echo "✅ Successful hosts (${#successful_hosts[@]}): ${successful_hosts[*]}"
    if [ ${#failed_hosts[@]} -gt 0 ]; then
        echo "❌ Failed hosts (${#failed_hosts[@]}): ${failed_hosts[*]}"
        echo ""
        echo "Run 'just check-host <hostname>' for detailed error information."
        exit 1
    else
        echo "🎉 All hosts checked successfully!"
    fi

# Checks if the configuration of a host can be built
[group('build')]
check-host hostname:
    nix eval .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel.drvPath

# Checks if the current host configuration can be built
[group('build')]
check:
    just check-host {{ hostname }}

[group('build')]
nix-switch:
    sudo nixos-rebuild switch --flake .#{{ hostname }} -L

# Build and switch to the new configuration for the current host (no notification)
[group('build')]
switch-simple:
    nh os switch -H {{ hostname }} .

# Build and switch to the new configuration for the current host (with notification, use "--max-jobs 1" to restict downloads)
[group('build')]
switch args='':
    #!/usr/bin/env bash
    echo "❄️ Running switch for {{ hostname }}..."
    sudo true
    start_time=$(date +%s)
    nh os switch -H {{ hostname }} . -- {{ args }}
    end_time=$(date +%s)
    exit_code=$?
    runtime=$((end_time - start_time))
    if [ $runtime -gt 10 ]; then
      just _notify "switch finished on {{ hostname }}, exit code: $exit_code (runtime: ${runtime}s)"
    fi

# Build the current host with nix-rebuild
[group('build')]
nix-build:
    sudo nixos-rebuild build --flake .#{{ hostname }}

# Build a host with nh
[group('build')]
build-host hostname args='':
    nh os build -H {{ hostname }} . -- {{ args }}
    just _notify "build of host {{ hostname }} finished"

# Build a host with nh on another host
[group('build')]
build-host-on buildHost hostname args='':
    nh os build -H {{ hostname }} --build-host omega@{{ buildHost }} . -- {{ args }}
    just _notify "build of host {{ hostname }} on {{ buildHost }} finished"

# Build the current host with nh
[group('build')]
build args='': (build-host hostname args)

# Build the current host on the Caliban host
[group('build')]
nix-build-on-caliban:
    nixos-rebuild --build-host omega@caliban-1.netbird.cloud --flake .#{{ hostname }} build
    just _notify "build-on-caliban finished on {{ hostname }}"

# Build and deploy the astra host
[group('build')]
build-deploy-astra:
    nh os build -H astra --target-host omega@astra.netbird.cloud .
    just _notify "build-deploy-astra finished on {{ hostname }}"

# Build and deploy the ally2 host
[group('build')]
build-deploy-ally2:
    nh os build -H ally2 --target-host omega@ally2.lan .
    just _notify "build-deploy-ally2 finished on {{ hostname }}"

# Build the current host on the Sinope host
[group('build')]
build-on-sinope:
    nh os build -H {{ hostname }} --build-host omega@sinope.netbird.cloud .
    just _notify "build-on-sinope finished on {{ hostname }}"

# Build with nh on caliban
[group('build')]
build-on-caliban args='':
    nh os build -H {{ hostname }} --build-host omega@caliban-1.netbird.cloud . -- {{ args }}
    just _notify "build-on-caliban finished on {{ hostname }}"

# Build the current host on the Home01 host (use "--max-jobs 1" to restict downloads)
[group('build')]
nix-build-on-home01 args='':
    nixos-rebuild --build-host omega@home01.lan --flake .#{{ hostname }} build {{ args }}
    just _notify "build-on-home01 finished on {{ hostname }}"

# Build with nh on home01
[group('build')]
build-on-home01 args='':
    nh os build -H {{ hostname }} --build-host omega@home01.lan . -- {{ args }}
    just _notify "build-on-home01 finished on {{ hostname }}"

[group('cache')]
switch-push: switch && push

[group('cache')]
switch-push-all: push-all push

# Update the flakes
[group('build')]
update args='':
    NIX_CONFIG="access-tokens = github.com=`cat ~/.secrets/github-token`" nix flake update {{ args }}

# Update the flakes and switch to the new configuration
[group('build')]
upgrade: update build switch

[group('cache')]
upgrade-push: upgrade push

[group('cache')]
upgrade-push-all: upgrade push-all push

[group('cache')]
push:
    -attic push main `which atuin` --no-closure
    -attic push main `which espanso` --no-closure
    -attic push main `which cura` --no-closure
    -attic push main `which ghostty` --no-closure
    -attic push main `which tv` --no-closure
    -attic push qownnotes `which qownnotes` --no-closure
    -attic push qownnotes `which qc` --no-closure

[group('cache')]
push-all:
    ./scripts/push-all-to-attic.sh

[group('cache')]
push-local:
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which phpstorm` --no-closure
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which clion` --no-closure
    attic push --ignore-upstream-cache-filter cicinas2:nix-store `which goland` --no-closure

# Rekey the agenix secrets using ~/.ssh/agenix
[group('agenix')]
rekey-fallback:
    cd ./secrets && agenix -i ~/.ssh/agenix --rekey

# Rekey the agenix secrets
[group('agenix')]
rekey:
    cd ./secrets && agenix --rekey

# Show ssh keys for agenix
[group('agenix')]
keyscan:
    ssh-keyscan localhost

# Build an iso image
[group('build')]
build-iso:
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

@_show-qemu-exit-message:
    echo "Booting VM. To exit, use: Ctrl + A then X"
    echo "Press any key to continue..."
    read -n 1

# Boot the built iso image in QEMU
[group('build')]
boot-iso:
    just _show-qemu-exit-message
    nix-shell -p qemu --run "qemu-system-x86_64 -m 256 -cdrom result/iso/nixos-*.iso"

[group('vm')]
boot-vm:
    just _show-qemu-exit-message
    QEMU_OPTS="-m 4096 -smp 4 -enable-kvm" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

[group('vm')]
boot-vm-no-kvm:
    just _show-qemu-exit-message
    QEMU_OPTS="-m 4096 -smp 4" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

[group('vm')]
boot-vm-console:
    just _show-qemu-exit-message
    QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm

[group('vm')]
boot-vm-server-console:
    just _show-qemu-exit-message
    QEMU_OPTS="-nographic -serial mon:stdio" QEMU_KERNEL_PARAMS=console=ttyS0 QEMU_NET_OPTS="hostfwd=tcp::2222-:2222" ./result/bin/run-*-vm

[group('vm')]
ssh-vm-server:
    ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

# Reset the VM
[confirm("Are you sure you want to reset the VM?")]
[group('vm')]
reset-vm:
    rm *.qcow2

[group('vm')]
ssh-vm:
    ssh -p 2222 omega@localhost -t "tmux new-session -A -s pbek"

[group('vm')]
build-vm host:
    nixos-rebuild --flake .#{{ host }} build-vm

# Rebuild the current host
[group('build')]
flake-rebuild-current:
    nh os switch -H {{ hostname }} .

# Update the flakes
[group('build')]
flake-update:
    nix flake update

# Clean up the system to free up space
[confirm("Are you sure you want to clean up the system?")]
[group('maintenance')]
cleanup:
    duf
    sudo journalctl --vacuum-time=3d
    docker system prune -f
    sudo rm -rf ~/.local/share/Trash/*
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix-store --optimise
    duf
    just _notify "Cleanup finished on {{ hostname }}"

# Repair the nix store
[group('maintenance')]
repair-store:
    sudo nix-store --verify --check-contents --repair
    just _notify "Store repaired on {{ hostname }}"

# List the generations
[group('maintenance')]
list-generations:
    nh os info

# Rollback to the previous generation
[group('maintenance')]
rollback:
    nh os rollback

# Garbage collect the nix store to free up space
[group('maintenance')]
optimize-store:
    duf && \
    nix store optimise && \
    duf
    just _notify "Store optimized on {{ hostname }}"

# Do firmware updates
[group('maintenance')]
fwup:
    -fwupdmgr refresh
    fwupdmgr update

# Open a terminal with the nixcfg session
[group('maintenance')]
term:
    zellij --layout term.kdl attach nixcfg -c

# Kill the nixcfg session
[group('maintenance')]
term-kill:
    zellij delete-session nixcfg -f

# Replace the current fish shell with a new one
[group('build')]
fish-replace:
    exec fish

# Use statix to check the nix files
[group('linter')]
linter-check:
    nix-shell -p statix --run "statix check"

# Use statix to fix the nix files
[group('linter')]
linter-fix:
    nix-shell -p statix --run "statix fix"

# Fix "command not found" error
[group('maintenance')]
update-channels:
    sudo nix-channel --update

# Build the Venus host with nix
[group('build')]
nix-build-venus:
    nixos-rebuild --flake .#venus build

# Build the Venus host with nh
[group('build')]
build-venus: (build-host "venus")

# Show home-manager logs
[group('maintenance')]
home-manager-logs:
    sudo journalctl --since today | grep "hm-activate-" | bat

# Show home-manager service status
[group('maintenance')]
home-manager-status:
    systemctl status home-manager-{{ user }}.service

# Restart nix-serve (use on home01)
[group('maintenance')]
home01-restart-nix-serve:
    systemctl restart nix-serve

# Edit the QOwnNotes build file
[group('qownnotes')]
edit-qownnotes-build:
    kate ./pkgs/qownnotes/package.nix -l 23 -c 19

# Run a fish shell with all needed tools
[group('maintenance')]
shell:
    nix-shell --run fish

# Get the nix hash of a QOwnNotes release
[group('qownnotes')]
qownnotes-hash:
    #!/usr/bin/env bash
    set -euxo pipefail
    version=$(gum input --placeholder "QOwnNotes version number")
    url="https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz"
    nix-prefetch-url "$url" | xargs nix hash convert --hash-algo sha256

# Update the QOwnNotes release in the app
[group('qownnotes')]
qownnotes-update-release:
    ./scripts/update-qownnotes-release.sh

# Evaluate a config for a hostname (default current host)
eval-config configPath host=hostname *args:
    nix eval .#nixosConfigurations.{{ host }}.config.{{ configPath }} {{ args }}

# Evaluate a config for a hostname (default current host) as json
eval-config-json configPath host=hostname *args:
    nix eval .#nixosConfigurations.{{ host }}.config.{{ configPath }} --json {{ args }} | jq | bat -l json

whereis-pkg package:
    whereis $(which ${package})

# Show all config options of the hokage service
hokage-options host=hostname:
    nix eval .#nixosConfigurations.{{ host }}.options.hokage --json | jq

# Show all config options of the hokage nix module and get more information about one (WIP)
hokage-options-interactive:
    #!/usr/bin/env bash

    # Get all hokage options using nix eval
    echo "Loading hokage module options..."
    options=$(nix eval .#nixosConfigurations.{{ hostname }}.options.hokage --json | jq -r 'to_entries | .[] | .key' | sort)

    while true; do
        # Use fzf to select an option
        selected=$(echo "$options" | fzf --prompt="Select hokage option > " --height=20)

        # Check if user cancelled with ESC
        if [ -z "$selected" ]; then
            break
        fi

        # Clear screen for better readability
        clear

        echo "Option: hokage.$selected"
        echo "========================================"

        # Show detailed information about the selected option
        nix eval .#nixosConfigurations.{{ hostname }}.options.hokage.$selected --json | jq -r '
        if .description.text then "Description: " + .description.text else "Description: No description available" end,
        if .type.description then "Type: " + .type.description else "Type: Unknown" end,
        if .default.text then "Default: " + .default.text else "Default: No default value" end,
        if .example.text then "Example: " + .example.text else "Example: No example provided" end
        '

        echo "========================================"
        echo "Press any key to select another option, or Ctrl+C to exit"

        # Wait for keypress
        read -n 1

        # Clear screen before showing fzf again
        clear
    done

# Get the reverse dependencies of a nix store path
[group('maintenance')]
nix-store-reverse-dependencies:
    #!/usr/bin/env bash
    set -euxo pipefail
    nixStorePath=$(gum input --placeholder "Nix store path (e.g. /nix/store/hbldxn007k0y5qidna6fg0x168gnsmkj-botan-2.19.5.drv)")
    nix-store --query --referrers "$nixStorePath"

# Generate a random host ID for ZFS
[group('maintenance')]
zfs-generate-host-id:
    head -c4 /dev/urandom | od -A none -t x4

# Add git commit hashes to the .git-blame-ignore-revs file
[group('linter')]
add-git-blame-ignore-revs:
    git log --pretty=format:"%H" --grep="^lint" >> .git-blame-ignore-revs
    sort .git-blame-ignore-revs | uniq > .git-blame-ignore-revs.tmp
    mv .git-blame-ignore-revs.tmp .git-blame-ignore-revs

# Restart the plasmashell service (useful after an update)
[group('maintenance')]
restart-plasmashell:
    systemctl restart --user plasma-plasmashell.service

# Generate aider configuration file with GitHub Copilot oauth token
[group('config')]
@generate-aider-config:
    #!/usr/bin/env bash
    set -euo pipefail

    # Get the oauth token using the hidden helper recipe
    OAUTH_TOKEN=$(just _get-github-copilot-token)

    # Create the aider config file
    cat > "$HOME/.aider.conf.yml" << EOF
    openai-api-base: https://api.githubcopilot.com
    openai-api-key:  "$OAUTH_TOKEN"
    model:           openai/claude-sonnet-4
    weak-model:      openai/gpt-4o-mini
    show-model-warnings: false
    EOF

    echo "✅ Generated aider configuration at ~/.aider.conf.yml"

# List available GitHub Copilot models
[group('config')]
@list-github-copilot-models:
    #!/usr/bin/env bash
    set -euo pipefail

    # Get the oauth token using the hidden helper recipe
    OPENAI_API_KEY=$(just _get-github-copilot-token)

    echo "Available GitHub Copilot models:"
    curl -s https://api.githubcopilot.com/models \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -H "Copilot-Integration-Id: vscode-chat" | jq -r '.data[].id'

# Hidden recipe to extract GitHub Copilot oauth token
@_get-github-copilot-token:
    #!/usr/bin/env bash
    set -euo pipefail

    # Extract oauth_token from GitHub Copilot apps.json
    APPS_JSON="$HOME/.config/github-copilot/apps.json"

    if [ ! -f "$APPS_JSON" ]; then
        echo "Error: GitHub Copilot apps.json not found at $APPS_JSON" >&2
        exit 1
    fi

    # Extract the oauth_token using jq
    OAUTH_TOKEN=$(jq -r '.[].oauth_token' "$APPS_JSON")

    if [ -z "$OAUTH_TOKEN" ] || [ "$OAUTH_TOKEN" = "null" ]; then
        echo "Error: Could not extract oauth_token from $APPS_JSON" >&2
        exit 1
    fi

    echo "$OAUTH_TOKEN"

[group('linter')]
scan-dead-code args='':
    deadnix --exclude pkgs/ {{ args }}

# Fix dead code in the nix files
[group('linter')]
fix-dead-code args='':
    deadnix --exclude pkgs/ -e {{ args }}

# Format all files using treefmt
[group('linter')]
format args='':
    treefmt {{ args }}

# Format all files using pre-commit
[group('linter')]
format-all args='':
    pre-commit run --all-files {{ args }}
