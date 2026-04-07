{ pkgs, ... }:
{
  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
  security.rtkit.enable = true;

  environment.systemPackages = builtins.attrValues { inherit (pkgs) pavucontrol; };
}
