{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userNameLong;
  inherit (hokage) userNameShort;
  inherit (hokage) userEmail;
  inherit (hokage) waylandSupport;
  cfg = hokage.programs.espanso;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.espanso = {
    enable = mkEnableOption "Espanso to expand text" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    # Get around: [ERROR] Error: could not open uinput device
    boot.kernelModules = if waylandSupport then [ "uinput" ] else [ ];

    # Espanso dependency: kdotool missing or not available for the current wayland DE.
    environment.systemPackages = lib.mkIf waylandSupport (
      with pkgs;
      [
        # Build error in unstable package
        stable.kdotool
      ]
    );

    # Get around permission denied error on /dev/uinput
    services.udev.extraRules =
      if waylandSupport then
        ''
          KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
        ''
      else
        "";

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # https://mynixos.com/home-manager/options/services.espanso
      services.espanso = {
        enable = true;
        package = if waylandSupport then pkgs.espanso-wayland else pkgs.espanso;
        #      package = (pkgs.callPackage ../../pkgs/espanso/espanso.nix { }).override {
        #        inherit waylandSupport;
        #      };
        configs = {
          default = {
            search_shortcut = "ALT+SHIFT+SPACE";
            keyboard_layout = {
              layout = "de";
            };
          };
          # https://espanso.org/docs/configuration/app-specific-configurations/
          # Disable espanso for the VirtualBox VM window, so that the client can use the shortcuts
          # Note: App-specific configurations are not yet supported in Wayland!
          virtualbox-x11 = {
            # You can type "#detect#" in the application to find out filter_exec, filter_title and filter_class
            filter_class = "VirtualBox Machine"; # Or use xprop to find out
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
                  cmd = "${lib.getExe pkgs.curl} -s https://zenquotes.io/api/random | ${lib.getExe pkgs.jq} -r '.[0].q' | ${lib.getExe' pkgs.neo-cowsay "cowthink"} -f small";
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
                replace = "Liebe Grüße\n${userNameShort}";
              }
              {
                trigger = ":glg";
                replace = "Ganz liebe Grüße\n${userNameShort}";
              }
              {
                trigger = ":mfg";
                replace = "Mit freundlichen Grüßen\n${userNameLong}";
              }
              {
                trigger = ":kr";
                replace = "Kind regards\n${userNameLong}";
              }
              {
                trigger = ":cp";
                replace = "Cheers\n${userNameShort}";
              }
              {
                triggers = [
                  ":omor"
                  ":gmo"
                ];
                replace = "Good morning from the office! 🌄🏢\n\n```\n{{quote}}\n```";
              }
              {
                triggers = [
                  ":.omor"
                  ":.gmo"
                ];
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
                triggers = [
                  ":gna"
                  ":gnsg"
                ];
                replace = "Gute Nacht und schlaf gut! 🎑🌜🤗🌛🌃";
              }
              {
                triggers = [ ":gmg" ];
                replace = "Guten Morgen, wie hast du geschlafen? 🌄🤗☀️";
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
          searches = {
            matches = [
              {
                trigger = "!amaz";
                replace = "!amazonde ";
              }
              {
                trigger = "!geiz";
                replace = "!geizhalsat ";
              }
            ];
          };
          github = {
            matches = [
              {
                trigger = ":gsign";
                replace = "Signed-off-by: ${userNameLong} <${userEmail}>";
              }
              {
                trigger = ":ghrel";
                replace = "There now is a new release, could you please test it and report if it works for you?";
              }
              {
                triggers = [
                  ":ghtest"
                  ":ghtst"
                  ":ghgr"
                ];
                replace = "Great, thank you for testing!\n";
              }
              {
                triggers = [ ":ghexp" ];
                replace = "Can you please explain in more detail and step by step what you did, what happened and what you expected?";
              }
              {
                triggers = [
                  ":ghnotetree"
                  ":ghwip"
                  ":gh790"
                ];
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
                triggers = [
                  ":ghrep"
                  ":ghlog"
                ];
                replace = ''
                  Thank you for reporting.
                  Can you please post the output from the *Debug settings* in the settings dialog? You just need to paste it here.
                  And is there any useful log output if you enable the log panel (see Window / Panels)?
                  Please make sure you also enable debug logging in the log panel by right-clicking on the panel and selecting `Debug` in `Options`.
                  The issue dialog in the help menu can help you with all of that.
                '';
              }
              {
                triggers = [
                  ":ghdet"
                  ":ghexp"
                ];
                # The newlines are needed, because of a weird espanso issue with backticks
                replace = ''
                  <details><summary>Expand</summary>

                  ```
                  $|$<!-- Replace this with the output -->
                  ```

                  </details>
                '';
                # Also the force_clipboard is needed to get the backticks
                force_clipboard = true;
              }
              # Option to highlight a "Note" and "Warning" using blockquote
              # See https://github.com/orgs/community/discussions/16925
              {
                triggers = [
                  ":ghtip"
                ];
                replace = ''
                  > [!TIP]
                  > $|$
                '';
              }
              {
                triggers = [
                  ":ghwarn"
                ];
                replace = ''
                  > [!WARNING]
                  > $|$
                '';
              }
              {
                triggers = [
                  ":ghnote"
                ];
                replace = ''
                  > [!NOTE]
                  > $|$
                '';
              }
              {
                triggers = [
                  ":ghimp"
                ];
                replace = ''
                  > [!IMPORTANT]
                  > $|$
                '';
              }
              {
                triggers = [
                  ":ghcaut"
                ];
                replace = ''
                  > [!CAUTION]
                  > $|$
                '';
              }
              {
                triggers = [
                  ":ghnixmerge"
                  ":ghnmb"
                  ":ghmerge"
                ];
                # If we make that "S" in "NixOS" uppercase, espanso breaks the replacement by switching to caps lock
                replace = "@NixO$|$s/nixpkgs-merge-bot merge";
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

                  Cheers ${userNameShort}
                '';
              }
            ];
          };
          characters = {
            matches = [
              {
                triggers = [
                  ":ellip"
                  ":..."
                ];
                replace = "…";
              }
              {
                triggers = [ ":tm" ];
                replace = "™";
              }
              {
                triggers = [ ":copy" ];
                replace = "©";
              }
            ];
          };
          abbreviations = {
            global_vars = [
              {
                name = "metaphorpsum";
                type = "shell";
                params = {
                  cmd = "${lib.getExe pkgs.curl} -s http://metaphorpsum.com/sentences/7";
                };
              }
            ];
            matches = [
              {
                triggers = [ ":li1" ];
                replace = "{{ metaphorpsum }}";
              }
              {
                triggers = [ ":li2" ];
                replace = ''
                  {{ metaphorpsum }}

                  {{ metaphorpsum }}
                '';
              }
              {
                triggers = [ ":li3" ];
                replace = ''
                  {{ metaphorpsum }}

                  {{ metaphorpsum }}

                  {{ metaphorpsum }}
                '';
              }
              {
                triggers = [ ":li5" ];
                replace = ''
                  {{ metaphorpsum }}

                  {{ metaphorpsum }}

                  {{ metaphorpsum }}

                  {{ metaphorpsum }}

                  {{ metaphorpsum }}
                '';
              }
              {
                triggers = [ ":afair" ];
                replace = "As far as I remember";
              }
              {
                triggers = [ ":lgtm" ];
                replace = "Looks good to me!";
              }
              {
                triggers = [ ":mast" ];
                replace = "social.qownnotes.org";
              }
              {
                trigger = ":zb";
                replace = "beispielsweise";
              }
              {
                # Don't collide with ":fear" trigger
                trigger = ":fex";
                replace = "for example";
              }
              {
                trigger = ":imo";
                replace = "in my opinion";
              }
              {
                trigger = ":imho";
                replace = "in my humble opinion";
              }
              {
                trigger = ":btw";
                replace = "by the way";
              }
            ];
          };
          emotes = {
            matches = [
              {
                triggers = [
                  ":+1"
                  ":up"
                  ":ok"
                ];
                replace = "👍🏻️";
              }
              {
                triggers = [
                  ":)"
                  ":-)"
                  ":smile"
                ];
                replace = "😊";
              }
              {
                triggers = [
                  ":|"
                  ":-|"
                  ":grim"
                ];
                replace = "😬";
              }
              {
                triggers = [
                  ":("
                  ":-("
                  ":sad"
                  ":frown"
                ];
                replace = "☹️";
              }
              {
                triggers = [ ":roll" ];
                replace = "🙄";
              }
              {
                triggers = [ ":eye" ];
                replace = "😳🤨";
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
                triggers = [ ":kiss" ];
                replace = "😘";
              }
              {
                triggers = [
                  ":D"
                  ":-D"
                  ":grin"
                ];
                replace = "😁";
              }
              {
                triggers = [
                  ":lau"
                  ":laugh"
                ];
                replace = "😆";
              }
              {
                triggers = [ ":sw" ];
                replace = "😅";
              }
              {
                triggers = [ ":yawn" ];
                replace = "🥱😫";
              }
              {
                triggers = [ ":see" ];
                replace = "🙈";
              }
              {
                triggers = [
                  ":peek"
                  ":cover"
                ];
                replace = "🫣";
              }
              {
                triggers = [ ":hug" ];
                replace = "🤗";
              }
              {
                triggers = [ ":phug" ];
                replace = "🫂";
              }
              {
                triggers = [
                  ";)"
                  ":wink"
                ];
                replace = "😉";
              }
              {
                # Don't use ":p", it's needed by other triggers!
                triggers = [
                  ":P"
                  ":-P"
                  ":tong"
                ];
                replace = "😜";
              }
              {
                triggers = [ ":clap" ];
                replace = "👏👏";
              }
              {
                triggers = [ ":wave" ];
                replace = "👋🏻";
              }
              {
                triggers = [
                  ":pray"
                  ":nam"
                  ":bow"
                  ":thank"
                ];
                replace = "🙏🏻🙇🏻‍♂️";
              }
              {
                triggers = [ ":sun" ];
                replace = "☀️";
              }
              {
                triggers = [
                  ":wow"
                  ":ast"
                ];
                replace = "😲";
              }
              {
                triggers = [
                  ":heart"
                  ":lov"
                ];
                replace = "🫶😍❤️🥰";
              }
              {
                triggers = [
                  ":halo"
                  ":inn"
                  ":angel"
                  "O:)"
                  "O:-)"
                ];
                replace = "😇";
              }
              {
                triggers = [
                  ":crazy"
                  "%)"
                  "%-)"
                  ":zany"
                ];
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
                triggers = [
                  ":cross"
                  ":fing"
                ];
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
                triggers = [
                  ":xmas"
                  ":christ"
                ];
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
                triggers = [
                  ":cry"
                  ":'("
                ];
                replace = "🥹😢😭";
              }
              {
                # Don't use ":/" trigger because of "http://" and "https://"!
                triggers = [
                  ":-/"
                  ":conf"
                ];
                replace = "😕🫤";
              }
              {
                triggers = [ ":fist" ];
                replace = "🤜🏻🤛🏻✊🏻";
              }
              {
                triggers = [
                  ":lambda"
                  ":nix"
                ];
                replace = "λ❄️λ";
              }
              {
                triggers = [
                  ":climb"
                  ":bloulder"
                ];
                replace = "🧗🏼‍♂️";
              }
              {
                triggers = [ ":nerd" ];
                replace = "🤓";
              }
              {
                triggers = [ ":game" ];
                replace = "🎮️";
              }
              {
                triggers = [ ":fruit" ];
                replace = "🥭🍉🍌🍇🍑🍓🍊🍈🍎🍏🍐🍒🍍🥥🥝🍅";
              }
              {
                triggers = [
                  ":penguin"
                  ":linux"
                ];
                replace = "🐧";
              }
            ];
          };
        };
      };
    });
  };
}
