# Hokage Module Consumer Example

This directory contains an example NixOS configuration that consumes the `hokage` module from the nixcfg flake.

## Structure

- `flake.nix` - The flake configuration that imports the hokage module with all required dependencies
- `configuration.nix` - Example NixOS configuration using hokage options

## Required Dependencies

The hokage module requires several inputs to function properly:

1. **agenix** - Secret management (required by hokage)
2. **home-manager** - User environment management
3. **plasma-manager** - KDE Plasma configuration (required for desktop setups)

## Usage

### Method 1: Using the GitHub flake (recommended for production)

1. Copy this directory to your desired location
2. Edit `flake.nix` to use the GitHub URL:
   ```nix
   nixcfg.url = "github:pbek/nixcfg";
   ```
3. Edit `configuration.nix` to customize for your system:
   - Change hostname
   - Set your username in `hokage.userLogin`
   - Configure hardware (bootloader, disk setup, etc.)
   - Enable desired hokage features

4. Build and deploy:
   ```bash
   # Build the configuration
   sudo nixos-rebuild switch --flake .#example-host
   ```

### Method 2: Local development/testing

1. In `flake.nix`, use the local path:
   ```nix
   nixcfg.url = "path:/home/omega/Code/nixcfg";
   ```
2. Follow steps 3-4 from Method 1

## Available Hokage Options

The hokage module provides configuration through several key options:

### Role-based Configuration

```nix
hokage.role = "desktop"; # Options: "desktop", "server-home", "server-remote", "ally"
```

### User Configuration

```nix
hokage.userLogin = "myuser"; # Primary user for the system
```

### Infrastructure Settings

```nix
hokage.useInternalInfrastructure = false; # Disable for external use
hokage.useSecrets = false; # Disable if not using agenix secrets
hokage.useSharedKey = false; # Disable if not using shared SSH keys
```

### Display Server

```nix
hokage.waylandSupport = true; # Use Wayland (true) or X11 (false)
hokage.useGraphicalSystem = true; # Enable graphical environment
```

### Additional Options

For a complete list of options, see the [hokage module documentation](../../docs/hokage-options.md) or generate it with:

```bash
nix build .#hokage-options-md
```

## Notes

- The hokage module requires `lib-utils` and `utils` to be passed through `specialArgs`
- The `utils.removePackagesByName` function is used to filter packages
- Make sure to add a hardware-configuration.nix if you're installing on real hardware
- Set user passwords after first boot: `sudo passwd myuser`
- The hokage module requires agenix, home-manager, and plasma-manager as dependencies

## Troubleshooting

If you encounter issues:

1. Ensure all flake inputs are up to date:

   ```bash
   nix flake update
   ```

2. Check for evaluation errors:

   ```bash
   nix flake check
   ```

3. Verify the hokage module is properly imported:
   ```bash
   nix eval .#nixosConfigurations.example-host.config.hokage.enable
   ```
