{ config, ... }:
{
  programs.ghostty = {
    enable = false;

    settings = {
      theme = "catppuccin-mocha";
      font-family = config.hostSpec.font;
      font-size = 14;
      initial-command = "tmux";
    };
  };
}
