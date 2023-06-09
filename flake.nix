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
#      , robotnix
  , ...
  } @ inputs: {
#     config = nixpkgs.config.systems.${builtins.currentSystem}.config;
#     hostname = config.networking.hostName;
    nixosModules = import ./modules { lib = nixpkgs.lib; };

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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
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
        specialArgs = { inherit inputs; };
      };
    };
  };
}
