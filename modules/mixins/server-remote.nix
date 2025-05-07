{
  config,
  inputs,
  ...
}:
let
  inherit (config.hokage) userLogin;
in
{
  imports = [
    ./server-common.nix
  ];

  # Enable QEMU guest services (qemu-guest-agent) for Netcup
  services.qemuGuest.enable = true;

  # https://mynixos.com/options/services.openssh
  services.openssh = {
    listenAddresses = [
      {
        addr = "0.0.0.0";
        port = 2222;
      }
    ];
  };

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    allowedTCPPorts = [ 2222 ]; # SSH
  };

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # Yubikey public key
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@yubikey"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7 omega@rsa"
      # Semaphore public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzO+EWuGkod47PvcI+ncJ11LTOMdlI4huXE4EWEaVoT omega@semaphore"
    ];
  };
}
