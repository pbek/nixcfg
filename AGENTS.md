# AGENTS.md

This file is a quick orientation guide for coding agents working in this repository.

## What this repo is

- Personal multi-host NixOS flake for desktops, laptops, servers, and test VMs.
- Main entrypoint is `flake.nix`.
- Host-level configs are composed from shared modules plus per-host files under `hosts/`.
- The custom shared module set is `modules/hokage` (also exported as `nixosModules.hokage`).

## Where hosts are configured

There are two places to care about:

1. Host declarations in `flake.nix`:
   - `nixosConfigurations.<host> = mkDesktopHost ...` or `mkServerHost ...`
   - This is the authoritative list of buildable hosts.
2. Per-host files in `hosts/<host>/`:
   - `configuration.nix` (required)
   - `hardware-configuration.nix` (typically required)
   - Optional disk layouts like `disk-config.zfs.nix`, `disk-config.ext4.nix`, `disk-config.bcachefs.nix`
   - Some hosts also have `vm.nix` and/or host-specific README/install scripts.

If you add a host, update both `hosts/<host>/...` and `flake.nix`.

## Host composition model

- `mkDesktopHost` and `mkServerHost` are defined in `flake.nix`.
- Both include shared module lists:
  - `commonModules` -> home-manager, catppuccin, agenix, `./modules/hokage`, overlays.
  - Desktop hosts additionally include desktop-oriented modules (for example plasma-manager, nixbit, uncrash, zfsguard).
- Many hosts add `disko.nixosModules.disko` in their per-host module list.

## Useful paths

- `flake.nix`: inputs, overlays, host registry, checks, exported packages.
- `hosts/`: per-machine configs.
- `modules/hokage/`: shared NixOS options and defaults used by most machines.
- `pkgs/`: local package definitions/overlays.
- `overlays/`: custom overlay files loaded automatically from directory.
- `secrets/`: agenix-encrypted secrets and recipient mapping (`secrets/secrets.nix`).
- `tests/qownnotes.nix`: NixOS test in flake checks.
- `justfile`: daily workflows (build/switch/check, cache push, docs, tests, maintenance).

## Common workflows for agents

- Build/check one host:
  - `just check-host <hostname>`
  - `just build-host <hostname>`
- Work on current machine:
  - `just check`
  - `just build`
  - `just switch`
- Validate all declared hosts (eval-level check):
  - `just check-all`
- Run tests:
  - `just test-qownnotes`

Prefer `just` recipes over inventing ad-hoc commands when possible.

## Secrets and safety notes

- Never commit plaintext secrets.
- Encrypted files live in `secrets/*.age`; recipients are managed via `secrets/secrets.nix`.
- After adding a new host that needs secrets, rekey agenix secrets (see `README.md` and `just rekey`).
- Avoid changing hostnames casually; host names are used as flake output keys and deployment targets.

## Conventions to follow

- Keep changes scoped to the relevant host/module/package.
- If you add a new host option, prefer implementing it in `modules/hokage` so it is reusable.
- If you add a host to `hosts/`, ensure `flake.nix` includes it in `nixosConfigurations`.
- If changing shared behavior, consider impact on both desktop and server host constructors.

## Pointers

- High-level project usage: `README.md`
- Hokage option reference: `docs/hokage-options.md`
