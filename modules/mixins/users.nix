{ config, pkgs, inputs, ... }:

{
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ?passwd?.
  users.users.omega = {
    isNormalUser = true;
    description = "omega";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
    # Yubikey public key
    openssh.authorizedKeys.keys = ["sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work"];
  };
}
