{
  description = "pbek's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    pia.url = "github:pia-foss/manual-connections";
    pia.flake = false;
    catppuccin.url = "github:catppuccin/starship";
    catppuccin.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-stable,
      agenix,
      disko,
      nixos-hardware,
      plasma-manager,
      espanso-fix,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      overlaysDir = ./overlays;
      overlaysFromDir = builtins.filter (x: x != null) (
        builtins.attrValues (
          builtins.mapAttrs (
            name: type:
            if type == "regular" && builtins.match ".*\\.nix$" name != null then
              import (overlaysDir + "/${name}")
            else
              null
          ) (builtins.readDir overlaysDir)
        )
      );
      overlays-nixpkgs = _final: _prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
      validOverlays = builtins.filter (x: builtins.isFunction x) overlaysFromDir;
      allOverlays = validOverlays ++ [ overlays-nixpkgs ];
      commonServerModules = [
        home-manager.nixosModules.home-manager
        { }
        (_: {
          nixpkgs.overlays = allOverlays;
        })
        # We still need the age module for servers, because it needs to evaluate "age" in the services
        agenix.nixosModules.age
      ];
      commonDesktopModules = [
        home-manager.nixosModules.home-manager
        { home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ]; }
        (_: {
          nixpkgs.overlays = allOverlays;
        })
        agenix.nixosModules.age
        espanso-fix.nixosModules.espanso-capdacoverride
      ];
      mkDesktopHost =
        hostName: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            commonDesktopModules
            ++ [
              ./hosts/${hostName}/configuration.nix
            ]
            ++ extraModules;
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
      mkServerHost =
        hostName: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            commonServerModules
            ++ [
              ./hosts/${hostName}/configuration.nix
            ]
            ++ extraModules;
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
    in
    {
      #     config = nixpkgs.config.systems.${builtins.currentSystem}.config;
      #     hostname = config.networking.hostName;
      #    nixosModules = import ./modules { inherit (nixpkgs) lib; };
      commonArgs = {
        lib-utils = import ./lib/utils.nix { inherit (nixpkgs) lib; };
      };

      nixosConfigurations = {
        # Office Work PC
        gaia = mkDesktopHost "gaia" [ ];
        # Livingroom PC
        venus = mkDesktopHost "venus" [ disko.nixosModules.disko ];
        # Asus Vivobook Laptop
        rhea = mkDesktopHost "rhea" [ ];
        # Acer Aspire 5 Laptop
        hyperion = mkDesktopHost "hyperion" [ disko.nixosModules.disko ];
        # Asus ROG Ally (using NixOS)
        ally2 = mkDesktopHost "ally2" [
          nixos-hardware.nixosModules.asus-ally-rc71l
          disko.nixosModules.disko
        ];
        # TUG VM
        astra = mkDesktopHost "astra" [ disko.nixosModules.disko ];
        astra-beta = mkDesktopHost "astra-beta" [ disko.nixosModules.disko ];
        # TU Work PC
        caliban = mkDesktopHost "caliban" [
          disko.nixosModules.disko
        ];
        # TU HP EliteBook Laptop 840 G5
        sinope = mkDesktopHost "sinope" [ ];
        # Netcup Server netcup01
        netcup01 = mkServerHost "netcup01" [ disko.nixosModules.disko ];
        # Netcup Server netcup02
        netcup02 = mkServerHost "netcup02" [ disko.nixosModules.disko ];
        # Home Server home01
        home01 = mkServerHost "home01" [ disko.nixosModules.disko ];
        # Server moobox01 for Alex
        moobox01 = mkServerHost "moobox01" [ disko.nixosModules.disko ];
        # Asus Laptop
        jupiter = mkDesktopHost "jupiter" [ ];
        # Asus ROG Ally (usually using Windows)
        ally = mkDesktopHost "ally" [ nixos-hardware.nixosModules.asus-ally-rc71l ];
        # PC Garage
        pluto = mkDesktopHost "pluto" [ ];
        # macBook
        neptun = mkDesktopHost "neptun" [ ];
        # TU HP EliteBook Laptop 820 G4
        eris = mkDesktopHost "eris" [ ];
        # TU "Guest" HP EliteBook Laptop 840 G5
        dp01 = mkDesktopHost "dp01" [ ];
        # TU ThinkBook Manuel
        dp02 = mkDesktopHost "dp02" [ ];
        # TU ThinkBook Andrea
        dp03 = mkDesktopHost "dp03" [ disko.nixosModules.disko ];
        # TU Thinkstation Andrea
        dp04 = mkDesktopHost "dp04" [ disko.nixosModules.disko ];
        # TU Thinkbook Tobias
        dp05 = mkDesktopHost "dp05" [ disko.nixosModules.disko ];
        # TU ThinkBook Shiva
        dp06 = mkDesktopHost "dp06" [ disko.nixosModules.disko ];
        # TU Laptop Arslan - Lenovo Yoga Pro 9i
        dp07 = mkDesktopHost "dp07" [ disko.nixosModules.disko ];
        # TU Gaming Station - ThinkCentre M720q
        dp08 = mkDesktopHost "dp08" [ disko.nixosModules.disko ];
        # MBA Miniserver24
        miniserver24 = mkServerHost "miniserver24" [ disko.nixosModules.disko ];
        # MBA Gaming PC
        mba-gaming-pc = mkDesktopHost "mba-gaming-pc" [ disko.nixosModules.disko ];
        # MBA Miniserver ww87
        mba-msww87 = mkServerHost "mba-msww87" [ disko.nixosModules.disko ];
      };
    };
}
