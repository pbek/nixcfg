# Temporary Linux override until nixpkgs includes 2.3.2's GPT-6.2 prompt-cache fix.
_self: super: {
  opencode =
    if super.stdenv.hostPlatform.isLinux && super.lib.versionOlder super.opencode.version "2.3.2" then
      super.opencode.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "2.3.2";

          src = super.fetchFromGitHub {
            owner = "anomalyco";
            repo = "opencode";
            tag = "v${finalAttrs.version}";
            hash = "sha256-yEdLD000KJPNkuowiy4g+sHV+7dm3xazKTEf15ZIYKs=";
          };

          node_modules = oldAttrs.node_modules.overrideAttrs {
            inherit (finalAttrs) version src;
            outputHash = "sha256-1mWmG+sGm7U8mkC8mF5DWq8kUrJYV6o+nFTdPJpPOsc=";
          };

          # The theme schema moved out of packages/web in OpenCode 2.3.
          installPhase =
            builtins.replaceStrings
              [ "../web/public/theme.json" ]
              [ "../../services/site/public/v1/docs/theme.json" ]
              oldAttrs.installPhase;
        }
      )
    else
      super.opencode;
}
