{ config, pkgs, username, lib, ... }:

{
  home-manager.users.${username} = {
    # https://mynixos.com/home-manager/options/services.espanso
    services.espanso = {
      enable = true;
      configs = {
        default = {
          search_shortcut = "ALT+SHIFT+SPACE";
        };
        # https://espanso.org/docs/configuration/app-specific-configurations/
        # Disable espanso for the VirtualBox VM window, so that the client can use the shortcuts
        virtualbox = {
          # You can type "#detect#" in the application to find out filter_exec, filter_title and filter_class
          filter_class = "VirtualBox Machine";  # Or use xprop to find out
          enable = false;
        };
      };
      # https://espanso.org/docs/matches/basics/
      matches = {
        base = {
          matches = [
            {
              trigger = ":mydate";
              replace = "{{mydate}}";
              vars = [
                {
                  name = "mydate";
                  type = "date";
                  params = {
                    format = "%d.%m.%Y";
                  };
                }
              ];
            }
          ];
        };
        greethings = {
          global_vars = [
            {
              name = "quote";
              type = "shell";
              params = {
#                cmd = "curl -s 'https://zenquotes.io/api/random' | jq -r '.[0].q'";
#                cmd = "nix-shell -p neo-cowsay --run \"curl -s 'https://zenquotes.io/api/random' | jq -r '.[0].q' | cowthink\"";
                cmd = "${lib.getExe pkgs.curl} -s https://zenquotes.io/api/random | ${lib.getExe pkgs.jq} -r '.[0].q' | ${pkgs.neo-cowsay}/bin/cowthink";
              };
            }
          ];
          matches = [
            {
              trigger = ":sg";
              replace = "Sehr geehrter ";
            }
            {
              trigger = ":lgp";
              replace = "Liebe Grüße\nPatrizio";
            }
            {
              trigger = ":glg";
              replace = "Ganz liebe Grüße\nPatrizio";
            }
            {
              trigger = ":mfg";
              replace = "Mit freundlichen Grüßen\nPatrizio Bekerle";
            }
            {
              trigger = ":kr";
              replace = "Kind regards\nPatrizio Bekerle";
            }
            {
              trigger = ":cp";
              replace = "Cheers\nPatrizio";
            }
            {
              triggers = [ ":omor" ":gmo" ];
              replace = "Good morning from the office! 🌄🏢\n\n```\n{{quote}}\n```";
            }
            {
              triggers = [ ":.omor" ":.gmo" ];
              replace = "Good morning from the office! 🌄🏢";
            }
            {
              triggers = [ ":gmho" ];
              replace = "Good morning from home office! 🌄🏡\n\n```\n{{quote}}\n```";
            }
            {
              triggers = [ ":.gmho" ];
              replace = "Good morning from home office! 🌄🏡";
            }
            {
              triggers = [ ":gna" ":gnsg" ];
              replace = "Gute Nacht und schlaf gut! 🎑🌜🤗🌛🌃";
            }
            {
              triggers = [ ":vd" ];
              replace = "Vielen Dank!";
            }
            {
              triggers = [ ":ty" ];
              replace = "Thank you! 👍️";
            }
          ];
        };
        github = {
          matches = [
            {
              trigger = ":ghrel";
              replace = "There now is a new release, could you please test it and report if it works for you?";
            }
            {
              triggers = [ ":ghtest" ":ghtst" ":ghgr" ];
              replace = "Great, thank you for testing!\n";
            }
            {
              triggers = [ ":ghexp" ];
              replace = "Can you please explain in more detail and step by step what you did, what happened and what you expected?";
            }
            {
              triggers = [ ":ghnotetree" ":ghwip" ":gh790" ];
              replace = ''
                Looks like you are talking about the work in progress feature #790, right?
                If yes, then best deposit your request there... 😉
              '';
            }
            {
              triggers = [ ":ghcl" ];
              replace = "I will close this issue until there is more information.";
            }
            {
              trigger = ":ghscr";
              replace = ''
                Can you please mention the authors of the script, like advised in the issue template?
                You will find the authors in the *Script repository*.
                Don't forget to use the `@` symbol to mention them.
              '';
            }
            {
              triggers = [ ":ghrep" ":ghlog" ];
              replace = ''
                Thank you for reporting.
                Can you please post the output from the *Debug settings* in the settings dialog? You just need to paste it here.
                And is there any useful log output if you enable the log panel (see Window / Panels)?
                Please make sure you also enable debug logging in the log panel by right-clicking on the panel and selecting `Debug` in `Options`.
                The issue dialog in the help menu can help you with all of that.
              '';
            }
            {
              triggers = [ ":ghdet" ":ghexp" ];
              replace = ''
                <details><summary>Expand</summary>

                ```
                <!-- Replace this with the output -->
                ```
                </details>
              '';
            }
          ];
        };
        mail = {
          matches = [
            {
              triggers = [ ":mdons" ];
              replace = "QOwnNotes donation";
            }
            {
              triggers = [ ":mdonb" ];
              replace = ''
                Thanks a lot for your generous donation!

                Cheers Patrizio
              '';
            }
          ];
        };
        characters = {
          matches = [
            {
              triggers = [ ":ellip" ":..." ];
              replace = "…";
            }
          ];
        };
        abbreviations = {
          matches = [
            {
              triggers = [ ":afair" ];
              replace = "As far as I remember";
            }
            {
              triggers = [ ":lgtm" ];
              replace = "Looks good to me!";
            }
          ];
        };
        emotes = {
          matches = [
            {
              triggers = [ ":+1" ":up" ":ok" ];
              replace = "👍️";
            }
            {
              triggers = [ ":)" ":-)" ":smile" ];
              replace = "😊";
            }
            {
              triggers = [ ":|" ":-|" ":grim" ];
              replace = "😬";
            }
            {
              triggers = [ ":(" ":-(" ":sad" ":frown" ];
              replace = "☹️";
            }
            {
              triggers = [ ":roll" ];
              replace = "🙄";
            }
            {
              triggers = [ ":thi" ];
              replace = "🤔";
            }
            {
              triggers = [ ":fear" ];
              replace = "😱";
            }
            {
              triggers = [ ":ki" ];
              replace = "😘";
            }
            {
              triggers = [ ":D" ":-D" ":grin" ];
              replace = "😁";
            }
            {
              triggers = [ ":lau" ":laugh" ];
              replace = "😆";
            }
            {
              triggers = [ ":sw" ];
              replace = "😅";
            }
            {
              triggers = [ ":see" ];
              replace = "🙈";
            }
            {
              triggers = [ ":hug" ];
              replace = "🤗";
            }
            {
              triggers = [ ";)" ":wink" ];
              replace = "😉";
            }
            {
              triggers = [ ":clap" ];
              replace = "👏👏";
            }
            {
              triggers = [ ":pray" ":nam" ":bow" ":thank" ];
              replace = "🙏";
            }
            {
              triggers = [ ":sun" ];
              replace = "☀️";
            }
            {
              triggers = [ ":wow" ":ast" ];
              replace = "😲";
            }
            {
              triggers = [ ":heart" ":lov" ];
              replace = "😍❤️🥰";
            }
            {
              triggers = [ ":halo" ":inn" ":angel" "O:)" "O:-)" ];
              replace = "😇";
            }
            {
              triggers = [ ":crazy" "%)" "%-)" ];
              replace = "🤪🙃";
            }
            {
              triggers = [ ":lol" ];
              replace = "😂🤣";
            }
            {
              triggers = [ ":roc" ];
              replace = "🚀";
            }
            {
              triggers = [ ":cross" ":fing" ];
              replace = "🤞🏻🤞🏻";
            }
            {
              trigger = ":party";
              replace = "🥳🎉";
            }
            {
              trigger = ":birth";
              replace = "🥳🎉🎁";
            }
            {
              triggers = [ ":xmas" ":christ" ];
              replace = "🎄🎅🏻";
            }
            {
              triggers = [ ":flex" ];
              replace = "💪🏻🚀";
            }
            {
              triggers = [ ":face" ];
              replace = "🤦🏻";
            }
            {
              triggers = [ ":shr" ];
              replace = "️🤷🏻";
            }
            {
              triggers = [ ":cry" ":'(" ];
              replace = "🥹😢😭";
            }
            {
              # Don't use ":/" trigger because of "http://" and "https://"!
              triggers = [ ":-/" ":conf" ];
              replace = "😕🫤";
            }
            {
              triggers = [ ":fist" ];
              replace = "🤜🏻🤛🏻";
            }
            {
              triggers = [ ":lambda" ":nix" ];
              replace = "λ❄️λ";
            }
          ];
        };
      };
    };
  };
}
