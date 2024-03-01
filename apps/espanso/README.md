# espanso-wayland 2.2.1 for NixOS

This project provides **espanso-wayland** for NixOS, tested on NixOS with the **hyprland** configuration. It is based on the package available in the [Nixpkgs repository](https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/applications/office/espanso).

## Installation Steps:

1. **Clone the Project:**
   ```
   git clone https://github.com/ingbarrozo/espanso.git
   ```

2. **Move the 'espanso' Folder:**
   Move the downloaded **espanso** folder to your desired location.

3. **Import the Module:**
   In your **home-manager** configuration, import the **espanso** module. For example:
   ```nix
     imports = [
      ./espanso
    ];
   ```

4. **Enable Espanso:**
   Enable **espanso** in your home-manager configuration:
   ```nix
   programs.espanso.enable = true;
   ```

5. **Add User to 'input' Group:**
   Ensure your user is part of the **input** group. For example:
   ```nix
   users.users."yourusername".extraGroups = [ "input" ];
   ```

   ```markdown
   # Note
   Don't forget to run `nixos-rebuild` after making changes to your configuration.
   ```

6. **Register Espanso Service:**
   Run the following command to register the **espanso** service:
   ```
   espanso service register
   ```

7. **Restart Espanso:**
   Restart **espanso** to apply the changes:
   ```
   espanso restart
   ```
