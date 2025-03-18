{
  description = "pbek's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
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
      pia,
      catppuccin,
      disko,
      nixos-hardware,
      plasma-manager,
      espanso-fix,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      overlays-nixpkgs = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
      commonServerModules = [
        home-manager.nixosModules.home-manager
        { }
        (
          { ... }:
          {
            nixpkgs.overlays = [ overlays-nixpkgs ];
          }
        )
      ];
      commonDesktopModules = [
        home-manager.nixosModules.home-manager
        { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
        (
          { ... }:
          {
            nixpkgs.overlays = [ overlays-nixpkgs ];
          }
        )
        agenix.nixosModules.age
        espanso-fix.nixosModules.espanso-capdacoverride
      ];
    in
    {
      #     config = nixpkgs.config.systems.${builtins.currentSystem}.config;
      #     hostname = config.networking.hostName;
      #    nixosModules = import ./modules { inherit (nixpkgs) lib; };
      commonArgs = {
      };

      nixosConfigurations = {
        # Office Work PC
        gaia = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/gaia/configuration.nix
            ./hosts/gaia/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Livingroom PC
        venus = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/venus/configuration.nix
            ./hosts/venus/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Asus Vivobook Laptop
        rhea = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/rhea/configuration.nix
            ./hosts/rhea/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Acer Aspire 5 Laptop
        hyperion = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/hyperion/configuration.nix
            ./hosts/hyperion/hardware-configuration.nix
            disko.nixosModules.disko
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Asus ROG Ally (using NixOS)
        ally2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/ally2/configuration.nix
            ./hosts/ally2/hardware-configuration.nix
            nixos-hardware.nixosModules.asus-ally-rc71l
            disko.nixosModules.disko
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };

        # TUG VM
        astra = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/astra/configuration.nix
            ./hosts/astra/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU Work PC
        caliban = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/caliban/configuration.nix
            ./hosts/caliban/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
            agenix.nixosModules.age
            disko.nixosModules.disko
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU HP EliteBook Laptop 840 G5
        sinope = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/sinope/configuration.nix
            ./hosts/sinope/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Netcup Server netcup01
        netcup01 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonServerModules ++ [
            disko.nixosModules.disko
            ./hosts/netcup01/configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Netcup Server netcup02
        netcup02 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonServerModules ++ [
            disko.nixosModules.disko
            ./hosts/netcup02/configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Home Server home01
        home01 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonServerModules ++ [
            disko.nixosModules.disko
            ./hosts/home01/configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Server moobox01 for Alex
        moobox01 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonServerModules ++ [
            disko.nixosModules.disko
            ./hosts/moobox01/configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Asus Laptop
        jupiter = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/jupiter/configuration.nix
            ./hosts/jupiter/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # Asus ROG Ally (usually using Windows)
        ally = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/ally/configuration.nix
            ./hosts/ally/hardware-configuration.nix
            nixos-hardware.nixosModules.asus-ally-rc71l
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # PC Garage
        pluto = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/pluto/configuration.nix
            ./hosts/pluto/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # macBook
        neptun = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/neptun/configuration.nix
            ./hosts/neptun/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU HP EliteBook Laptop 820 G4
        eris = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/eris/configuration.nix
            ./hosts/eris/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU "Guest" HP EliteBook Laptop 840 G5
        dp01 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/dp01/configuration.nix
            ./hosts/dp01/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU ThinkBook Manuel
        dp02 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/dp02/configuration.nix
            ./hosts/dp02/hardware-configuration.nix
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        # TU ThinkBook Jenny
        dp03 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/dp03/configuration.nix
            ./hosts/dp03/hardware-configuration.nix
            disko.nixosModules.disko
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        dp04 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonDesktopModules ++ [
            ./hosts/dp04/configuration.nix
            ./hosts/dp04/hardware-configuration.nix
            disko.nixosModules.disko
          ];
          specialArgs = self.commonArgs // {
            inherit inputs;
          };
        };
        #      # Home Server miniserver24 for Markus
        #      miniserver24 = nixpkgs.lib.nixosSystem {
        #        inherit system;
        #        modules = [
        #          home-manager.nixosModules.home-manager
        #          disko.nixosModules.disko
        #          ./hosts/miniserver24/configuration.nix
        #        ];
        #        specialArgs = self.commonArgs // {
        #          inherit inputs;
        #          userLogin = "mba";
        #        };
        #      };
        #      vm-netcup02 = nixpkgs.lib.nixosSystem {
        #        inherit system;
        #        modules = [
        #          home-manager.nixosModules.home-manager
        #          disko.nixosModules.disko
        #          ./hosts/netcup02/vm.nix
        #        ];
        #        specialArgs = self.commonArgs // { inherit inputs; };
        #      };
        #      vm-miniserver24 = nixpkgs.lib.nixosSystem {
        #        inherit system;
        #        modules = [
        #          home-manager.nixosModules.home-manager
        #          disko.nixosModules.disko
        #          ./hosts/miniserver24/vm.nix
        #        ];
        #        specialArgs = self.commonArgs // {
        #          inherit inputs;
        #          userLogin = "mba";
        #        };
        #      };
        #      # VM Desktop
        #      vm-desktop = nixpkgs.lib.nixosSystem {
        #        inherit system;
        #        modules = [
        #          ./hosts/vm-desktop/vm.nix
        #          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
        #          agenix.nixosModules.age
        #        ];
        #        specialArgs = self.commonArgs // { inherit inputs; };
        #      };
        #      # VM Server
        #      vm-server = nixpkgs.lib.nixosSystem {
        #        inherit system;
        #        modules = [
        #          ./hosts/vm-server/vm.nix
        #          home-manager.nixosModules.home-manager
        #          agenix.nixosModules.age
        #        ];
        #        specialArgs = self.commonArgs // { inherit inputs; };
        #      };
      };
    };
}
