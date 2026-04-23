{ config, pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];

  home.sessionVariables.EDITOR = "nvim";

  home.file = {
    ".local/bin/vi".source = "${pkgs.neovim}/bin/nvim";
    ".local/bin/vim".source = "${pkgs.neovim}/bin/nvim";
    "${config.xdg.configHome}/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/nix-config/dotfiles/nvim";
  };
}
