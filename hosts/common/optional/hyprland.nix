{
  inputs,
  pkgs,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.setPath.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    hyprlock.enable = true;
  };

  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprshot
    hyprpolkitagent
    mako
    waybar
    wofi
  ];
}
