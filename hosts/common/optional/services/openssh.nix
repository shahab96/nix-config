{ config, ... }:
let
  sshPort = config.hostSpec.networking.ports.tcp.ssh;
in
{
  services.openssh = {
    enable = true;
    ports = [ sshPort ];

    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };

    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ sshPort ];
}
