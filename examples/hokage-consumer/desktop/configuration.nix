{ pkgs, ... }:

{
  # Basic system configuration
  system.stateVersion = "25.05";

  # Hostname
  networking.hostName = "example-desktop";

  # Enable hokage module configurations
  hokage = {
    hostName = "example-desktop";
    userLogin = "john";
    userNameLong = "John Doe";
    userNameShort = "John";
    userEmail = "john@example.com";
    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;
    programs.espanso.enable = false;
    programs.git.enableUrlRewriting = false;
    role = "desktop"; # Options: "desktop", "server-home", "server-remote", "ally"

    # Additional hokage options can be configured here
    # See the hokage module documentation for all available options
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.myuser =
      { pkgs, ... }:
      {
        home.stateVersion = "25.05";

        # Add user-specific home-manager configuration here
        home.packages = with pkgs; [
          # Additional packages
        ];
      };
  };

  # User configuration
  users.users.myuser = {
    isNormalUser = true;
    description = "My User";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    # Set password with: sudo passwd myuser
  };

  # Bootloader configuration (adjust to your needs)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem configuration (adjust to your needs)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Network configuration
  networking.networkmanager.enable = true;

  # Additional system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Additional configuration as needed
}
