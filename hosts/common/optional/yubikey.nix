{ pkgs, ... }:
{
  # yubikey login / sudo
  security.pam = {
    u2f = {
      enable = true;
      settings.cue = true;
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  environment.systemPackages = with pkgs; [ yubikey-manager ];
}
