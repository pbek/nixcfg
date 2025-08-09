{ config, lib, ... }:

let
  cfg = config.hokage.cache;
in
{
  options.hokage.cache = {
    enable = lib.mkEnableOption "cache service" // {
      default = true;
    };
    sources = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "home"
          "remote"
          "caliban"
        ]
      );
      default = [ "remote" ];
      description = "List of cache sources to enable";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        # Use those substituters with the highest priority
        # Check with for example: nix eval .#nixosConfigurations.venus.config.nix.settings.substituters
        substituters = lib.mkBefore (
          lib.concatLists [
            (lib.optionals (builtins.elem "home" cfg.sources) [
              # Local home01 nix binary cache
              "http://home01.lan:5000"
              # Local attic
              "http://cicinas2.lan:8050/nix-store"
              # Local nginx nix cache
              "http://cicinas2.lan:8282"
              # Local nginx devenv cachix cache
              "http://cicinas2.lan:8283"
            ])
            (lib.optionals (builtins.elem "remote" cfg.sources) [
              "https://cache.nixos.org/"
            ])
            (lib.optionals (builtins.elem "caliban" cfg.sources) [
              # Local caliban nix binary cache
              "http://caliban-1.netbird.cloud:5000"
            ])
          ]
        );
        trusted-public-keys = lib.concatLists [
          (lib.optionals (builtins.elem "home" cfg.sources) [
            "home01.lan:/9arPyImijmvlBXeb8vVyOe67KH8Q7AeihW6MKtLDLQ="
            "nix-store:p02fHdHXqUw9LSUgz8NiiTSnn+jbqBQ6XRypKz0axQw="
          ])
          (lib.optionals (builtins.elem "remote" cfg.sources) [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ])
          (lib.optionals (builtins.elem "caliban" cfg.sources) [
            "caliban-1.netbird.cloud:pSAazh7Bk3TCDrx5+V1sJZxyCB4R8HpXOBVyJufFqRA="
          ])
        ];
      };
    };

    # Add static hosts in case there are troubles with DNS
    networking.hosts = lib.mkIf (builtins.elem "home" cfg.sources) {
      "192.168.1.115" = [ "home01.lan" ];
      "192.168.1.111" = [ "cicinas2.lan" ];
    };
  };
}
