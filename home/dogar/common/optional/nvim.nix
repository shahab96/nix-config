{config, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Create a symlink from ~/.config/nvim to the dotfiles directory
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/git/nix-config/dotfiles/nvim";
}
