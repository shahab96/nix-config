{
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprshot
    hyprlock
    hypridle
    hyprpolkitagent
    mako
    waybar
    wofi
  ];
}
