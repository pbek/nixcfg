{ config, inputs, username, ... }:
{
  imports = [
    ./server-common.nix
  ];

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 ]; # SSH
  };

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      # Yubikey public key
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@yubikey"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7 omega@rsa"
      # Legacy RSA public key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYsC+RPXB97SWZwKfeVTAyBjnyyFeoJoioVdyX1TwLQWRX/1RQdEfvT7dG8VEE5R141U5Xig6EFZ0r9wxvJhdyJcrlSasDWK8SEwxUmwi++YU8+63cruV4/3lSmBSoVT++HnDI9LAx8a4IudO4FMYS2f2VWXe22e2mmuFmm46JvLSTQp02yJo19EGiQXoQgnRjqcLGk50QY9S04xRZNML84+iDCO061gCxIqw2y+wSW3nJOJIuNhgTYTCKKBXYS/6W220EKe5IP+l2VpIW02RInNEPwT/HY2Who/XLtAu0weLO7n+P4M+LUWhRJGju994pYpNLd8kawVRdSBWp6rl9 omega@tuvb"
      # Semaphore public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzO+EWuGkod47PvcI+ncJ11LTOMdlI4huXE4EWEaVoT omega@semaphore"
    ];
  };
}
