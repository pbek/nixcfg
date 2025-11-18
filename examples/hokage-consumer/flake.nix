{
  description = "Example NixOS configuration consuming the hokage module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Import the nixcfg flake to get the hokage module
    # For local development/testing (default in this example):
    nixcfg.url = "git+file:../..?shallow=1";
    # For production use, change to:
    # nixcfg.url = "github:pbek/nixcfg";
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";

    # Required by hokage module
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Required by starship module in hokage
    catppuccin.url = "github:catppuccin/starship";
    catppuccin.flake = false;
  };

  outputs =
    {
      nixpkgs,
      nixcfg,
      agenix,
      plasma-manager,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import the hokage module from nixcfg
            nixcfg.nixosModules.hokage

            # Import agenix (required by hokage)
            agenix.nixosModules.age

            # Import home-manager with plasma-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            }

            # Import the local configuration
            ./desktop/configuration.nix
          ];
          specialArgs = {
            inherit inputs;
            # Pass lib-utils from nixcfg if needed
            lib-utils = nixcfg.commonArgs.lib-utils;
          };
        };
        server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import the hokage module from nixcfg
            nixcfg.nixosModules.hokage

            # Import agenix (required by hokage)
            agenix.nixosModules.age

            # Import home-manager
            home-manager.nixosModules.home-manager

            # Import the local configuration
            ./server/configuration.nix
          ];
          specialArgs = {
            inherit inputs;
            # Pass lib-utils from nixcfg if needed
            lib-utils = nixcfg.commonArgs.lib-utils;
          };
        };
      };
    };
}
