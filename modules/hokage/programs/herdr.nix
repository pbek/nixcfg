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
      _userName: { lib, ... }: {
        home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          ${lib.concatMapStringsSep "\n" (integration: ''
            ${lib.getExe pkgs.herdr} integration install ${lib.escapeShellArg integration}
          '') cfg.integrations}
        '';

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
