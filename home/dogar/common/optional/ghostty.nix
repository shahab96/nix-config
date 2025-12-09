{config, ...}: {
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "catppuccin-mocha";
      font-family = config.hostSpec.font;
      font-size = 14;
      initial-command = "tmux";
    };
  };
}
