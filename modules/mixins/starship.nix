{ config, pkgs, inputs, username, ... }:
{
  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.${username} = {
    # enable https://starship.rs
    programs.starship =
    let
      flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
    in {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      # https://starship.rs/config
      # Lookup icons: https://www.nerdfonts.com/cheat-sheet
      settings = {
        # add_newline = false;
        directory = {
#          fish_style_pwd_dir_length = 3; # The number of characters to use when applying fish shell pwd path logic.
          truncation_length = 5; # The number of parent folders that the current directory should be truncated to.
          truncate_to_repo = false; # Whether or not to truncate to the root of the git repo that you're currently in.
          style = "bold sky";
        };
        git_branch = {
          style = "bold pink";
        };
        username = {
          disabled = false;
          show_always = true;
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        hostname = {
          ssh_only = false;
          # leaving out the "in" at the end because there is not $directory
          # setting afterwards any more
          format = "[$ssh_symbol$hostname]($style) ";
        };
        # https://starship.rs/config/#shell
        shell = {
          disabled = false;
          # format = "\\[[$indicator]($style)\\] ";
          style = "gray";
          fish_indicator = "󰈺";
          # bash_indicator = "b";
        };
        status.disabled = false;
        # https://starship.rs/config/#custom-commands
        custom = {
          time = {
            command = "date +\"%d.%m.%Y %H:%M\"";
            when = "true";
            # the command often timed out
            ignore_timeout = true;
          };
        };

        # Move the directory to the second line
        # https://starship.rs/config/#default-prompt-format
        format = "$all$custom$directory$status$character";

        # format = "$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$swift$terraform$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$directory$character";

        # https://github.com/catppuccin/starship
        # https://github.com/catppuccin/starship/blob/main/themes/mocha.toml
        palette = "catppuccin_${flavour}";
      } // builtins.fromTOML (builtins.readFile"${inputs.catppuccin}/themes/${flavour}.toml");
    };
  };
}
