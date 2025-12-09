{config, ...}: {
  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;
    settings = {
      font = config.hostSpec.font;
      shell = "tmux";
      font-size = 16.0;
      active_border_color = "#44ffff";
      single_window_margin_width = 0;
    };
  };
}
