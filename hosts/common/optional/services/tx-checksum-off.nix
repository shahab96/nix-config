{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ethtool ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp1s0", RUN+="${pkgs.ethtool}/bin/ethtool -K enp1s0 tx off"
  '';
}
