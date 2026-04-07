{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ hoppscotch ];
}
