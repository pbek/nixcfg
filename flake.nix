{
  description = "pbek's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#    nixinate.url = "github:matthewcroughan/nixinate";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
#    robotnix.url = "github:danielfullmer/robotnix";
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
  { self
#      , nixinate
  , home-manager
  , nixpkgs
  , agenix
  , pia
  , catppuccin
  , disko
  , nixos-hardware
  , plasma-manager
  , espanso-fix
#      , robotnix
  , ...
  } @ inputs: {
#     config = nixpkgs.config.systems.${builtins.currentSystem}.config;
#     hostname = config.networking.hostName;
    nixosModules = import ./modules { inherit (nixpkgs) lib; };
    commonArgs = {
      username = "omega";
      termFontSize = 12.0;
      # By default we will use Wayland with Plasma 6
      x11Support = false;
      waylandSupport = true;
      usePlasma6 = true;  # Plasma 6 is the default, otherwise use Plasma 5
    };

    nixosConfigurations = {
      # Office Work PC
      gaia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/gaia/configuration.nix
          ./hosts/gaia/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          x11Support = true;
          waylandSupport = false;
        };
      };
      # PC Garage
      pluto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pluto/configuration.nix
          ./hosts/pluto/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          x11Support = true;
          waylandSupport = false;
        };
      };
      # Asus Laptop
      jupiter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/jupiter/configuration.nix
          ./hosts/jupiter/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
        };
      };
      # macBook
      neptun = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/neptun/configuration.nix
          ./hosts/neptun/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Livingroom PC
      venus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/venus/configuration.nix
          ./hosts/venus/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
         x11Support = true;
         waylandSupport = false;
        };
      };
      # Asus Vivobook Laptop
      rhea = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rhea/configuration.nix
          ./hosts/rhea/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
        };
      };
      # Acer Aspire 5 Laptop
      hyperion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hyperion/configuration.nix
          ./hosts/hyperion/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          disko.nixosModules.disko
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
        };
      };
      # Asus ROG Ally (usually using Windows)
      ally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ally/configuration.nix
          ./hosts/ally/hardware-configuration.nix
          nixos-hardware.nixosModules.asus-ally-rc71l
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
          espanso-fix.nixosModules.espanso-capdacoverride
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          termFontSize = 15.0;
        };
      };
      # Asus ROG Ally (using NixOS)
      ally2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ally2/configuration.nix
          ./hosts/ally2/hardware-configuration.nix
          nixos-hardware.nixosModules.asus-ally-rc71l
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          disko.nixosModules.disko
          agenix.nixosModules.age
          espanso-fix.nixosModules.espanso-capdacoverride
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          termFontSize = 15.0;
        };
      };

      # TUG VM
      astra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/astra/configuration.nix
          ./hosts/astra/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
          espanso-fix.nixosModules.espanso-capdacoverride
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          x11Support = true;
          waylandSupport = false;
          termFontSize = 16.0;
          usePlasma6 = true;
        };
      };
      # TU Work PC
      caliban = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/caliban/configuration.nix
          ./hosts/caliban/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
          espanso-fix.nixosModules.espanso-capdacoverride
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          x11Support = true;
          waylandSupport = false;
          usePlasma6 = true;
        };
      };
      # TU HP EliteBook Laptop 820 G4
      eris = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/eris/configuration.nix
          ./hosts/eris/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # TU HP EliteBook Laptop 840 G5
      sinope= nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sinope/configuration.nix
          ./hosts/sinope/hardware-configuration.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
        };
      };
      # VM Desktop
      vm-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vm-desktop/vm.nix
          home-manager.nixosModules.home-manager { home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ]; }
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # VM Server
      vm-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vm-server/vm.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Netcup Server netcup01
      netcup01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/netcup01/configuration.nix
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Netcup Server netcup02
      netcup02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/netcup02/configuration.nix
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Home Server home01
      home01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/home01/configuration.nix
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Server moobox01 for Alex
      moobox01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/moobox01/configuration.nix
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          username = "cow";
        };
      };
      # Home Server miniserver24 for Markus
      miniserver24 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/miniserver24/configuration.nix
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          username = "mba";
        };
      };
      vm-netcup02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/netcup02/vm.nix
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      vm-miniserver24 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          ./hosts/miniserver24/vm.nix
        ];
        specialArgs = self.commonArgs // {
          inherit inputs;
          username = "mba";
        };
      };
    };
  };
}
