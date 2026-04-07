{ ... }:
{
  services.blueman.enable = true;
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
}
