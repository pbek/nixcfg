# This overlay provides a fixed version of the GitHub Copilot plugin for JetBrains IDEs.
# Borrowed from https://github.com/SamueleFacenda/nixos-config/blob/c3df35b40b7e501398ebf7cb53ed0115d65733d9/overlays/jetbrains-plugins.nix
# Fixes https://github.com/NixOS/nixpkgs/issues/400317
# Original plugin handling on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/plugins/specialPlugins.nix#L47

self: super:

let
  id = "17718";
  url = "https://plugins.jetbrains.com/files/17718/765945/github-copilot-intellij-1.5.46-243.zip";
  hash = "sha256-GKCOuZJerzhkhbl4zXWukonkygCT/Dm/tV4zRxFAP+g=";

  # Combine URL and hash to create a unique identifier for the plugin to fix re-evaluation issues
  combined = "${url}-${hash}";
  fullHash = builtins.hashString "sha256" combined;
  shortHash = builtins.substring 0 8 fullHash;
in
{
  jetbrains = super.lib.recursiveUpdate super.jetbrains {
    plugins.github-copilot-fixed = super.stdenv.mkDerivation {
      name = "jetbrains-plugin-${id}-github-copilot-fixed-${shortHash}";
      installPhase = ''
        runHook preInstall
        mkdir -p $out && cp -r . $out
        runHook postInstall
      '';
      src = super.fetchzip {
        inherit url;
        inherit hash;
        executable = false;
      };

      # prelude
      # (function(process, require, console, EXECPATH_FD, PAYLOAD_POSITION, PAYLOAD_SIZE) { return (function (REQUIRE_COMMON, VIRTUAL_FILESYSTEM, DEFAULT_ENTRYPOINT, SYMLINKS, DICT, DOCOMPRESS) {
      # payload
      # grep -aobUam1 $'\x1f\x8b\x08\x00' copilot-language-server

      buildPhase = ''
        agent='copilot-agent/native/${super.lib.toLower super.stdenv.hostPlatform.uname.system}${
          {
            x86_64 = "-x64";
            aarch64 = "-arm64";
          }
          .${super.stdenv.hostPlatform.uname.processor} or ""
        }/copilot-language-server'

        # Helper: find the offset of the payload by matching gzip magic bytes
        find_payload_offset() {
          grep -aobUam1 -f <(printf '\x1f\x8b\x08\x00') "$agent" | cut -d: -f1
        }

        # Helper: find the offset of the prelude by searching for function string start
        find_prelude_offset() {
          local prelude_string='(function(process, require, console, EXECPATH_FD, PAYLOAD_POSITION, PAYLOAD_SIZE) {'
          grep -obUa -- "$prelude_string" "$agent" | cut -d: -f1
        }

        before_payload_position="$(find_payload_offset)"
        before_prelude_position="$(find_prelude_offset)"

        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
        patchelf --set-rpath ${
          super.lib.makeLibraryPath [
            super.glibc
            super.gcc-unwrapped
          ]
        } $agent
        chmod +x $agent

        after_payload_position="$(find_payload_offset)"
        after_prelude_position="$(find_prelude_offset)"

        # There are hardcoded positions in the binary, then it replaces the placeholders by himself
        sed -i -e "s/$before_payload_position/$after_payload_position/g" "$agent"
        sed -i -e "s/$before_prelude_position/$after_prelude_position/g" "$agent"
      '';
    };
  };
}
