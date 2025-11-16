# Examples

This directory contains example configurations demonstrating how to use components from the nixcfg flake.

## Available Examples

### hokage-consumer

A complete example showing how to consume the hokage NixOS module from this flake in an external NixOS configuration.

**What it demonstrates:**

- How to add nixcfg as a flake input
- How to import the hokage module
- How to configure hokage options
- Example configuration.nix using hokage features

**Quick start:**

```bash
cd hokage-consumer
cat README.md
```

## Using These Examples

Each example directory contains:

- A complete flake.nix
- Configuration files
- A README with specific instructions
- A .gitignore for Nix artifacts

You can copy any example directory to your own location and customize it for your needs.

## Documentation

- [Hokage Module Export Guide](./HOKAGE_MODULE_EXPORT.md) - Detailed guide on how the hokage module is exposed and consumed
- [Hokage Options](../docs/hokage-options.md) - Complete list of available hokage configuration options

## Testing Examples Locally

Since these examples are in the same repository, they use local path references:

```nix
nixcfg.url = "path:../..";
```

When you copy an example to use elsewhere, change this to:

```nix
nixcfg.url = "github:pbek/nixcfg";
```

Or use your own fork/branch:

```nix
nixcfg.url = "github:yourusername/nixcfg/yourbranch";
```
