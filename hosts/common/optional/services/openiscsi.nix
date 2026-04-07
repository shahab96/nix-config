{ config, ... }:
let
  hostName = config.hostSpec.hostName;
in
{
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${hostName}";
  };
}
