{
  description = "Example NixOS configuration consuming the hokage module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Import the nixcfg flake to get the hokage module
    # For local development/testing (default in this example):
    nixcfg.url = "path:../..";
    # For production use, change to:
    # nixcfg.url = "github:pbek/nixcfg";
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";

    # Note: We don't need to declare agenix, plasma-manager, home-manager, or catppuccin here
    # because they're already available through nixcfg.commonArgs.inputs
  };

  outputs =
    {
      nixpkgs,
      nixcfg,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import catppuccin module (required by hokage)
            nixcfg.commonArgs.inputs.catppuccin.nixosModules.catppuccin

            # Import the hokage module from nixcfg
            nixcfg.nixosModules.hokage

            # Import agenix (required by hokage) - from nixcfg's inputs
            nixcfg.commonArgs.inputs.agenix.nixosModules.age

            # Import home-manager with plasma-manager - from nixcfg's inputs
            nixcfg.commonArgs.inputs.home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                nixcfg.commonArgs.inputs.plasma-manager.homeModules.plasma-manager
              ];
            }

            # Import the local configuration
            ./desktop/configuration.nix
          ];
          specialArgs = nixcfg.commonArgs;
        };
        server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import catppuccin module (required by hokage)
            nixcfg.commonArgs.inputs.catppuccin.nixosModules.catppuccin

            # Import the hokage module from nixcfg
            nixcfg.nixosModules.hokage

            # Import agenix (required by hokage) - from nixcfg's inputs
            nixcfg.commonArgs.inputs.agenix.nixosModules.age

            # Import home-manager - from nixcfg's inputs
            nixcfg.commonArgs.inputs.home-manager.nixosModules.home-manager

            # Import the local configuration
            ./server/configuration.nix
          ];
          specialArgs = nixcfg.commonArgs;
        };
      };
    };
}
