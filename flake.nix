{
  description = "pbek's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#    nixinate.url = "github:matthewcroughan/nixinate";
    home-manager.url = "github:nix-community/home-manager";
    agenix.url = "github:ryantm/agenix";
    attic.url = "github:zhaofengli/attic";
#    robotnix.url = "github:danielfullmer/robotnix";
    pia.url = "github:pia-foss/manual-connections";
    pia.flake = false;
    catppuccin.url = "github:catppuccin/starship";
    catppuccin.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

outputs =
  { self
#      , nixinate
  , home-manager
  , nixpkgs
  , agenix
  , attic
  , pia
  , catppuccin
  , disko
#      , robotnix
  , ...
  } @ inputs: {
#     config = nixpkgs.config.systems.${builtins.currentSystem}.config;
#     hostname = config.networking.hostName;
    nixosModules = import ./modules { lib = nixpkgs.lib; };
    commonArgs = {
      username = "omega";
      weztermFontSize = "15.0";
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
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          x11Support = true;
          waylandSupport = false;
          usePlasma6 = false;
        };
      };
      # PC Garage
      pluto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pluto/configuration.nix
          ./hosts/pluto/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
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
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          weztermFontSize = "12.0";
        };
      };
      # macBook
      neptun = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/neptun/configuration.nix
          ./hosts/neptun/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # Livingroom PC
      venus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/venus/configuration.nix
          ./hosts/venus/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
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
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          weztermFontSize = "12.0";
        };
      };
      # Acer Aspire 5 Laptop
      hyperion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hyperion/configuration.nix
          ./hosts/hyperion/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          weztermFontSize = "12.0";
        };
      };

      # TUG VM
      astra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/astra/configuration.nix
          ./hosts/astra/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          x11Support = true;
          waylandSupport = false;
        };
      };
      # TU Work PC
      caliban = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/caliban/configuration.nix
          ./hosts/caliban/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          weztermFontSize = "12.0";
          x11Support = true;
          waylandSupport = false;
          usePlasma6 = false;
        };
      };
      # TU HP EliteBook Laptop 820 G4
      eris = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/eris/configuration.nix
          ./hosts/eris/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // { inherit inputs; };
      };
      # TU HP EliteBook Laptop 840 G5
      sinope= nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sinope/configuration.nix
          ./hosts/sinope/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
        ];
        specialArgs = self.commonArgs // {
          inputs = inputs;
          weztermFontSize = "12.0";
        };
      };
      # VM Desktop
      vm-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vm-desktop/vm.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          attic.nixosModules.atticd
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
          attic.nixosModules.atticd
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
          inputs = inputs;
          username = "cow";
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
    };
  };
}
