{ pkgs, ... }:

{
  # Basic system configuration
  system.stateVersion = "25.05";

  # Hostname
  networking.hostName = "example-host";

  # Enable hokage module configurations
  hokage = {
    userLogin = "myuser";
    role = "desktop"; # Options: "desktop", "server-home", "server-remote", "ally"

    # These are internal settings - you may want to disable them for external use
    useInternalInfrastructure = false;
    useSecrets = false;
    useSharedKey = false;

    # Configure system preferences
    waylandSupport = true;
    useGraphicalSystem = true;

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
