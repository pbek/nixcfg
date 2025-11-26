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

### Complete flake.nix Example

Here's a complete `flake.nix` that properly imports and configures the hokage module:

```nix
{
  description = "My NixOS Configuration using Hokage";

  inputs = {
    # Main nixpkgs input
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Import nixcfg for the hokage module
    nixcfg.url = "github:pbek/nixcfg";
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager is required by hokage (if using desktop role)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Agenix is needed if using secrets (optional, can disable with useSecrets = false)
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Catppuccin theme (required by hokage catppuccin module)
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixcfg, home-manager, agenix, catppuccin, ... }@inputs: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # Required: home-manager NixOS module
        home-manager.nixosModules.home-manager

        # Required: agenix module (or disable with hokage.useSecrets = false)
        agenix.nixosModules.age

        # Import the hokage module
        nixcfg.nixosModules.hokage

        # Your configuration
        ./configuration.nix
      ];

      # IMPORTANT: Pass lib-utils through specialArgs
      # The hokage module requires this for loading its submodules
      specialArgs = nixcfg.commonArgs // {
        inherit inputs;
      };
    };
  };
}
```

### Minimal flake.nix (Without Secrets)

If you don't need secrets management, you can simplify:

```nix
{
  description = "My NixOS Configuration using Hokage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixcfg.url = "github:pbek/nixcfg";
    nixcfg.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixcfg, home-manager, catppuccin, ... }@inputs: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        nixcfg.nixosModules.hokage
        ./configuration.nix
      ];
      specialArgs = nixcfg.commonArgs // {
        inherit inputs;
      };
    };
  };
}
```

Then in your `configuration.nix`, disable secrets:

```nix
hokage = {
  hostName = "myhost";
  useSecrets = false;  # Disable agenix requirement
  # ... other options
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

## Common Hokage Configuration Options

### System Roles

The hokage module provides different roles for different use cases:

| Role                | Description              | Key Features                                                           |
| ------------------- | ------------------------ | ---------------------------------------------------------------------- |
| **`desktop`**       | Full desktop environment | KDE Plasma, development tools, graphical applications, optional gaming |
| **`server-remote`** | Remote server            | Minimal packages, SSH hardening, firewall, Docker                      |
| **`ally`**          | Handheld gaming device   | Optimized for Asus ROG Ally hardware                                   |

#### What each role enables:

**Desktop:**

- KDE Plasma desktop environment
- Development tools (C++, Go, JavaScript, PHP)
- PipeWire audio system
- Printing support (CUPS)
- Multiple graphical applications (VSCode, Chrome, etc.)
- Git, Docker, and development utilities
- Optional: Gaming support (Steam, Lutris)
- Optional: NVIDIA driver support

**Server-Remote:**

- Docker virtualization
- SSH server with hardening
- Firewall enabled by default
- ZFS with automatic snapshots
- Fail2ban for security
- Git for configuration management
- Minimal package set
- Optional: Binary cache serving
- Optional: Libvirt virtualization

**Ally:**

- Special handheld device optimizations
- Gaming support pre-configured
- Hardware-specific tweaks

### Essential Options

```nix
hokage = {
  # Required
  hostName = "myhost";              # System hostname
  role = "desktop";                 # System role (see above)

  # User Configuration (optional, has defaults)
  userLogin = "user";               # Primary user login name
  userNameLong = "Full Name";       # Full name for git commits
  userNameShort = "Name";           # Short display name
  userEmail = "user@example.com";   # Email for git and other tools
}
```

### Desktop-Specific Options

```nix
hokage = {
  role = "desktop";

  # Gaming support
  gaming = {
    enable = true;                  # Install Steam, Lutris, etc.
    ryubing.highDpi = false;        # High-DPI support for emulators
  };

  # Graphics options
  nvidia = {
    enable = false;                 # NVIDIA driver support
    open = true;                    # Use open-source NVIDIA drivers
    packageType = "latest";         # "stable", "latest", "beta", "production", "legacy_535"
  };

  # Development languages (enabled by default on desktop)
  languages = {
    cplusplus.enable = true;
    go.enable = true;
    javascript.enable = true;
    php.enable = true;
  };

  # KDE Plasma configuration
  plasma.enable = true;             # Enable KDE Plasma (default on desktop)

  # Catppuccin theming (enabled by default)
  catppuccin = {
    enable = true;                  # Enable catppuccin theme system-wide
    flavor = "mocha";               # Options: "latte", "frappe", "macchiato", "mocha"
  };

  # Audio
  audio.enable = true;              # Enable PipeWire audio (default)
}
```

### Server-Specific Options

```nix
hokage = {
  role = "server-remote";

  # Binary cache configuration
  cache = {
    enable = true;
    sources = [ "remote" ];         # Available: "home", "remote", "caliban"
  };

  # Secrets management
  useSecrets = false;               # Disable agenix secrets if not needed
}
```

### Storage Options

```nix
hokage = {
  # ZFS configuration (recommended for data integrity)
  zfs = {
    enable = true;
    hostId = "12345678";            # Required 8-character hex ID for ZFS
    encrypted = false;              # Enable ZFS encryption
  };
}
```

### Advanced Options

```nix
hokage = {
  # Kernel selection
  kernel = {
    enable = true;                  # Auto-select kernel based on hardware
    maxVersion = pkgs.linuxPackages_latest.kernel;
  };

  # Package exclusions
  excludePackages = with pkgs; [
    thunderbird
    libreoffice
  ];

  # Bandwidth optimization
  lowBandwidth = false;             # Use stable packages to save bandwidth

  # Program-specific options
  programs = {
    aider.enable = false;           # AI coding assistant
    atuin.enable = true;            # Shell history sync
    libvirt.enable = false;         # Virtualization support
  };
}
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
