# Quick Reference: Using the Hokage Module

## Minimal Example

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixcfg.url = "github:pbek/nixcfg";
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager";
    plasma-manager.url = "github:nix-community/plasma-manager";

    # Follow nixpkgs for all
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, nixcfg, agenix, plasma-manager, home-manager, ... }@inputs: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixcfg.nixosModules.hokage
        agenix.nixosModules.age
        home-manager.nixosModules.home-manager
        { home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ]; }
        ./configuration.nix
      ];
      specialArgs = {
        inherit inputs;
        lib-utils = nixcfg.commonArgs.lib-utils;
        utils.removePackagesByName = list: excluded:
          nixpkgs.lib.filter (p:
            !(nixpkgs.lib.any (q: (q.pname or q.name or "") == (p.pname or p.name or "")) excluded)
          ) list;
      };
    };
  };
}
```

```nix
# configuration.nix
{ config, pkgs, lib, ... }: {
  system.stateVersion = "25.05";
  networking.hostName = "myhost";

  hokage = {
    userLogin = "myuser";
    role = "desktop";
    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
  };

  users.users.myuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    users.myuser = {
      home.stateVersion = "25.05";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
```

## Available in This Repository

- **Full example**: `examples/hokage-consumer/`
- **Documentation**: `examples/HOKAGE_MODULE_EXPORT.md`
- **Summary**: `HOKAGE_MODULE_EXPORT_SUMMARY.md`
