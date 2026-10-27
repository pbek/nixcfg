{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.herdr;
in
{
  options.hokage.programs.herdr = {
    enable = lib.mkEnableOption "Herdr terminal workspace manager" // {
      default = hokage.role == "desktop";
    };
    integrations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "pi"
          "omp"
          "claude"
          "codex"
          "copilot"
          "devin"
          "droid"
          "kimi"
          "opencode"
          "kilo"
          "hermes"
          "qodercli"
          "qwen"
          "cursor"
          "mastracode"
          "antigravity-cli"
          "grok"
          "letta"
        ]
      );
      default = lib.optionals hokage.programs.opencode.enable [ "opencode" ];
      description = "Herdr integrations to install into the agents' writable user configuration during Home Manager activation.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (
      _userName: { config, lib, ... }: {
        home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          ${lib.optionalString
            (lib.elem "opencode" cfg.integrations && config.programs.opencode.mutableSettings)
            ''
              # A failed activation can leave cli.json linked to an older HM
              # generation even after mutableSettings has been enabled.
              run ${pkgs.writeShellScript "herdr-migrate-opencode-cli" ''
                set -euo pipefail
                cli=${lib.escapeShellArg "${config.xdg.configHome}/opencode/cli.json"}
                if [[ -L "$cli" ]]; then
                  case "$(readlink -- "$cli")" in
                    /nix/store/*-home-manager-files/*/opencode/cli.json)
                      # Preserve the contents, leave user-owned files/links alone,
                      # and replace the store link atomically with a writable file.
                      temporary=$(mktemp "$(dirname -- "$cli")/.cli.json.XXXXXX")
                      trap 'rm -f -- "$temporary"' EXIT
                      cat -- "$cli" > "$temporary"
                      mv -T -- "$temporary" "$cli"
                      ;;
                  esac
                fi
              ''}
            ''
          }
          ${lib.concatMapStringsSep "\n" (integration: ''
            run ${lib.getExe pkgs.herdr} integration install ${lib.escapeShellArg integration}
          '') cfg.integrations}
        '';

        # Herdr registers its terminal plugin by updating OpenCode's cli.json.
        # Keep that file writable and load declarative settings separately.
        programs.opencode.mutableSettings = lib.mkIf (lib.elem "opencode" cfg.integrations) (
          lib.mkDefault true
        );

        programs.herdr = {
          enable = true;
          # Home Manager's config.toml is read-only; skip onboarding's attempt to update it.
          settings.onboarding = false;
          settings.ui.tab_bar_right = [
            {
              type = "command";
              command = "${pkgs.writeShellScript "herdr-system-usage" ''
                ${pkgs.gawk}/bin/awk '
                  BEGIN {
                    getline sample < "/proc/stat"
                    split(sample, first)
                    close("/proc/stat")
                    system("${pkgs.coreutils}/bin/sleep 0.2")
                    getline sample < "/proc/stat"
                    split(sample, second)

                    for (i = 2; i <= 9; i++) {
                      total += second[i] - first[i]
                    }
                    idle = (second[5] + second[6]) - (first[5] + first[6])

                    while ((getline < "/proc/meminfo") > 0) {
                      if ($1 == "MemTotal:") mem_total = $2
                      if ($1 == "MemAvailable:") mem_available = $2
                    }

                    printf "CPU %.0f%% · RAM %.0f%%\n", total ? 100 * (total - idle) / total : 0, 100 * (mem_total - mem_available) / mem_total
                  }
                '
              ''}";
              interval_seconds = 5;
              timeout_seconds = 2;
            }
          ];
        };
      }
    );
  };
}
