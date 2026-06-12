{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    k3s_1_36
    cifs-utils
    nfs-utils
  ];

  services.k3s = {
    enable = true;
    role = "agent";
    # Add this before running
    token = "";
    serverAddr = "https://192.168.18.2:6443";
  };
}
