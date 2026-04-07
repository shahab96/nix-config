{ pkgs, ... }:
{
  services.netbird.enable = true;

  environment.systemPackages = with pkgs; [ netbird-ui ];
}
