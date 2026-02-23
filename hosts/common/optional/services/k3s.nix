{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    k3s_1_35
    cifs-utils
    nfs-utils
  ];

  services.k3s = {
    enable = true;
    role = "agent";
    # Add this before running
    token = "";
    serverAddr = "https://rashid:6443";
  };
}
