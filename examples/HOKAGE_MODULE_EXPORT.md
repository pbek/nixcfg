# Hokage Module Export

This document describes how the hokage module is exported from the nixcfg flake for consumption by other NixOS configurations.

## Changes Made

### 1. Exposed the hokage module in flake.nix

The hokage module is now exposed as a flake output:

```nix
nixosModules = {
  hokage = import ./modules/hokage;
  default = import ./modules/hokage;
};
```

This allows other flakes to import the hokage module using:

- `nixcfg.nixosModules.hokage` (explicit)
- `nixcfg.nixosModules.default` (default module)

### 2. Created Example Consumer Configuration

Location: `examples/hokage-consumer/`

Files created:

- `flake.nix` - Example flake that imports the hokage module from nixcfg
- `configuration.nix` - Example NixOS configuration using hokage options
- `README.md` - Documentation on how to use the example
- `.gitignore` - Ignore build artifacts

## How to Use the Hokage Module in Other Projects

### Step 1: Add nixcfg as a flake input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixcfg.url = "github:pbek/nixcfg";
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

### Step 2: Import the module in your NixOS configuration

```nix
outputs = { self, nixpkgs, nixcfg, ... }@inputs: {
  nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # Import the hokage module
      nixcfg.nixosModules.hokage

      # Your configuration
      ./configuration.nix
    ];
    specialArgs = {
      inherit inputs;
      # Pass lib-utils if needed by hokage
      lib-utils = nixcfg.commonArgs.lib-utils;
    };
  };
};
```

### Step 3: Configure hokage options in configuration.nix

```nix
{ config, pkgs, lib, ... }: {
  hokage = {
    enable = true;
    userLogin = "myuser";

    desktop = {
      enable = true;
      type = "plasma";
    };

    # Additional options...
  };
}
```

## Testing the Example

```bash
# Navigate to the example directory
cd examples/hokage-consumer

# Check the flake
nix flake check

# Build the configuration (won't actually install)
nix build .#nixosConfigurations.example-host.config.system.build.toplevel

# For actual installation (on target hardware):
sudo nixos-rebuild switch --flake .#example-host
```

## Available Hokage Options

For a complete list of available hokage options, you can:

1. View the generated documentation:

   ```bash
   nix build .#hokage-options-md
   cat result
   ```

2. Or check the docs directory:
   ```bash
   cat docs/hokage-options.md
   ```

## Notes

- The hokage module requires `lib-utils` which should be passed through `specialArgs`
- The module automatically imports `common.nix` and all submodules from the hokage directory
- Make sure to follow nixpkgs input to avoid version conflicts
