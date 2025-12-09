{
  config,
  lib,
  pkgs,
  ...
}: {
  home = {
    file = {
      "${config.xdg.configHome}/hypr/hyprland.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/hypr/hyprland.conf"}";
      "${config.xdg.configHome}/hypr/hypridle.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/hypr/hypridle.conf"}";
      "${config.xdg.configHome}/hypr/hyprlock.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/hypr/hyprlock.conf"}";
      "${config.xdg.configHome}/waybar".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/waybar"}";
      "${config.xdg.configHome}/wofi".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/wofi"}";
      "${config.xdg.configHome}/mako".source =
        config.lib.file.mkOutOfStoreSymlink "${lib.custom.relativeToRoot "dotfiles/mako"}";
    };

    packages = with pkgs; [
      hyprshot
      hyprlock
      hypridle
      hyprpolkitagent
      waybar
      wofi
      mako
    ];
  };
}
