{
  config,
  lib,
  pkgs,
  ...
}: {
  home = {
    file = {
      "${config.xdg.configHome}/tmux".source =
        lib.custom.relativeToRoot "dotfiles/tmux";
    };

    packages = with pkgs; [tmux];
  };
}
